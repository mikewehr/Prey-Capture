/* LED indicator for laser
turns on an LED in response to square wave input from function generator.
This is mainly a way to make sure the voltage to the LED is always the same and 
doesn't go negative. (function generator is bipolar)
*/

const int  AnalogInPin = A1;    // the pin that the function generator signal is attached to
const int LEDOutPin = 1;       // pin to drive LED
const int threshold = 10;       // 10 AD units is ~50 mV

void setup() {
  // initialize the LED as an output:
  pinMode(LEDOutPin, OUTPUT);
}

void loop() {
  // read the value from the sensor:
  LEDValue = analogRead(AnalogInPin);
  if (LEDValue>threshold) {
    digitalWrite(LEDOutPin, HIGH);
  }
  else if (LEDValue<=threshold) {
    digitalWrite(LEDOutPin, LOW);
  }

