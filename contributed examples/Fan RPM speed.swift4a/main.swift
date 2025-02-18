import AVR

SetupSerial()

print(message: "Fan RPM Monitor")

func printRPM(rpm: UInt16) {
  print(rpm, addNewline: false)
  print(message: "RPM")
}

// set pin 4 as input with pullup activated and setup Timer0 to count pulses on pin 4 coming from the fan tacho
pinMode(pin: 4, mode: INPUT)
digitalWrite(pin: 4, value: HIGH)
timer0SetAsCounter(edgeType: RISING_EDGE)

// fire every 0.1 seconds, the count of pulses is twice the number
// of rotations, so rotations per second is count*5 and RPM is count*300
let multiplier: UInt16 = 300

setupTimeout(after: 100)

while true {
    if didTimeout() {
        let currentCount = currentTimer0Value()
        let rpm: UInt16 = UInt16(currentCount) * multiplier
        printRPM(rpm: rpm)
        timer0CounterReset()
        resetTimeoutFlag()
    }
}
