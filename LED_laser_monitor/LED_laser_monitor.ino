/* LED indicator for laser
turns on an LED in response to square wave input from function generator.
This is mainly a way to make sure the voltage to the LED is always the same and 
doesn't go negative. (function generator is bipolar)
*/

const int  AnalogInPin = A1;    // the pin that the function generator signal is attached to
const int LEDOutPin = 0;       // pin to drive LED
const int LEDOutPin2 = 13;       // pin to drive LED
const int threshold = 200;       // 10 AD units is ~50 mV
int LEDValue=0;

void setup() {
  // initialize the LED as an output:
  pinMode(LEDOutPin, OUTPUT);
  pinMode(LEDOutPin2, OUTPUT);
}

void loop() {

  // read the value from the sensor:
  LEDValue = analogRead(AnalogInPin);
  if (LEDValue>threshold) {
    digitalWrite(LEDOutPin, HIGH);
    digitalWrite(LEDOutPin2, HIGH);
  }
  else if (LEDValue<=threshold) {
    digitalWrite(LEDOutPin, LOW);
    digitalWrite(LEDOutPin2, LOW);
  }
}
