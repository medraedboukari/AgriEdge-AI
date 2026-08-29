from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import numpy as np
import cv2
import tensorrt as trt
import pycuda.driver as cuda
import pycuda.autoinit
import time
import smbus2
import bme680
import uvicorn

# ============================================================
# Configuration
# ============================================================
ENGINE_PATH = '/home/medraedboukari/best_yolo11n_fp16_416.engine'
INPUT_SIZE = (416, 416)
CONF_THRESH = 0.5
IOU_THRESH = 0.45

CLASSES = [
    'Chlorosis', 'Water Excess', 'Sun Excess', 'Harmful Insects',
    'Water Deficiency', 'Sun Deficiency', 'Powdery Mildew', 'Parasites',
    'Abnormal Redness', 'Bacterial Spot', 'Early Blight', 'Healthy',
    'Late Blight', 'Leaf Mold', 'Leaf Miner', 'Mosaic Virus',
    'Septoria', 'Spider Mites', 'Yellow Leaf Curl', 'CBB',
    'CBSD', 'CGM', 'CMD', 'CASSAVA_HEALTHY'
]

# ============================================================
# TensorRT Engine
# ============================================================
def load_engine(engine_path):
    logger = trt.Logger(trt.Logger.WARNING)
    with open(engine_path, 'rb') as f:
        runtime = trt.Runtime(logger)
        engine = runtime.deserialize_cuda_engine(f.read())
    print("✅ TensorRT engine chargé")
    return engine

def preprocess(img):
    img_resized = cv2.resize(img, INPUT_SIZE)
    img_rgb = cv2.cvtColor(img_resized, cv2.COLOR_BGR2RGB)
    img_norm = img_rgb.astype(np.float32) / 255.0
    img_t = np.transpose(img_norm, (2, 0, 1))
    return np.ascontiguousarray(np.expand_dims(img_t, 0))

def infer(engine, input_data):
    context = engine.create_execution_context()
    input_idx = engine.get_binding_index('images')
    output_idx = engine.get_binding_index('output0')
    output_shape = engine.get_binding_shape(output_idx)

    d_input = cuda.mem_alloc(input_data.nbytes)
    output = np.empty(output_shape, dtype=np.float32)
    d_output = cuda.mem_alloc(output.nbytes)

    stream = cuda.Stream()
    cuda.memcpy_htod_async(d_input, input_data, stream)
    context.execute_async_v2(
        bindings=[int(d_input), int(d_output)],
        stream_handle=stream.handle
    )
    cuda.memcpy_dtoh_async(output, d_output, stream)
    stream.synchronize()
    return output

def postprocess(output, orig_shape):
    predictions = output[0]
    boxes, scores, class_ids = [], [], []
    orig_h, orig_w = orig_shape[:2]
    scale_x = orig_w / INPUT_SIZE[0]
    scale_y = orig_h / INPUT_SIZE[1]

    for i in range(predictions.shape[1]):
        pred = predictions[:, i]
        class_scores = pred[4:]
        class_id = int(np.argmax(class_scores))
        confidence = float(class_scores[class_id])

        if confidence > CONF_THRESH:
            cx, cy, w, h = pred[0], pred[1], pred[2], pred[3]
            x1 = int((cx - w/2) * scale_x)
            y1 = int((cy - h/2) * scale_y)
            x2 = int((cx + w/2) * scale_x)
            y2 = int((cy + h/2) * scale_y)
            boxes.append([x1, y1, x2-x1, y2-y1])
            scores.append(confidence)
            class_ids.append(class_id)

    results = []
    if boxes:
        indices = cv2.dnn.NMSBoxes(boxes, scores, CONF_THRESH, IOU_THRESH)
        if len(indices) > 0:
            for i in indices.flatten():
                results.append({
                    'class': CLASSES[class_ids[i]],
                    'confidence': round(scores[i], 3),
                    'box': {
                        'x': boxes[i][0], 'y': boxes[i][1],
                        'w': boxes[i][2], 'h': boxes[i][3]
                    }
                })
    return results

# ============================================================
# BME680
# ============================================================
def read_bme680():
    try:
        sensor = bme680.BME680(bme680.I2C_ADDR_SECONDARY)
        sensor.set_humidity_oversample(bme680.OS_2X)
        sensor.set_pressure_oversample(bme680.OS_4X)
        sensor.set_temperature_oversample(bme680.OS_8X)
        sensor.set_filter(bme680.FILTER_SIZE_3)
        if sensor.get_sensor_data():
            return {
                'temperature': round(sensor.data.temperature, 2),
                'humidity': round(sensor.data.humidity, 2),
                'pressure': round(sensor.data.pressure, 2),
                'gas_resistance': round(sensor.data.gas_resistance, 2)
            }
    except Exception as e:
        return {'error': str(e)}
    return {}

# ============================================================
# FastAPI App
# ============================================================
app = FastAPI(
    title="AgriEdge-AI API",
    description="Plant Disease Detection API - YOLO11n TensorRT on Jetson Nano",
    version="1.0.0"
)

# Charger l'engine au démarrage
engine = load_engine(ENGINE_PATH)

@app.get("/")
def root():
    return {"message": "AgriEdge-AI API is running", "model": "YOLO11n TensorRT FP16"}

@app.get("/health")
def health():
    return {"status": "ok", "engine": "loaded"}

@app.get("/environment")
def get_environment():
    data = read_bme680()
    return JSONResponse(content={"environmental_data": data})

@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    start = time.time()

    # Lire image
    contents = await file.read()
    nparr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if img is None:
        return JSONResponse(status_code=400, content={"error": "Invalid image"})

    orig_shape = img.shape

    # Inférence
    input_data = preprocess(img)
    output = infer(engine, input_data)
    detections = postprocess(output, orig_shape)

    # Données environnementales
    env_data = read_bme680()

    elapsed = time.time() - start

    return JSONResponse(content={
        "detections": detections,
        "count": len(detections),
        "inference_time_ms": round(elapsed * 1000, 2),
        "environmental_data": env_data,
        "model": "YOLO11n TensorRT FP16 416x416"
    })

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
