/* Laser driver with LED indicator 
 *  modified from LaserFlashtrainDriver to gate the flashtrain on and off at a 
 *  2 second square duty cycle
 *  the idea is that maybe flashtrain onset is the effective part, we are trying 
 *  to mimic the manual turning on and off that Lauren & Netanya did summer 2017 
Generates a continuous flashtrain to drive a laser with 5V TTL pulses.
Is switched on/off with a physical switch.
Also puts out an identical train to drive an LED as a laser monitor.
mw 07.11.2017

 * pushbutton attached to pin 2 from +5V
 * 10K resistor attached to pin 2 from ground

flash rate = 1000/(PulseDur+PulseInterval)
if PulseDur and PulseInterval =5, then rate=100 Hz
*/

const int LEDOutPin = 13;       // pin to drive LED
const int LEDOutPin2 = 11;       // pin to drive LED
const int LaserOutPin = 12;       // pin to drive Laser
const int SwitchPin = 2;     // pin attached to switch
const int PulseDur = 5;       // pulse duration in ms
const int PulseInterval = 5;       // inter-pulse interval in ms


// variables will change:
int SwitchState = 0;         // variable for reading the switch status

void setup() {
  // initialize the LED as an output:
  pinMode(LEDOutPin, OUTPUT);
  pinMode(LEDOutPin2, OUTPUT);
  pinMode(LaserOutPin, OUTPUT);
  pinMode(SwitchPin, INPUT);     
}

void loop() {
    // read the state of the pushbutton value:
 SwitchState = digitalRead(SwitchPin);

  if (SwitchState == HIGH) {     

for (int i=0; i <200; i++) {
digitalWrite(LEDOutPin, HIGH);
    digitalWrite(LEDOutPin2, HIGH);
    digitalWrite(LaserOutPin, HIGH);
    delay(PulseDur); 

    digitalWrite(LEDOutPin, LOW);
    digitalWrite(LEDOutPin2, LOW);
    digitalWrite(LaserOutPin, LOW);
    delay(PulseInterval); 
}
delay (2000);
  }
  else {
    digitalWrite(LEDOutPin, LOW);
    digitalWrite(LEDOutPin2, LOW);
    digitalWrite(LaserOutPin, LOW);
  }
  }

