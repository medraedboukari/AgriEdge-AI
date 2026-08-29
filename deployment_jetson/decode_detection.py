import json
import numpy as np
import cv2

CLASSES = [
    'Chlorosis', 'Water Excess', 'Sun Excess', 'Harmful Insects',
    'Water Deficiency', 'Sun Deficiency', 'Powdery Mildew', 'Parasites',
    'Abnormal Redness', 'Bacterial Spot', 'Early Blight', 'Healthy',
    'Late Blight', 'Leaf Mold', 'Leaf Miner', 'Mosaic Virus',
    'Septoria', 'Spider Mites', 'Yellow Leaf Curl', 'CBB',
    'CBSD', 'CGM', 'CMD', 'CASSAVA_HEALTHY'
]

CONF_THRESH = 0.25
IOU_THRESH = 0.45
INPUT_SIZE = 640

def nms_numpy(boxes, scores, iou_thresh):
    x1, y1, x2, y2 = boxes[:,0], boxes[:,1], boxes[:,2], boxes[:,3]
    areas = (x2 - x1) * (y2 - y1)
    order = scores.argsort()[::-1]
    keep = []
    while order.size > 0:
        i = order[0]
        keep.append(i)
        xx1 = np.maximum(x1[i], x1[order[1:]])
        yy1 = np.maximum(y1[i], y1[order[1:]])
        xx2 = np.minimum(x2[i], x2[order[1:]])
        yy2 = np.minimum(y2[i], y2[order[1:]])
        w = np.maximum(0, xx2 - xx1)
        h = np.maximum(0, yy2 - yy1)
        inter = w * h
        iou = inter / (areas[i] + areas[order[1:]] - inter + 1e-6)
        order = order[1:][iou <= iou_thresh]
    return keep

with open('/home/medraedboukari/output.json') as f:
    data = json.load(f)

values = np.array(data[0]['values'], dtype=np.float32)
preds = values.reshape(1, 28, 8400)[0].T  # (8400, 28)

boxes = preds[:, :4]
scores = preds[:, 4:]

class_ids = np.argmax(scores, axis=1)
confidences = np.max(scores, axis=1)

mask = confidences > CONF_THRESH
boxes = boxes[mask]
confidences = confidences[mask]
class_ids = class_ids[mask]

print(f"Détections avant NMS: {len(boxes)}")

boxes_xyxy = np.zeros_like(boxes)
boxes_xyxy[:, 0] = boxes[:, 0] - boxes[:, 2] / 2
boxes_xyxy[:, 1] = boxes[:, 1] - boxes[:, 3] / 2
boxes_xyxy[:, 2] = boxes[:, 0] + boxes[:, 2] / 2
boxes_xyxy[:, 3] = boxes[:, 1] + boxes[:, 3] / 2

keep = nms_numpy(boxes_xyxy, confidences, IOU_THRESH)
print(f"Détections après NMS: {len(keep)}")

img = cv2.imread('/home/medraedboukari/test_images/plant_bfd17da3-f1c8-4a77-84b2-bf88edaff1e1___RS_L_Scorch-1455_flipLR_JPG.rf.ea6fca431bf1c1d7742c0258f412bce0.jpg')
orig_h, orig_w = img.shape[:2]
scale_x = orig_w / INPUT_SIZE
scale_y = orig_h / INPUT_SIZE

for i in keep:
    x1, y1, x2, y2 = boxes_xyxy[i]
    x1, x2 = int(x1 * scale_x), int(x2 * scale_x)
    y1, y2 = int(y1 * scale_y), int(y2 * scale_y)
    cls = class_ids[i]
    conf = confidences[i]
    label = f"{CLASSES[cls]}: {conf:.2f}"
    cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
    cv2.putText(img, label, (x1, max(y1-10, 10)), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

cv2.imwrite('/home/medraedboukari/detection_result_5.jpg', img)
print("✅ Résultat sauvegardé : detection_result_5.jpg")
