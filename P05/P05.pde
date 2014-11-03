float dz=-100; // distance to camera. Manipulated with wheel or when 
float rx=-0.10*TWO_PI, ry=-0.10*TWO_PI;    // view angles manipulated when space pressed but not mouse
Boolean twistFree=false, animating=false, center=true, showControlPolygon=true, showFloor=false;
float t=0, s=0;
pt F = P(0, 0, 0);  // focus point:  the camera is looking at it (moved when 'f or 'F' are pressed
pt O=P(100, 100, 0); // red point controlled by the user via mouseDrag : used for inserting vertices ...

void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  size(1200, 700, P3D); // p3D means that we will do 3D graphics
  //P.declare(); Q.declare(); PtQ.declare(); // P is a polyloop in 3D: declared in pts
  // P.resetOnCircle(12,100); // used to get started if no model exists on file 
  //P.loadPts("data/pts");  // loads saved model from file
  //Q.loadPts("data/pts2");  // loads saved model from file
  initBase();
  noSmooth();
}

void draw() {
  background(255);
  if (threeDMode)
  {
    pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
    camera();       // sets a standard perspective
    translate(width/3, height/6, dz); // puts origin of model at screen center and moves forward/away by dz
    lights();  // turns on view-dependent lighting
    rotateX(rx); 
    rotateY(ry); // rotates the model around the new origin (center of screen)
    rotateX(PI/2); // rotates frame around X to make X and Y basis vectors parallel to the floor
  }
  if (center) translate(-F.x, -F.y, -F.z);
  noStroke(); // if you use stroke, the weight (width) of it will be scaled with you scaleing factor
  if (showFloor) {
    showFrame(50); // X-red, Y-green, Z-blue arrows
    fill(yellow); 
    pushMatrix(); 
    translate(0, 0, -1.5); 
    box(400, 400, 1); 
    popMatrix(); // draws floor as thin plate
    fill(magenta); 
    show(F, 4); // magenta focus point (stays at center of screen)
    fill(magenta, 100); 
    showShadow(F, 5); // magenta translucent shadow of focus point (after moving it up with 'F'
    if (showControlPolygon) {
      pushMatrix();
      drawKeyFrame(); 
      //fill(grey,100); scale(1,1,0.01); P.drawClosedCurveAsRods(4); 
      //P.drawBalls(4); 
      popMatrix();
    } // show floor shadow of polyloop
  }
  //fill(black); show(O,4); fill(red,100); showShadow(O,5); // show red tool point and its shadow

  //computeProjectedVectors(); // computes screen projections I, J, K of basis vectors (see bottom of pv3D): used for dragging in viewer's frame    
  //pp=P.idOfVertexWithClosestScreenProjectionTo(Mouse()); // id of vertex of P with closest screen projection to mouse (us in keyPressed 'x'...


  if (showControlPolygon) {
    //fill(green); P.drawClosedCurveAsRods(4); P.drawBalls(4); // draw curve P as cones with ball ends
    //fill(red); Q.drawClosedCurveAsRods(4); Q.drawBalls(4); // draw curve Q
    //fill(green,100); P.drawBalls(5); // draw semitransluent green balls around the vertices
    //fill(grey,100); show(P.closestProjectionOf(O),6); // compputes and shows the closest projection of O on P
    //fill(red,100); P.showPicked(6); // shows currently picked vertex in red (last key action 'x', 'z'
    drawKeyFrame();
  }

  // replace the following 2 lines by display of the extrucded polygonal model
  fill(cyan); 
  stroke(blue); //showWalls(P,Q);  
  noStroke(); 
  drawKeyFrame();//fill(yellow); P.drawClosedLoop(); fill(orange); Q.drawClosedLoop();
  if (threeDMode)
  {
    popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  }

  if (keyPressed) {
    stroke(red); 
    fill(white); 
    ellipse(mouseX, mouseY, 26, 26); 
    fill(red); 
    text(key, mouseX-5, mouseY+4);
  }
  // for demos: shows the mouse and the key pressed (but it may be hidden by the 3D model)
  if (scribeText) {
    fill(black); 
    displayHeader();
  } // dispalys header on canvas, including my face
  if (scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if (animating) { 
    t+=PI/180*2; 
    if (t>=TWO_PI) t=0; 
    s=(cos(t)+1.)/2;
  } // periodic change of time 
  if (filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++, 4)+".tif");  // save next frame to make a movie  

  if (deleteMode) {
    fill(red);
    text("DeleteMode", 100, 100);
  } else if (selectMode) { 
    fill(magenta);
    text("SelectMode", 100, 100);
  } else if (threeDMode) {
    fill(cyan);
    text("3D Drawing", 100, 100);
  } else { 
    fill(green);
    text("AddMode", 100, 100);
  }
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
}

