
  
class rectangle{ //class name
 
  int posx; //class attributes
  int posy;
  int lengx;
  int lengy;
  color col;
  
  //declare class constructor
 rectangle(int x, int y, int leng_x, int leng_y){ 
   posx=x;
   posy=y;//update the objects attributes
   lengx=leng_x;
   lengy=leng_y;
   rect(x, y,leng_x,leng_y); //create the rectangle
 }
 
 //declare function to check if mouse is inside the object
 boolean IsInRect(){
   if (mouseX>posx && mouseX<(posx+lengx)&& mouseY>posy && mouseY<(posy+lengy)){
     return true;
   } else{
     return false;
   }
 }
 
 void ShapeColor(float col1,float col2,float col3){
   fill(col1,col2,col3);
   rect(posx, posy,lengx,lengy);
 }
}


rectangle myrec; //declare an object to be of 'rectangle' class I made

void setup() {
  frameRate(10);
  size(400, 400);//define the size of the window
  fill(100);
  myrec= new rectangle(100,100,50,50); //create a new object of the rectangle class

}

void draw() {
  println(myrec.lengx);
  
  if (mousePressed && myrec.IsInRect()){
    background(0);
    fill(random(0,255),random(0,255),random(0,255));
    ellipse(300,300,50,50);
    
    float rand1=random(0,255);
    float rand2=random(0,255);
    float rand3=random(0,255);

    myrec.ShapeColor(rand1,rand2,rand3);
  }
}
     
