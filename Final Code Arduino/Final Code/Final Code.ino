#define PIR1_PIN 6  // PIR sensor 1 pin
#define PIR2_PIN 7  // PIR sensor 2 pin
#define LED_PIN 13  // LED pin

#include <LiquidCrystal.h>


// initialize the library by associating any needed LCD interface pin

// with the arduino pin number it is connected to

const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
int x = 0;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);


int counter = 0;  // Counter variable

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(9600);
  pinMode(PIR1_PIN, INPUT);
  pinMode(PIR2_PIN, INPUT);

  // following function set up the LCD columns and rows:
  lcd.begin(16, 2);
 
}

void loop() {
  int pir1State = digitalRead(PIR1_PIN);
  int pir2State = digitalRead(PIR2_PIN);

  lcd.setCursor(0,0); // set the cursor position
  lcd.print("VISITOR COUNT:"); //print the string on cursor position
  
  // Detect people entering the room
  if (pir1State == HIGH && pir2State == LOW) {
    delay(500);  // debounce delay
    if (digitalRead(PIR2_PIN) == LOW) {
      counter++;
      Serial.println("Person entered!");
      Serial.println(counter);
    }
  }

  // Detect people leaving the room
  if (pir2State == HIGH && pir1State == LOW) {
    delay(500);  // debounce delay
    if (digitalRead(PIR1_PIN) == LOW) {
      if(counter>0){
        counter--;
      }       
      
      Serial.println("Person left!");
      Serial.println(counter);
      
    }
  }
  
  lcd.setCursor(0,1);
  
  // Update the LED based on the counter value
  if (counter > 0) {
    digitalWrite(LED_PIN, HIGH);
    lcd.print(counter);
    
  } else {
    digitalWrite(LED_PIN, LOW);
    lcd.print(0);
    
  }

 
}


