#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#define TMP102_I2C_ADDRESS 0x48
Adafruit_SSD1306 display = Adafruit_SSD1306(128,64,&Wire);
double Page,n,T,TIME=0;
double pulse, frequency,capacitance,inductance,inductanceuh,inductancenh;
float Temperature;
void OLED_Init()
{
 Serial.begin(9600);
 display.begin(SSD1306_SWITCHCAPVCC,0x3C);   // OLED address
 display.clearDisplay();   
 display.setTextSize(1);
 display.setTextColor(WHITE);
 display.setCursor(0,0);
 display.display();
}

float TMP102_read(double address)
{
//////////////////TMP102/////////////////////////////////////////////////////////////
  int16_t rawTemperature;
  float Temp;
  Wire.beginTransmission(address);
  Wire.write(0x00); // 写入寄存器地址，读取温度寄存器
  Wire.endTransmission();
 
  Wire.requestFrom(address, 2); // 请求2个字节的温度数据
  rawTemperature = Wire.read();
  rawTemperature <<= 8;
  rawTemperature |= Wire.read();
  rawTemperature >>= 4;
 
  Temp = (rawTemperature *0.0625); // 转换
  return Temp;
}

void setup() 
{
  // put your setup code here, to run once:
 OLED_Init();
 Wire.begin();  
 display.clearDisplay();
 display.display();
 pinMode(9,INPUT);
 pinMode(1,OUTPUT);
 pinMode(2,INPUT);
 pinMode(8,OUTPUT);
}

void loop() 
{   
/////Key test//////////////////////////////////////////////////////////////////////
  Temperature=TMP102_read(TMP102_I2C_ADDRESS);
  int n = digitalRead(9);
  if (n == LOW) //Low LED on
 {
  delay(10); 
  digitalWrite(1, HIGH);
  T=100;
  Page=Page+1;
  delay(200); 
 }
 else
 {
  delay(10); 
  digitalWrite(1, LOW);
 }
//////////////////inductancetest/////////////////////////////////////////////////////////////
  digitalWrite(8,HIGH);
  delay(5);
  digitalWrite(8,LOW);
  ////sensitivity////////////////
  delayMicroseconds(5);
  ///////////////////////////////
  pulse = pulseIn(2,HIGH,5000);
    //////////////////////////////
    capacitance = 0.47E-6;  //102 0.001 103 0.01, 104 0.1, 105 1

    frequency = 1.E6/(2*pulse);
    inductance = 1./(capacitance*frequency*frequency*4*3.14159*3.14159);
    inductanceuh = inductance*1000000;
    inductancenh = inductance*1000000000;
//////////////////display//////////////////////////////////////////////////////////////////
 if (T>0)//start display
 {
  if(Page==1)
  {
    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextSize(2);
    display.print("Page1");
    display.setCursor(0,20);
    display.print("Period:");
    display.setCursor(0,40);
    display.print(pulse*2);
    display.display();
  }
  else if(Page==2)
  {
    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("Page2");
    display.setCursor(0,20);
    display.print("Temp:");
    display.setCursor(0,40);
    display.print(Temperature);
    display.print(".C");
    display.display();
  }
    else if(Page==3)
  {
    display.clearDisplay();
    display.setCursor(0,0);
    display.setTextSize(2);
    display.setCursor(0,0);
    display.print("Page3");
    display.setCursor(0,20);
    display.print("inductance");
    display.setCursor(0,40);
    display.print(inductanceuh);
    display.print("uh");
    display.display();
  }
  else{Page=1;}
    
 }
 else{display.clearDisplay();    display.display();}




  if(T>0){T=T-1;}else{T=0,Page=0;}//calculate the remain display time

    Serial.println("pulse");
    Serial.println(pulse*2);

  delay(100);
}