void keyPressed() {
  toggleMode();
  //  if(key=='?') scribeText=!scribeText;
  //  if(key=='!') snapPicture();
  //  if(key=='~') filming=!filming;
  //  if(key==']') showControlPolygon=!showControlPolygon;
  //  if(key=='0') P.flatten();
  //  if(key=='_') showFloor=!showFloor;
  //  if(key=='q') Q.copyFrom(P);
  //  if(key=='p') P.copyFrom(Q);
  //  if(key=='e') {PtQ.copyFrom(Q);Q.copyFrom(P);P.copyFrom(PtQ);}
  //  if(key=='.') F=P.Picked(); // snaps focus F to the selected vertex of P (easier to rotate and zoom while keeping it in center)
  //  if(key=='x' || key=='z' || key=='d') P.setPickedTo(pp); // picks the vertex of P that has closest projeciton to mouse
  //  if(key=='d') P.deletePicked();
  //  if(key=='i') P.insertClosestProjection(O); // Inserts new vertex in P that is the closeset projection of O
  //  if(key=='W') {P.savePts("data/pts"); Q.savePts("data/pts2");}  // save vertices to pts2
  //  if(key=='L') {P.loadPts("data/pts"); Q.loadPts("data/pts2");}   // loads saved model
  //  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  //  if(key=='l') P.loadPts("data/pts"); 
  //  if(key=='a') animating=!animating; // toggle animation
  if (key=='j') {
    dz -= 2; 
    change=true;
  }
  //  if(key=='#') exit();
  change=true;
}

void mouseWheel(MouseEvent event) {
  dz -= event.getAmount(); 
  change=true;
}

void mousePressed()
{
  calculateOnMousePressChanges();
}

void mouseReleased()
{
  if (!threeDMode)
  {
    calculateOnMouseReleaseChanges();
  }
}

void mouseMoved() {
  if (keyPressed && key==' ') {
    rx-=PI*(mouseY-pmouseY)/height; 
    ry+=PI*(mouseX-pmouseX)/width;
  };
  if (keyPressed && key=='j') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
}

void mouseDragged() {
  if (!threeDMode)
  {
    calculateOnMouseDraggedChanges();
  }
  //  if (!keyPressed) {O.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
  //  if (keyPressed && key==CODED && keyCode==SHIFT) {O.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
  //  if (keyPressed && key=='x') P.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //  if (keyPressed && key=='z') P.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //  if (keyPressed && key=='X') P.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //  if (keyPressed && key=='Z') P.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //  if (keyPressed && key=='f') { // move focus point on plane
  //    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //    }
  //  if (keyPressed && key=='F') { // move focus point vertically
  //    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  //    }
}  

// **** Header, footer, help text on canvas
void displayHeader() { // Displays title and authors face on screen
  scribeHeader(title, 0); 
  scribeHeaderRight(name); 
  fill(white); 
  image(myFace, width-myFace.width/2, 25, myFace.width/2, myFace.height/2);
}
void displayFooter() { // Displays help text at the bottom
  scribeFooter(guide, 1); 
  scribeFooter(menu, 0);
}

String title ="CS6491, Fall 2014, Assignment 5: 'Polygonal Mesh'", name ="Deep Ghosh", // enter project number and your name
menu="?:(show/hide) help, !:snap picture, ~:(start/stop) recording frames for movie, Q:quit, F: show faces, A: add mode, D: delete mode, C: view/traverse mode, X: 3D Diagram, 1: Show 3D lines,  2: Show Loops in 3D ", 
guide="J: Mouse scroll: Zoom out. Space: Free View. In Add mode, click edge or drag to add. In delete mode, click edge or vertex. In view mode, click to select. n=next,p=prev,s=swing,u=unswing, z=z."; // help info
