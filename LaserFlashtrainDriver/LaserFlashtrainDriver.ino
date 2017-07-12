/* Laser driver with LED indicator 
Generates a continuous flashtrain to drive a laser with 5V TTL pulses.
Is switched on/off with a physical switch.
Also puts out an identical train to drive an LED as a laser monitor.
mw 07.11.2017

 * pushbutton attached to pin 2 from +5V
 * 10K resistor attached to pin 2 from ground

*/

const int LEDOutPin = 13;       // pin to drive LED
const int LaserOutPin = 12;       // pin to drive Laser
const int SwitchPin = 2;     // pin attached to switch
const int PulseDur = 5;       // pulse duration in ms
const int PulseInterval = 5;       // inter-pulse interval in ms

// variables will change:
int SwitchState = 0;         // variable for reading the switch status

//flash rate = 1000/(PulseDur+PulseInterval)

void setup() {
  // initialize the LED as an output:
  pinMode(LEDOutPin, OUTPUT);
  pinMode(LaserOutPin, OUTPUT);
  pinMode(SwitchPin, INPUT);     
}

void loop() {
    // read the state of the pushbutton value:
 SwitchState = digitalRead(SwitchPin);

  if (SwitchState == HIGH) {     

    digitalWrite(LEDOutPin, HIGH);
    digitalWrite(LaserOutPin, HIGH);
    delay(PulseDur); 

    digitalWrite(LEDOutPin, LOW);
    digitalWrite(LaserOutPin, LOW);
    delay(PulseInterval); 
  }
  else {
    digitalWrite(LEDOutPin, LOW);
    digitalWrite(LaserOutPin, LOW);
  }
  }

