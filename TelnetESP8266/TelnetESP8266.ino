#include <SoftwareSerial.h>

SoftwareSerial BT1(11, 8); // RX | TX

#define INPUT_SIZE 30
#define FRONT_PIN 0
#define BACK_PIN 1
#define LEFT_PIN 2
#define RIGHT_PIN 3
#define LIGHT_PIN 4

String W; char w;
int start;
/**@brief goes back or forward but turning left or right
 * @param const int directionPin: FRONT_PIN or BACK_PIN
 * @param const int sidePin: LEFT_PIN or RIGHT_PIN
 */
void turn(const int directionPin, const int sidePin){
  digitalWrite(directionPin, HIGH);
  digitalWrite(sidePin, HIGH);
  delay(4000);
  digitalWrite(directionPin, LOW);
  digitalWrite(sidePin, LOW);
}

/**@brief it movilizes a determined quantity of blocks
 * @param const int directionPin: LEFT_PIN or RIGHT_PIN
 * @param int blocks: a block means two seconds
 */
void go(const int directionPin, int blocks){
  digitalWrite(!directionPin, LOW);
  digitalWrite(directionPin, HIGH);
  delay(blocks*2000);
  digitalWrite(directionPin, LOW);
}

/**@brief changes the light state
 * @param int state: HIGH or LOW
 */
void lights(int state){
  digitalWrite(LIGHT_PIN, state);
}

/**@brief initializes the pins
*/
void setup() {
  pinMode(FRONT_PIN, OUTPUT);
  pinMode(BACK_PIN, OUTPUT);
  pinMode(LEFT_PIN, OUTPUT);
  pinMode(RIGHT_PIN, OUTPUT);
  pinMode(LIGHT_PIN, OUTPUT);
  Serial.begin(9600);
  BT1.begin(9600);
  pinMode(13, OUTPUT);

  delay(1500);
  SetUpWIFI();
  start = 0;
}

void loop()
{
  if (BT1.available()) // Lo que entra por WIFI
  {
    w = BT1.read() ;
    W.concat(w);
  }
  // Si han pulsado intro
  if (w == '\n' || w == '\r') {
    Serial.println(W);
    if(W.indexOf("SA")>=0){
      start = 1;
      received();
    }
    else if(W.indexOf("MF")>=0){
      go(FRONT_PIN,5);
      received();
    }
    else if(W.indexOf("MB")>=0){
      go(BACK_PIN, 5);
      received();
    }
    else if(W.indexOf("LE")>=0){
      turn(FRONT_PIN, LEFT_PIN);
      received();
    }
    else if(W.indexOf("RI")>=0){
      turn(FRONT_PIN, RIGHT_PIN);
      received();
    }
    else if(W.indexOf("ON")>=0){
      lights(HIGH);
      received();
    }
    else if(W.indexOf("OFF")>=0){
      lights(LOW);
      received();
    }
    W = " "; w = ' ';
  }
}

void received()
{
  BT1.println("AT+CIPSEND=0,5\r");
  delay(50);
  BT1.print("REC\r\n");
  delay(50);
  BT1.flush();
}

String GetLineWIFI()
{ String S = "" ;
  if (BT1.available())
  { char c = BT1.read(); ;
    while ( c != '\n' ) //Hasta que el caracter sea intro
    { S = S + c ;
      delay(25) ;
      c = BT1.read();
    }
    return ( S ) ;
  }
}

void SetUpWIFI(){
  String ordenes[] =
          {
                  "AT",
                  "AT+CWMODE=3",
                  "AT+CWJAP=\"Fab2903\",\"Galaxys4\"",
                  "AT+CIPMUX=1",
                  "AT+CIPSERVER=1,23",
                  "END" // Para reconocer el fin de los comandos AT
          };
  int index = 0;
  while (ordenes[index] != "END"){
    BT1.println(ordenes[index++]);
    while (true){
      String s = GetLineWIFI();
      if ( s.indexOf("no change") >=0)
        break;
      if ( s.indexOf("OK")>=0)
        break;
      if ( s.indexOf("ready")>=0)
        break;
      // if (millis()-T >10000) break;
    }
  }
  //BT1.println("AT+CIFSR");

}