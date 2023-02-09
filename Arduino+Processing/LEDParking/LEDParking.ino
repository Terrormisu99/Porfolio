/*===========================================================
BRIAN LUONG 2023 
=====================WIRING==================================
ESP8266 NodeMCU 1.0

LED data pin to 13 
             
ECHO to 9                     
TRIG to 10

LCD RS pin to digital pin 12
LCD Enable pin to digital pin 11
LCD D4 pin to digital pin 5
LCD D5 pin to digital pin 4
LCD D6 pin to digital pin 3
LCD D7 pin to digital pin 2
LCD R/W pin to ground
10K potentiometer:
 ends to +5V and ground
 wiper to LCD VO pin (pin 3)                     
=====================DESCRIPTION==============================
To be used as a parking assistant in small garages.
the LED strip should flash colors and change flashing 
rates as one gets closer to STOP_DIST.
-LCD to display the measured distance
=====================ADJUSTABLES===============================
STOP_DIST = set the distance (cm) for solid RED
NUM_LEDS = number of LEDs on the strip
CHIPSET = depends on the LED strip being used
STASSID = SSID of local network
STAPSK = password for local network

=====================NEXT STEPS===============================
-improve sensor accuracy based off temperature
-Build better enclosure
-add Wifi connection [DONE]
=============================================================*/
//=================LCD SETUP===============================================
//#include <LiquidCrystal.h>
//LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

#include <FastLED.h>
#define LED_PIN     13
#define NUM_LEDS    60
#define CHIPSET     WS2812B
CRGB leds[NUM_LEDS]; //EACH LED IS AN ELEMENT IN THIS ARRAY

//=================ULTRASONIC SETUP========================================
#define trigPin 5 // define TrigPin
#define echoPin 4 // define EchoPin.
#define MAX_DISTANCE 500 // Maximum sensor distance is rated at 400-500cm.
// define the timeOut according to the maximum range. timeOut= 2*MAX_DISTANCE /100 /340*1000000 = MAX_DISTANCE*58.8
#define STOP_DIST 20
float timeOut = MAX_DISTANCE * 60;
int soundVelocity = 340; // define sound speed=340m/s
float dist;

//=================WIFI SETUP==============================================
#include <ESP8266WiFi.h>

#ifndef STASSID
#define STASSID "VIRGIN252"
#define STAPSK "545A62D7A26F"
#endif
const char* ssid = STASSID;
const char* password = STAPSK;
WiFiServer server(80);

//=================LED STRIP FUNCTIONS================================================
void showRed(){
  FastLED.clear();
  for (int i=0; i<NUM_LEDS; i++){
    leds[i]=CRGB::Green;
  }
  FastLED.show(12);
}

void showYellow(){
  FastLED.clear();
  for (int i=20; i<NUM_LEDS-20; i++){
    leds[i]=CRGB::Yellow;
  }
  FastLED.show(12);
}

void showGreen(){
  FastLED.clear();
  for (int i=25; i<NUM_LEDS-25; i++){
    leds[i]=CRGB::Red;
  }
  FastLED.show(12);
}

//=================ULTRASONIC FUNCTIONS================================================
float getSonar() {
   unsigned long pingTime;
   float distance;
   digitalWrite(trigPin, HIGH); // make trigPin output high level lasting for 10μs to
//  triger HC_SR04,
   delayMicroseconds(10);
   digitalWrite(trigPin, LOW);
   pingTime = pulseIn(echoPin, HIGH, timeOut); // Wait HC-SR04 returning to the high level
//  and measure out this waitting time
   distance = (float)pingTime * soundVelocity / 2 / 10000; // calculate the distance
//  according to the time
   return distance; // return the distance value
}

//$$$$$$$$$$$$$$$$$$$$$$$---HTTP FUNCTIONS---$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
String prepareHtmlPage(float dist)
{
  String htmlPage;
  htmlPage.reserve(1024);               // prevent ram fragmentation
  htmlPage = F("HTTP/1.1 200 OK\r\n"
               "Content-Type: text/html\r\n"
               "Connection: close\r\n"  // the connection will be closed after completion of the response
               "Refresh: 5\r\n"         // refresh the page automatically every 5 sec
               "\r\n"
               "<!DOCTYPE HTML>"
               "<html>"
               "Distance:  ");
  htmlPage += dist;
  htmlPage += F("</html>"
                "\r\n");
  return htmlPage;
}

void SendResponse(float dist){
  WiFiClient client = server.accept();
  // wait for a client (web browser) to connect
  if (client)
  {
    Serial.println("\n[Client connected]");
    while (client.connected())
    {
      // read line by line what the client (web browser) is requesting
      if (client.available())
      {
        String line = client.readStringUntil('\r');
        Serial.print(line);
        // wait for end of client's request, that is marked with an empty line
        if (line.length() == 1 && line[0] == '\n')
        {
          client.println(prepareHtmlPage(dist));
          break;
        }
      }
    }

    while (client.available()) {
      // but first, let client finish its request
      // that's diplomatic compliance to protocols
      // (and otherwise some clients may complain, like curl)
      // (that is an example, prefer using a proper webserver library)
      client.read();
    }

    // close the connection:
    client.stop();
    Serial.println("[Client disconnected]");
  }
}








//**************************START OF SETUP AND LOOP********************************************
void setup() {
 pinMode(trigPin,OUTPUT);// set trigPin to output mode
 pinMode(echoPin,INPUT); // set echoPin to input mode

 FastLED.addLeds<CHIPSET, LED_PIN, RGB>(leds, NUM_LEDS);

// lcd.begin(16, 2);

 Serial.begin(115200); // Open serial monitor at 9600 baud to see ping results.

 Serial.printf("Connecting to %s ", ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" connected");

  server.begin();
  Serial.printf("Web server started, open %s in a web browser\n", WiFi.localIP().toString().c_str());
}


void loop() {
  //KEEP CHECKING THE DISTANCE AND UPDATE THE LEDS BASED OFF THE RANGES
   delay(200);
   dist=getSonar();

//   lcd.clear();
//   lcd.print("Dist:");
//   lcd.print(dist);

  if (dist>120){
    Serial.print(dist);
    Serial.println("--greater than 150");
    showGreen();

  }else if (dist <120 and dist >50){
    Serial.print(dist);
    Serial.println("--less than 150 but greater than 50");
    showYellow();
    

  } else if(dist<=STOP_DIST){
    //IF IT HITS STOP LIMIT MAKE IT SOLID RED
    Serial.print(dist);
    Serial.println("--Met  STop limit");
    showRed();
    delay(5000);
    
  }else{
    Serial.print(dist);
    Serial.println("--less than 50");
    showRed();

  }
  //PULSE THE COLORS BASED OFF HOW CLOSE WE ARE
  delay(map(dist,0,300,0.1,1000));
//  FastLED.clear(true);
  SendResponse(dist);
}
