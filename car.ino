const int FRONT_PIN 0; 
const int BACK_PIN 1;
const int LEFT_PIN 2;
const int RIGHT_PIN 3;
const int LIGHT_PIN 1;

/**@brief goes back or forward but turning left or right
 * @param const int directionPin: FRONT_PIN or BACK_PIN
 * @param const int sidePin: LEFT_PIN or RIGHT_PIN
 */
void turn(const int directionPin, const int directionPin){
  digitalWrite(directionPin, HIGH);
  digitalWrite(sidePin, HIGH);
  delay(8000);
  digitalWrite(directionPin, LOW);
  digitalWrite(sidePin, LOW);
}

/**@brief it movilizes a determined quantity of blocks
 * @param const int directionPin: LEFT_PIN or RIGHT_PIN
 * @param int blocks: a block means two seconds
 */
void go(const int directionPin, int blocks){
  digitalWrite(directionPin, HIGH);
  delay(blocks*2000);
  digitalWrite(directionPin, LOW);
} 

/**@brief changes the light state
 * @param int state: HIGH or LOW
 */
void chageLightState(int state){
  digitalWrite(directionPin, state);
} 

/**@brief initializes the pins
*/
void setup() {
  pinMode(FRONT_PIN, OUTPUT);
  pinMode(BACK_PIN, OUTPUT);
  pinMode(LEFT_PIN, OUTPUT);
  pinMode(RIGHT_PIN, OUTPUT);
  pinMode(LIGHT_PIN, OUTPUT);
}

void loop() {}
