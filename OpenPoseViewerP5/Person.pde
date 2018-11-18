
class Person {

  PGraphics pg_src_A;
  
  // Am I available to be matched?
  public boolean available;

  // Should I be deleted?
  public boolean delete;

  // How long should I live if I have disappeared?
  private int initTimer = 7; // 127;
  public int timer;

  // Unique ID for each blob
  int id;

  ArrayList<Person> path = new ArrayList<Person>();
  ArrayList<PVector> vels = new ArrayList<PVector>();

  PVector velocityAvg = new PVector();

  float angle = -33;
  float lastAngle = -33;
  float lastAngleVariation = -33;

  // PVector pos;

  ArrayList<PVector> joints = new ArrayList<PVector>();
  
  boolean withCeros = false;

  // Make me
  public Person(int id) {
    this.id = id;
    available = true;
    delete = false;

    timer = initTimer;
  }

  // Show me
  public void display(PGraphics canvas) {

    canvas.pushStyle();

    // canvas.fill(0, 0, 255, opacity);
    // canvas.stroke(0, 0, 255);
    PVector pos = joints.get(0);
    canvas.noFill();
    canvas.rect(pos.x, pos.y, 5, 5);
    // canvas.fill(255, 2 * opacity);
    canvas.textSize(8);
    canvas.text("" + id + " " + angle, pos.x + 10, pos.y + 30);

    Person last = null;
    canvas.strokeWeight(1);
    for (Person v : path) {
      for (int i = 0; i < v.joints.size(); i++) {
        canvas.stroke(0, 255, 0);
        if (last != null)
          canvas.line(last.joints.get(i).x, last.joints.get(i).y,
              v.joints.get(i).x, v.joints.get(i).y);
        last = v;
      }

    }
  
    canvas.noStroke();
    canvas.fill(255);

    canvas.popStyle();
  }

  public void update(Person newPerson) {

    newPerson.id = id;
    path.add(0, newPerson);
    newPerson.path.addAll(path);

  }

  // Count me down, I am gone
  public void countDown() {
    timer--;
  }

  // I am deed, delete me
  public boolean dead() {
    if (timer < 0)
      return true;
    return false;
  }

  @Override
  public String toString() {
    // TODO Auto-generated method stub
    return "[Person:id=]" + id;
  }

  public void readPerson(JSONObject obj) {
    ArrayList temp = new ArrayList<PVector>();
    for (int jj = 0; jj < 25; jj++) {
      PVector pos = new PVector();
      JSONArray jsonArray = obj.getJSONArray("pose_keypoints_2d");
      pos.x = jsonArray.getFloat(jj * 3 + 0);
      pos.y = obj.getJSONArray("pose_keypoints_2d").getFloat(jj * 3 + 1);
      pos.z = obj.getJSONArray("pose_keypoints_2d").getFloat(jj * 3 + 2);
      temp.add(pos);
    }

    joints = temp;
  }

  public void drawSkeleton(PGraphics pg_src_A, boolean isEditing,
      boolean withZeros,  float alpha) {

    if (isEditing) {
      alpha = 255;
    }
    
    Person person = this;
    
    this.pg_src_A = pg_src_A;
    
    this.withCeros = withZeros;

    int sizeZ = 2;
    pg_src_A.stroke(255, 0, 0, alpha);
    float scaleZ = 1;

    for (int j = 0; j < 25; j++) {
      int resto = j % 25;
      if (resto >= 2 && resto != 5 && resto != 8 && resto != 12
          && resto < 15) {
        if (withCeros || person.joints.get(j - 1).x != 0
            && person.joints.get(j).x != 0) {

          // if (resto >= 8) {
          if (resto < 12) {
            if (resto >= 8)
              // pierna derecha
              pg_src_A.stroke(0, 255, 255, alpha);
            else {
              if (resto >= 5)
                pg_src_A.stroke(255, 0, 255, alpha);
              else
                pg_src_A.stroke(0, 255, 255, alpha);
            }

          } else if (resto >= 8)
            // pierna izquierda
            pg_src_A.stroke(255, 0, 255, alpha);

          // } else {
          // pg_src_A.stroke(0, 255, 255, 150);
          // }

          PVector before = person.joints.get(j - 1);
          PVector current = person.joints.get(j);

          pg_src_A.line(before.x, before.y,
              before.z * scaleZ + sizeZ, current.x, current.y,
              current.z * scaleZ + sizeZ);
        }
      }
    }

    pg_src_A.stroke(0, 255, 255, alpha);
    drawLine( sizeZ, 11, 22);
    drawLine( sizeZ, 23, 22);
    drawLine( sizeZ, 11, 24);

    // LEFT FOOT
    pg_src_A.stroke(255, 0, 255, alpha);
    drawLine( sizeZ, 14, 21);
    drawLine( sizeZ, 14, 20);
    drawLine( sizeZ, 19, 20);

    drawLine( sizeZ, 14, 21);
    drawLine( sizeZ, 12, 8);

    drawLine( sizeZ, 1, 5);
    drawLine( sizeZ, 1, 8);

    pg_src_A.strokeWeight(1);
    drawLine( sizeZ, 15, 17);
    // drawLine( sizeZ, 15, 0);
    // drawLine( sizeZ, 16, 0);
    drawLine( sizeZ, 16, 15);
    drawLine( sizeZ, 16, 18);

  }

  private void drawLine( int sizeZ, int pos1, int pos2) {

    PVector p1 = joints.get(pos1);
    PVector p2 = joints.get(pos2);

    if (withCeros || p1.x != 0 && p2.x != 0) {
      pg_src_A.line(p1.x, p1.y, sizeZ, p2.x, p2.y, sizeZ);
    }
  }

}
