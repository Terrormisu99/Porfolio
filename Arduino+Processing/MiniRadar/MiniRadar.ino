
#include <Servo.h>

//servo variables
Servo myservo;
int angle = 20;
int servopin = 3;
boolean dir = true;

////ultrasonic variables
//int TrigPin = 4;
//int EchoPin = 5;
//int MaxDist = 200;
//int TimeOut = MaxDist * 60;
//int SoundSpeed = 340;

int mag[50];//dataset of distances...to represent ultrasonic sensor readings

void setup() {

  myservo.attach(servopin);
  //  pinMode(TrigPin, OUTPUT);
  //  pinMode(EchoPin, INPUT);
  for (int i = 0; i < 50; i++) { //ultrasonic sensor was not working...dataset to represent changing distances
    mag[i] = random(0, 400);
  }
  Serial.begin(9600);

}

void loop() {

  if (dir) {
    for (int i = 20; i < 161; i++) { //CCW direction sweep
      angle = i;
      myservo.write(angle);
      Serial.print(angle); //get angle position of servo
      Serial.print(",");
      Serial.println(mag[random(0, 50)]); //get distance reading from ultrasonic sensor

      delay(50);
    }
    dir = false;//switch sweep direction
  } else {
    for (int i = 160; i > 19; i--) {//CW direction sweep
      angle = i;
      myservo.write(angle);
      Serial.print(angle);
      Serial.print(",");
      Serial.println(mag[random(0, 50)]);
      delay(10);


    }
    dir = true; //switch sweep direction
  }
}

//float GetSonar() {
//
//  unsigned long PingTime;
//  float distance;
//  digitalWrite(TrigPin, HIGH);
//  delayMicroseconds(10);
//  digitalWrite(TrigPin, LOW);
//  PingTime = pulseIn(EchoPin, HIGH, TimeOut);
//
//  distance = (float)PingTime * SoundSpeed / 2 / 10000;
//
//  return distance;
//}
