#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
//#include <Fonts/FreeSans9pt7b.h>

Adafruit_SSD1306 display = Adafruit_SSD1306(128,64,&Wire);
double pulse, frequency,capacitance,inductance,inductanceregressed,Error,inductanceuh,inductancenh,TIME=0;
double pulse1;
void OLED_Init()
{
 Serial.begin(9600);
 //Serial.println("OLED FEATHERWING TEST");
 display.begin(SSD1306_SWITCHCAPVCC,0x3C);   // OLED address
 display.clearDisplay();   
 //display.setFont(&FreeSans9pt7b);// set the Fonts
 display.setTextSize(1);
 display.setTextColor(WHITE);
 display.setCursor(0,0);
}

void setup() 
{
  // put your setup code here, to run once:
 OLED_Init();
 display.clearDisplay();
 pinMode(2,INPUT);
 pinMode(8,OUTPUT);
 ///key//////////////////////////
 //pinMode(7,INPUT_PULLUP);
 //pinMode(8,INPUT_PULLUP);
}

void loop() 
{   
  // put your main code here, to run repeatedly:
  digitalWrite(8,HIGH);
  delay(5);
  digitalWrite(8,LOW);
  delayMicroseconds(5);
  pulse = pulseIn(2,HIGH,5000);
    //////////////////////////////
    capacitance = 0.47E-6;  //102 0.001 103 0.01, 104 0.1, 105 1

    frequency = 1.E6/(2*pulse);
    inductance = 1./(capacitance*frequency*frequency*4*3.14159*3.14159);
    //Error=25.5258*inductance*inductance-4.5846*inductance+0.3356;
    //inductanceregressed=inductance/(1+Error);
    inductanceuh = inductance*1000000;
    inductancenh = inductance*1000000000;
    /////////////////////////////
  

  /*
    ///display////////////////////////////
    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextSize(2);
    display.print("Inductance");
    display.setCursor(0,20);
    display.print(inductanceuh);
    display.print("uH");
    display.setCursor(0,40);
    display.print(inductancenh);
    display.print("nH");
    display.display();
*/
     //testing/////////////////////////////


    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextSize(2);
    display.print("Period");
    display.setCursor(0,20);
    display.print(pulse*2);
    
    display.setTextSize(1);
    display.setCursor(0,40);
    display.print("inductance");
    display.setCursor(0,50);
    display.print(inductanceuh);
    display.print("uH");
    display.display();

    Serial.println("pulse");
    Serial.println(pulse*2);

  delay(1000);
}

