import serial
import re

def parse_sensor_data(line):
    try:
        match = re.search(r'Received:\s*([\d.]+),([\d.]+),([\d.]+),([\d.]+)\s*\|\s*RSSI:\s*(-?\d+)', line)
        if match:
            return {
                'temperature': float(match.group(1)),
                'humidity': float(match.group(2)),
                'pressure': float(match.group(3)),
                'gas_resistance': float(match.group(4)),
                'rssi': int(match.group(5))
            }
    except Exception:
        pass
    return None

ser = serial.Serial('/dev/ttyTHS1', 115200, timeout=5)
print("Port ouvert, en attente de donnees...")

for i in range(10):
    line = ser.readline().decode('utf-8', errors='ignore')
    if line:
        data = parse_sensor_data(line)
        if data:
            print("Parse: T=" + str(data['temperature']) + " H=" + str(data['humidity']) +
                  " P=" + str(data['pressure']) + " Gas=" + str(data['gas_resistance']) +
                  " RSSI=" + str(data['rssi']))
        else:
            print("Format non reconnu: " + line.strip())
