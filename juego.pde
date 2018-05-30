
//se declara un array en la cual se definiran los disparos
//  Shots es un objeto que hemos definido que representa una bala
//  Shots es un objeto que hemos definido que representa los asteroides
ArrayList<shot> shots = new ArrayList<shot>();
ArrayList<astroid> astroids = new ArrayList<astroid>();

// Configuración: cuántos segundos hay entre cada nuevo astroide (3 segundos = 3 * 60) 
int astroid_rate = 2 * 60;
int astroid_count = 0;
// Tamaño en pixel del astroid nominal
float ast_size = 10;
int ast_id = 1;
int score = 0;
float hitRate = 0;
int numShots = 0;
int ships = 3;
int pause = 0;

// Solo se ejecuta una vez  Void setup
void setup () {
  frameRate(60);
  size(500, 500);
  stroke(0);
  fill(255);
}

// Llama 60 veces por segundo
void draw()
{
  int i;
  // Encuentra los valores  de x = 250, y = 250 del mouse
  float angle = atan2(mouseY - 250, mouseX - 250);
  if (pause==0) {
    // Se crea un nuevo asteroide cada 5 segundos (60 fps * 4 sec)
    if (astroid_count--==0) {
      astroids.add(new astroid(random(0, TWO_PI), random(0.1, 2.5), random(0.5, 4), random(-0.1, 0.1), 
        random(-150, 150), random(-150, 150), ast_id++));
      // Incrementa solo un poco
      astroid_count = astroid_rate--;
    }
    //Limpia la pantalla negra
    background(0);
   // Revisa todos los asteroides (si hay alguno) y actualiza su posición
    for (i = 0; i<astroids.size(); i++) {
      astroid a = astroids.get(i);
      if (a.update()) {
        // Elimina la bala si sale de la interfaz de pantalla
        astroids.remove(i);
      }
     // Detecta colisiones con asteroides al aproximar la nave con 4 círculos
      if (a.coll(250, 250, 6, -1) ||
        a.coll(13*cos(angle-PI)+250, 13*sin(angle-PI)+250, 9, -1) ||
        a.coll(10*cos(angle)+250, 10*sin(angle)+250, 4, -1) ||
        a.coll(18*cos(angle)+250, 18*sin(angle)+250, 1, -1)) {
        ships--;
        pause=3*60;
      }
    }

    // "pushMatrix" guarda el estado actual
    pushMatrix();
    // Set 250,250 as the new 0,0 
    translate(250, 250);
    // Rota la nave "angulo" 
    rotate(angle);
    fill(255);
// Dibuja un triángulo (la nave)
    triangle(20, 0, -20, -10, -20, 10);
  //volver a la vista normal
    popMatrix();
  } else {
    // Pausa es mayor que 0
     // limpiar pantalla negra
    background(0, 10);

   // Revisa todos los asteroides (si hay alguno) y actualiza su posición
    for (i = 0; i<astroids.size(); i++) {
      astroid a = astroids.get(i);
      a.incSpeed();
      if (a.update()) {
        // Remueve la bala si la bala sale de las coordenadas de la pantalla
        astroids.remove(i);
      }
    }
    if (ships == 0) {
      // limpia la panatalla negra
      textAlign(DOWN);
      text("Game Over", width/2, height/2);
      text("Press any key to restart", width/2, 2*height/3);
      // un nuevo asteroide 0.5 seconds (60 fps * 0.5 sec)
      // Para hacer que algo suceda mientras esperas
      if (astroid_count--==0) {
        astroids.add(new astroid(random(0, TWO_PI), random(0.1, 2.0), random(0.5, 4), random(-0.1, 0.1), 
          random(-150, 150), random(-150, 150), ast_id++));
        // Increase rate just a little
        astroid_count = 30;
      }
      if (keyPressed == true) {
        score = 0;
        numShots = 0;
        ships = 3;
        astroid_rate = 3 * 60;
        astroid_count = 0;
        ast_id = 1;
        astroids = new ArrayList<astroid>();
      }
    } else {
     // Espera a que desaparezcan los asteroides
      if (astroids.size()==0) {
        pause=0;
      }
    }
  }
// Revise todas las tomas (si las hay) y actualice su posición
  for (i = 0; i<shots.size(); i++) {
    shot s = shots.get(i);
    if (s.update()) {
     //elimina la bala si golpea al asteroide o sale de la pantalla
      shots.remove(i);
    }
  }
  textAlign(LEFT);
  text("Score   : " + score, 15, 15);
  text("Ships   : " + ships, 15, 30);
  text("Hit rate: " + int(100*score/float(numShots)) + "%", 15, 45);
}

// Cuando se presiona el botón izquierdo del mouse, crea una nueva toma
void mousePressed() {
  if (pause==0) {
    // Only add shots when in action
    if (mouseButton == LEFT) {
      float angle = atan2(mouseY - 250, mouseX - 250);
      shots.add(new shot(angle, 4));
      numShots++;
    }
    if (mouseButton == RIGHT) {
      astroids.add(new astroid(random(0, TWO_PI), random(0.1, 2.0), random(0.5, 4), random(-0.1, 0.1), 
        random(-80, 80), random(-80, 80), ast_id++));
    }
  }
}

