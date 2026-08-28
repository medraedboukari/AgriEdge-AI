#include <SPI.h>
#include <LoRa.h>

// SPI pins for SX1278 RA-02 (same wiring as node #1)
#define LORA_NSS   10
#define LORA_MOSI  11
#define LORA_SCK   12
#define LORA_MISO  13
#define LORA_DIO0  15
#define LORA_RST   16

#define LORA_FREQUENCY 433E6

// UART2 pins toward Jetson Nano
#define UART_TX_PIN 17
#define UART_RX_PIN 18

HardwareSerial JetsonSerial(2);  // Use UART2

void setup() {
  Serial.begin(115200);
  while (!Serial);

  JetsonSerial.begin(115200, SERIAL_8N1, UART_RX_PIN, UART_TX_PIN);

  SPI.begin(LORA_SCK, LORA_MISO, LORA_MOSI, LORA_NSS);
  LoRa.setPins(LORA_NSS, LORA_RST, LORA_DIO0);

  Serial.println("Initializing LoRa Gateway...");
  if (!LoRa.begin(LORA_FREQUENCY)) {
    Serial.println("LoRa init failed!");
    while (1);
  }
  Serial.println("LoRa Gateway ready, listening...");
}

void loop() {
  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    String received = "";
    while (LoRa.available()) {
      received += (char)LoRa.read();
    }

    int rssi = LoRa.packetRssi();

    Serial.print("Received: ");
    Serial.print(received);
    Serial.print(" | RSSI: ");
    Serial.println(rssi);

    // Forward to Jetson Nano via UART2
    JetsonSerial.println(received);
  }
}

