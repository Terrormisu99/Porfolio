#include <Servo.h>
Servo myservo;
float angle;
int servopin=3;

void setup() {
  myservo.attach(servopin);
  pinMode(A0,INPUT);
  Serial.begin(9600);
}
void loop() {

while (Serial.available() <=0);
  angle=Serial.read();
  myservo.write(angle);
}
