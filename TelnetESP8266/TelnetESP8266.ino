#include <SoftwareSerial.h>

SoftwareSerial BT1(11, 10); // RX | TX

#define INPUT_SIZE 30
#define FRONT_PIN 0
#define BACK_PIN 1
#define LEFT_PIN 2
#define RIGHT_PIN 3
#define LIGHT_PIN 1

String W; char w;

void setup(){ 
  
  pinMode(FRONT_PIN, OUTPUT);
  pinMode(BACK_PIN, OUTPUT);
  pinMode(LEFT_PIN, OUTPUT);
  pinMode(RIGHT_PIN, OUTPUT);
  pinMode(LIGHT_PIN, OUTPUT);
  
  Serial.begin(9600);
  BT1.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  delay(1500);
  SetUpWIFI() ;
}

void loop()
{
  if (BT1.available()) // Lo que entra por WIFI 
  { w = BT1.read() ;
    W.concat(w);
  }
  if (w == '\n' || w == '\r') // Si han pulsado intro
  {
    Serial.println(W);
    if(W.indexOf("MO")>=0)
    {
      Serial.print("\nMove ");
      Serial.print(W.substring(2).toInt());
      Serial.print(" blocks\n");
      received();
      
    }
    else if(W.indexOf("LE")>=0)
    {
      Serial.println("Turn Left");
      received();
    }
    else if(W.indexOf("RI")>=0)
    {
      Serial.println("Turn right");
      received();
    }
    else if(W.indexOf("ON")>=0)
    {
      digitalWrite( 12, HIGH);
      received();
    }
    else if(W.indexOf("OFF")>=0)
    {
      digitalWrite( 12, LOW);
      received();
    }
    W = " "; w = ' ';
  }
}
void printCommand(char*command, int args)
{
    Serial.print("\nCommand: ");
    Serial.print(command);
    Serial.print(", args:");
    Serial.print(args);
    Serial.print("\n");
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

void SetUpWIFI()
{ String ordenes[] =
  {
    "AT",
    "AT+CWMODE=3",
    "AT+CWJAP=\"Fab2903\",\"Galaxys4\"",
    "AT+CIPMUX=1",
    "AT+CIPSERVER=1,23",
    "END" // Para reconocer el fin de los comandos AT
  };
  int index = 0;
  while (ordenes[index] != "END")
  { BT1.println(ordenes[index++]);
    while ( true)
    { String s = GetLineWIFI();
      if ( s != "") Serial.println(s);
      if ( s.indexOf("no change") >=0)
        break;
      if ( s.indexOf("OK")>=0)
        break;
      if ( s.indexOf("ready")>=0)
        break;
      // if (millis()-T >10000) break;
    }
    Serial.println("========");
  }
    //BT1.println("AT+CIFSR");

}
