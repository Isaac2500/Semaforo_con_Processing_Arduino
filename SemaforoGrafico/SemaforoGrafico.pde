import processing.serial.*;

Serial puerto;
boolean LUZ_ROJA_ENCENDIDA, LUZ_AMARILLA_ENCENDIDA, LUZ_VERDE_ENCENDIDA; 
int t = millis(), crono, contador = -1;
String msgSerial = "";


void setup(){
  size(600,600);
  LUZ_ROJA_ENCENDIDA = false;
  LUZ_AMARILLA_ENCENDIDA = false;
  LUZ_VERDE_ENCENDIDA = true;
  arduino();
}

void draw(){
  semaforo();
  
  if(puerto.available()>0){ //Detecta cuando se tiene un dato de entrada y se activa el contador para el peaton
    msgSerial = puerto.readString();
    contador=5;
  }
  
  if(contador != -1 ){ // Verifica que se ha presionado el boton gracias al contador para detener el semaforo principal
    
    LUZ_ROJA_ENCENDIDA =true;
    luzRoja();
    peaton(0,255);
    cuentaRegresiva();
    
  }else{// Inicia 
    
      crono = millis()-t;
      peaton(255,0);
    if(crono>0 && crono<2000){
      LUZ_VERDE_ENCENDIDA = true;
      luzVerde();
    }
    if(crono>=2000 && crono<4000){
      LUZ_AMARILLA_ENCENDIDA = true;
      luzAmarilla();
    }
    if(crono>=4000 && crono<6000){
      LUZ_ROJA_ENCENDIDA = true;
      luzRoja();
    }
    if(crono>=6000){
      t= millis();
    }
  }
  
}

void semaforo(){
  rectMode(CENTER);
  fill(0);
  rect(width/2, height/2,100,300);
}
void luzRoja(){
  if(LUZ_ROJA_ENCENDIDA==true){
    this.fill(255,0,0);
    this.circle(width/2,height/2-100,75);
  }
}
void luzAmarilla(){
  if(LUZ_AMARILLA_ENCENDIDA==true){
    this.fill(255,255,0);
    this.circle(width/2,height/2,75);
  }
}
void luzVerde(){
  if(LUZ_VERDE_ENCENDIDA==true){
    this.fill(0,255,0);
    this.circle(width/2,height/2+100,75);
  }
}

void peaton(int rojo, int verde){
  fill(0);
  rect(450, 200,100,100);
  fill(rojo,verde,0);
  ellipse(450,200,80,80);
}

void cuentaRegresiva(){
  fill(255,255,255);
  rect(450,300,100,100);
  fill(0,0,0);
  textSize(30);
  text(contador,440,310,30);
  contador = contador - 1;
  if(contador == -1){
    msgSerial = "";
  }
  delay(1000);
  
}

void arduino(){
  String listado = Serial.list()[0];
  puerto = new Serial(this,listado,9600);
}