// Definición de clase para el tiro
class shot {
 // Un disparo tiene x, y, y velocidad en x, y. Todos flotan para un movimiento suave
  float angle, speed;
  float x, y, x_speed, y_speed;

  // Constructor  
  shot(float _angle, float _speed) {
    angle = _angle;
    speed = _speed;
    x_speed = speed*cos(angle);
    y_speed = speed*sin(angle);
    x = width/2+20*cos(angle);
    y = height/2+20*sin(angle);
  }
// actualiza posicion, devuelve verdadero cuando está fuera de la pantalla
  boolean update() {
    int i;
    x = x + x_speed;
    y = y + y_speed;

    // dibuja bala
    ellipse (x, y, 3, 3);

    // checa colisiones
    // Revisa todos los asteroides (si hay alguno)
    for (i = 0; i<astroids.size(); i++) {
      astroid a = astroids.get(i);
      if (a.coll(x, y, 3, -1)) {
        score++;
        ast_id++;
        astroids.remove(i);
        //remueve la bala
        return true;
      }
    }
  

// Fin, comprueba si esta fuera de la pantalla
    if (x<0 || x>width || y<0 || y>height) {
      return true;
    } else {
      return false;
    }
  }
}



// Definición de clase para el tiro
class astroid {
// ángulo de asteroide, velocidad, tamaño, rotación
  float angle, speed, size, rotSpeed;
  float position;
  float rotation;
  float xoff, yoff;
  float x, y;
  PShape s;  // El objeto Shape - Mantiene la forma del asteroide
  float i;
  int id;


  // Constructor
  astroid(float _angle, float _speed, float _size, float _rotSpeed, float _xoff, float _yoff, int _id) {
    angle = _angle;
    speed = _speed;
    size = _size;
    rotSpeed = _rotSpeed;
    xoff = _xoff;
    yoff = _yoff;
    id = _id;
    if (xoff<1000) {
      x = 250+500*cos(angle)+xoff;
      y = 250+500*sin(angle)+yoff;
    } else {
      x = _xoff-2000;
      y = _yoff-2000;
    }
    rotation = 0; 
 
    // Genera la forma del astroide - Algunas variaciones para todos
    s = createShape();
    s.beginShape();
    s.fill(255, 255, 100);
    s.noStroke();
    for (i=0; i<TWO_PI; i=i+PI/(random(4, 11))) {
      s.vertex(random(ast_size*0.8, ast_size*1.2)*cos(i), random(ast_size*0.8, ast_size*1.2)*sin(i));
    }
    s.endShape(CLOSE);
  }

 // Aumenta la velocidad. Usado al final del juego para borrar la pantalla de los asteroides
  void incSpeed() {
    speed = speed * 1.02;
  }

  // Actualiza la posicion, retorna true cuando sale de la pantalla
  boolean update() {
    int i;
    x = x - cos(angle)*speed;
    y = y - sin(angle)*speed;
    rotation = rotation + rotSpeed; 

   

// Verificar la colisión entre asteroides y asteroides
    for (i = 0; i<astroids.size(); i++) {
      astroid a = astroids.get(i);
      if ((a != this) && (a.coll(x, y, ast_size*size, id))) {
        if (size > 1) {
          astroids.add(new astroid(angle-random(PI/5, PI/7), speed+random(0, speed/2), size/2, rotSpeed, 2000+x, 2000+y, id));
          astroids.add(new astroid(angle+random(PI/5, PI/7), speed+random(0, speed/2), size/2, rotSpeed, 2000+x, 2000+y, id));    
          ast_id++;
        }
        astroids.remove(i);
      }}
      
    pushMatrix();
    // // Establece posición como nuevo 0,0
    translate(x, y);
    //rota pantalla(angulo)
    rotate(rotation);
    // Dibuja un asteroide
    scale(size);
    shape(s, 0, 0);
    // devuelve a la normalidad la perspectiva
    popMatrix();
    if (x<-300 || x>800 || y<-300 || y>800) {
      return true;} else {
      return false;
    }}
  boolean coll(float _x, float _y, float _size, int _id) {
    float dist;
    dist = sqrt ((x-_x)*(x-_x) + (y-_y)*(y-_y));
    // Verifica si la distancia es más corta que el tamaño del asteroide y el tamaño de otros objetos
    if ((dist<(_size+ast_size*size)) && (id!=_id)) {
      // Colision 
      if (_id>0) id = _id;
      if (size > 1) {
        // Si el asteroide era "grande" genera dos nuevos fragmentos
        astroids.add(new astroid(angle-random(PI/5, PI/7), speed+random(0, speed/2), size/2, rotSpeed, 2000+x, 2000+y, id));
        astroids.add(new astroid(angle+random(PI/5, PI/7), speed+random(0, speed/2), size/2, rotSpeed, 2000+x, 2000+y, id));
      }return true;
    } else { 
      return false;}}}