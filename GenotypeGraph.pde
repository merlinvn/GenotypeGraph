// Modified Code from Visualizing Data, First Edition, Ben Fry.
// Based on the GraphLayout example by Sun Microsystems.


int nodeCount;
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

int edgeCount;
Edge[] edges = new Edge[500];

static final color nodeColor   = #F0C070;
static final color selectColor = #FF3030;
static final color fixedColor  = #FF8080;
static final color edgeColor   = #000000;

PFont font;

void settings() {
  size(600, 600);
}


void setup() {


  loadData();
  println(edgeCount);
  font = createFont("SansSerif", 10);
  textFont(font);  
  smooth();
}


void loadData() {


  addEdge("CK1", "CK2");
  addEdge("CK1", "CT1");
  addEdge("CK1", "YK1");
  addEdge("CK2", "CT2");
  addEdge("CK2", "YK2");
  addEdge("CT1", "CT2");
  addEdge("CT1", "YT1");
  addEdge("CT2", "YT2");
  addEdge("YK1", "YT1");
  addEdge("YK1", "YK2");
  addEdge("YK2", "YT2");
  addEdge("YT1", "YT2");  
}


void addEdge(String fromLabel, String toLabel) {

  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);
  from.increment();
  to.increment();

  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      edges[i].increment();
      return;
    }
  } 

  Edge e = new Edge(from, to);
  e.increment();
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}



Node findNode(String label) {
  label = label.toLowerCase();
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}


Node addNode(String label) {
  Node n = new Node(label);  
  if (nodeCount == nodes.length) {
    nodes = (Node[]) expand(nodes);
  }
  nodeTable.put(label, n);
  nodes[nodeCount++] = n;  
  return n;
}


void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }

  background(255);

  for (int i = 0; i < edgeCount; i++) {
    edges[i].relax();
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].relax();
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].update();
  }
  for (int i = 0; i < edgeCount; i++) {
    edges[i].draw();
  }
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].draw();
  }

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