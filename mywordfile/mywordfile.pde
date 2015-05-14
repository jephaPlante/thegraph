import processing.pdf.*;

// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


int nodeCount;
PImage backImage;
PImage charImage;

PFont font;
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

int edgeCount;
Edge[] edges = new Edge[500];

static final color nodeColor   = #7FDCF2;
static final color categoryColor   = #4DF0A0;

static final color selectColor = #703030;
static final color fixedColor  = #708080;
static final color edgeColor   = #078E8A;
String toTitle,fromTitle;



void setup() {
  size(1024, 545); 
 backImage = loadImage("backdrop.jpg"); 
   font = createFont("Courier", 13);
 // loadData();
 readMyData();
  //font = createFont("SansSerif", 10);
 // writeData();   
}


void writeData() {
  PrintWriter writer = createWriter("3Kittens.dot");
  writer.println("digraph output {");
  for (int i = 0; i < edgeCount; i++) {
    String from = "\"" + edges[i].from.label + "\"";
    String to = "\"" + edges[i].to.label + "\"";
    writer.println(TAB + from + " -> " + to + ";");
  }
  writer.println("}");
  writer.flush();
  writer.close();
}


/*void loadData() {
  String[] lines = loadStrings("3kittens.txt");
  
  // Make the text into a single String object
  String line = join(lines, " ");
  
  // Replace -- with an actual em dash
  line = line.replaceAll("--", "\u2014");
  
  // Split into phrases using any of the provided tokens
  String[] phrases = splitTokens(line, ".,;:?!\u2014\"");
  //println(phrases);

  for (int i = 0; i < phrases.length; i++) {
    // Make this phrase lowercase
    String phrase = phrases[i].toLowerCase();
    // Split each phrase into individual words at one or more spaces
    String[] words = splitTokens(phrase, " ");
    for (int w = 0; w < words.length-1; w++) {
      addEdge(words[w], words[w+1]);
    }
  }
}*/
void readMyData() {
    String[] lines = loadStrings("myInfoFileSuper.txt");
    for (int i = 0; i < lines.length; i++) {
      String [] line = split(lines[i],TAB);
      fromTitle = line[0];
      //println(line[0]);
      toTitle = line[1];
      addEdge(fromTitle, toTitle);
    }
}


void addEdge(String fromLabel, String toLabel) {
  // Filter out unnecessary words
 // if (ignoreWord(fromLabel) || ignoreWord(toLabel)) return; //if one of the words is a really common stop word
  
  Node from = findNode(fromLabel);//pass a dtring, returns a node reference
  Node to = findNode(toLabel);
  from.increment();
  to.increment();
  from.fromTo=0;
  to.fromTo=1;
  
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {//if we already have an edge connecting these two nodes, we just add weight to it
      edges[i].increment();
      return;
    }
  } 
  
  Edge e = new Edge(from, to);//Otherwise, we create the edge there
  e.increment();
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}


String[] ignore = { "a", "of", "the", "i", "it", "you", "and", "to","an","but","or","her","we","was","is","he","she","him","his","gutenberg-tm","are","were","gutenberg" };

boolean ignoreWord(String what) {
  for (int i = 0; i < ignore.length; i++) {
    if (what.equals(ignore[i])) {
      return true;
    }
  }
  return false;
}


Node findNode(String label) {
  //label = label.toLowerCase();
  Node n = (Node) nodeTable.get(label);//Ask if the label exists in the hash table
  if (n == null) {
    return addNode(label);//If it isnt there, this makes it
  }
  return n;//else, return the node reference
}


Node addNode(String label) {
  Node n = new Node(label);  
  if (nodeCount == nodes.length) {//check to see if the array is full
    nodes = (Node[]) expand(nodes);//if it is, make the array bigger
  }
  nodeTable.put(label, n);//if not add the label in
  nodes[nodeCount++] = n;  
  return n;
}


void draw() {
  image(backImage, 0, -20);
  if (record) {
    beginRecord(PDF, "output.pdf");
  }

  //background(0);
  textFont(font);  
  smooth();  
  
  for (int i = 0 ; i < edgeCount ; i++) {
    edges[i].relax();//relax the edges
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].relax();//relax the nodes
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].update();
  }
  for (int i = 0 ; i < edgeCount ; i++) {
    edges[i].draw();
  }
  for (int i = 0 ; i < nodeCount ; i++) {
    nodes[i].draw();
  }
  mouseHovering();
  
  if (record) {
    endRecord();
    record = false;
  }
}


boolean record;

void keyPressed() {
  if (key == 'r') {
    record = true;
  }
}


Node selection; 

void mouseHovering(){
    float closest = 20;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
    
    if (selection != null){
      if (selection.count*3<selection.w-20) {
        textSize(14);
        String photoName = selection.label.toLowerCase();
        photoName = photoName.replaceAll(" ","");
        photoName = photoName.replaceAll("'","");
        photoName = photoName+ ".jpg";
        charImage = loadImage(photoName);
        float ratio = 1.0 * (charImage.width/charImage.height);
        
        image(charImage,selection.midX-2,selection.midY+10,50,50*ratio);
        fill(0);
       // stroke(255,255,255,200);
       // strokeWeight(20);
        textAlign(LEFT);
  
        rect(selection.midX-2, selection.midY-10, selection.w+2, 16);
        fill(255,255,255);
        text(selection.label,selection.midX,selection.midY);
      }
      else{
         String photoName = selection.label.toLowerCase();
        photoName = photoName.replaceAll(" ","");
        photoName = photoName.replaceAll("'","");
        photoName = photoName+ ".jpg";
        charImage = loadImage(photoName);
        float ratio = 1.0 * (charImage.width/charImage.height);
        
        image(charImage,selection.midX-2,selection.midY+10,50,50*ratio);
        fill(0);
      }
  }
  
}
void mousePressed() {
  // Ignore anything greater than this distance
  float closest = 20;
  for (int i = 0; i < nodeCount; i++) {
    Node n = nodes[i];
    float d = dist(mouseX, mouseY, n.x, n.y);
    if (d < closest) {
      selection = n;
      closest = d;
    }
  }
  if (selection != null) {
    
    if (mouseButton == LEFT) {
      selection.fixed = true;
    } else if (mouseButton == RIGHT) {
      selection.fixed = false;
    }
  }
}


void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
  }
}


void mouseReleased() {
  selection = null;
}
