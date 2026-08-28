#include <Wire.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BME680.h"
#include <SPI.h>
#include <LoRa.h>

// I2C pins for BME680
#define I2C_SDA 8
#define I2C_SCL 9

// SPI pins for SX1278 RA-02
#define LORA_NSS   10
#define LORA_MOSI  11
#define LORA_SCK   12
#define LORA_MISO  13
#define LORA_DIO0  15
#define LORA_RST   16

#define LORA_FREQUENCY 433E6

Adafruit_BME680 bme;

void setup() {
  Serial.begin(115200);
  while (!Serial);

  // I2C init for BME680
  Wire.begin(I2C_SDA, I2C_SCL);

  Serial.println("Initializing BME680...");
  if (!bme.begin(0x77)) {
    Serial.println("BME680 sensor not detected!");
    while (1);
  }
  bme.setTemperatureOversampling(BME680_OS_8X);
  bme.setHumidityOversampling(BME680_OS_2X);
  bme.setPressureOversampling(BME680_OS_4X);
  bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
  bme.setGasHeater(320, 150);
  Serial.println("BME680 initialized successfully!");

  // SPI init for LoRa
  SPI.begin(LORA_SCK, LORA_MISO, LORA_MOSI, LORA_NSS);
  LoRa.setPins(LORA_NSS, LORA_RST, LORA_DIO0);

  Serial.println("Initializing LoRa...");
  if (!LoRa.begin(LORA_FREQUENCY)) {
    Serial.println("LoRa init failed!");
    while (1);
  }
  LoRa.setTxPower(10);  // 10 dBm
  Serial.println("LoRa initialized successfully!");
}

void loop() {
  if (!bme.performReading()) {
    Serial.println("BME680 reading error");
    delay(2000);
    return;
  }

  float temperature = bme.temperature;
  float humidity = bme.humidity;
  float pressure = bme.pressure / 100.0;
  float gas = bme.gas_resistance / 1000.0;

  // Build a compact CSV payload: T,H,P,G
  String payload = String(temperature, 2) + "," +
                    String(humidity, 2) + "," +
                    String(pressure, 2) + "," +
                    String(gas, 2);

  Serial.print("Sending: ");
  Serial.println(payload);

  LoRa.beginPacket();
  LoRa.print(payload);
  LoRa.endPacket();

  delay(5000);  // Send every 5 seconds
}
