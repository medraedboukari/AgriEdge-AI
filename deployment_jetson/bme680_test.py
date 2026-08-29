import time
import board
import busio
import adafruit_bme680

# Initialisation I2C
i2c = busio.I2C(board.SCL, board.SDA)

# BME680 à l'adresse 0x77
bme = adafruit_bme680.Adafruit_BME680_I2C(
    i2c,
    address=0x77
)

# Configuration du chauffage du capteur de gaz
bme.set_gas_heater(320, 150)

print("BME680 demarre...")
print("Adresse I2C : 0x77")
print("Bus I2C : /dev/i2c-1")
print()

while True:

    print("--------------------------------")

    print("Temperature : {:.2f} °C".format(
        bme.temperature
    ))

    print("Humidite    : {:.2f} %".format(
        bme.humidity
    ))

    print("Pression    : {:.2f} hPa".format(
        bme.pressure
    ))

    print("Gaz         : {:.2f} kOhms".format(
        bme.gas / 1000
    ))

    print("--------------------------------")

    time.sleep(2)
