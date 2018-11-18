import processing.video.*;
import java.io.FilenameFilter;

JSONObject json; 

ArrayList<ArrayList<Person>> people = new ArrayList();

Movie mov;
float currentFrameTime = 0;
int currentFrameIndex = 0;

boolean playing = true;

void setup() {

  size(848, 480, P3D);

  String captureName = "jsonSalsa2/";

  mov = new Movie(this, captureName + "test.mp4");

  // for (int j = 0; j < 169; j++) {
  // people.add(new ArrayList<Person>());
  // }

  String path = dataPath(captureName);
  File file = new File(path);
  String[] names = file.list(new FilenameFilter() {
    @Override
      public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".json");
    }
  }
  );

  for (int j = 0; j < names.length - 1; j++) {

    String fileNameComp = captureName + names[j];
    File f = new File(dataPath(fileNameComp));

    if (!f.exists()) {
      println("no encontramos" + fileNameComp);
      ArrayList<Person> temp = new ArrayList<Person>();
      people.add(temp);
      continue;
    }
    // println("id:"+id);
    ArrayList<Person> tempPeople = new ArrayList<Person>();
    try {
      json = loadJSONObject(fileNameComp);

      float id = json.getFloat("version");

      JSONArray values = json.getJSONArray("people");

      tempPeople = new ArrayList<Person>();
      for (int i = 0; i < values.size(); i++) {
        JSONObject obj = values.getJSONObject(i);
        Person person = new Person(-1);
        person.readPerson(obj);
        tempPeople.add(person);
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }

    people.add(tempPeople);
  }
  
  mov.loop();
}



public void draw() {

  if (mov.available()) {
    mov.read();
  }


  pushMatrix();
  background(0);

  image(mov, 0, 0);

  currentFrameTime = mov.time();
  currentFrameIndex = (int) (currentFrameTime * 30f);
  if (!playing) {
    currentFrameIndex -= 9;
  }


  if (currentFrameIndex < people.size() && currentFrameIndex >= 0) {

    boolean drawIndex = false;

    drawFrameSkeleton(currentFrameIndex, 
      drawIndex);
  }

  popMatrix();
}


private ArrayList<Person> drawFrameSkeleton(int currentFrameIndex, 
  boolean drawIndex) {
  ArrayList<Person> currentPersons = people.get(currentFrameIndex);

  for (int i = 0; i < currentPersons.size(); i++) {
    Person person = currentPersons.get(i);

    PVector pos = person.joints.get(0);
    if (pos.x == 0) {
      pos = person.joints.get(1);
    }

    if (drawIndex) {
      textAlign(CENTER);
      textSize(10);

      fill(255);
      stroke(255, 0, 0);
      text("soy " + i, pos.x, pos.y);
    }

    strokeWeight(2);
    person.drawSkeleton(g, false, false, 150);

    stroke(155, 15);
  }
  return currentPersons;
}
