int xPin = 1;
int yPin = 0;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print(analogRead(xPin));
  Serial.print(",");
  Serial.println(analogRead(yPin));

  delay(10);
}
