# 🌱 AgriEdge-AI

**A complete, fully offline Edge AI + IoT system for multi-crop plant disease detection.**

AgriEdge-AI combines computer vision, embedded deployment, wireless IoT sensing, and mobile application development into a single validated end-to-end system — designed to run entirely without cloud dependency, for use in connectivity-constrained agricultural regions.

> 🎓 Developed as part of an R&D internship at ESPRIT (Tunisia). Abstract submitted to the **embedded world Conference 2027** (Nuremberg, Germany).

---

## 🚀 What it does

1. A **BME680 environmental sensor** (temperature, humidity, pressure, gas resistance) attached to an **ESP32-S3** reads real-time field data.
2. Data is transmitted wirelessly via **LoRa (SX1278, 433 MHz)** to a gateway node.
3. The gateway relays data over **UART** to an **NVIDIA Jetson Nano**.
4. A user photographs a plant leaf via the **mobile app**; the image is sent to a **FastAPI** server running on the Jetson.
5. **YOLO11n**, optimized with **TensorRT (FP16)**, detects the disease in **235 ms**.
6. The diagnosis, enriched with live environmental context, is returned and displayed on the mobile app.

---

## 📊 Key Results

| Component | Result |
|---|---|
| Dataset | 47,813 images, 24 disease classes, fused from 9 public sources |
| Best model | YOLO11n, mAP50 = 0.659 (2.6M params) |
| Edge inference (Jetson Nano, TensorRT FP16, 416x416) | 31 FPS (55% above real-time target) |
| LoRa link | RSSI: -67 to -78 dBm, reliable transmission |
| End-to-end API response (image + sensor data) | 235.8 ms |
| Mobile app | Tested end-to-end on physical Android device |

Two exploratory architectures were also evaluated and transparently reported, including a negative result:
- **AgriYOLO** (YOLO11n + EfficientNet-B0 dual-backbone fusion): mAP50 = 0.486
- **YOLO11n_Opt** (scale-reduced variant, 1.5M params): mAP50 = 0.570, up to 50 FPS at 416x416

---

## 🏗️ System Architecture

```
BME680 (I2C) -> ESP32-S3 #1 -> LoRa 433MHz -> ESP32-S3 #2 -> UART -> Jetson Nano
                                                                          |
                                                    YOLO11n + TensorRT + FastAPI
                                                                          |
                                                                  WiFi -> Mobile App
```

---

## 🛠️ Tech Stack

**Vision & ML:** YOLOv8/YOLO11 (Ultralytics), PyTorch, TensorRT, OpenCV
**Embedded:** NVIDIA Jetson Nano, ESP32-S3, C++ (Arduino/PlatformIO)
**IoT:** LoRa (SX1278), BME680, UART
**Backend:** Python, FastAPI, PyCUDA
**Mobile:** Flutter, Dart
**Hardware Design:** KiCad

---

## 📁 Repository Structure

```
AgriEdge-AI/
  data/                 - Dataset fusion and preprocessing scripts
  training/              - Model training notebooks (ablation study, AgriYOLO, YOLO11n_Opt)
  deployment_jetson/     - TensorRT export, FastAPI server, UART listener
  firmware/               - ESP32-S3 sensor node and LoRa gateway code
  mobile_app/             - Flutter application (agri_ai_app)
  hardware/                - KiCad schematics
  docs/                     - Report, article, figures
```

---

## 📄 Documentation

- 📘 Full internship report (French) - `docs/report/main.tex`
- 📄 Scientific article (MDPI format, in preparation) - `docs/article/article.tex`

---

## 👤 Author

**Mohamed Raed Boukari** - Engineering Student, ESPRIT (Tunisia)
Supervised by Mme. Oumaima Jouini and Mme. Imen Bouabidi (ESPRIT, Department of Telecommunications)

📫 mohamedraed.boukari@esprit.tn | [LinkedIn](https://linkedin.com/in/medraedboukari)

---

## 📜 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Datasets used are publicly available under CC BY 4.0 licenses (see dataset sources in the report).
