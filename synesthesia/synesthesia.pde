import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.Process;
import java.lang.reflect.Field;

String kill_pid;
boolean stop = true;
int count = 0;
void setup() {
  println("Opening Process_4");
  frameRate(1);
  //String term = "/Users/yankong/anaconda3/bin/python3 /Users/yankong/Documents/Processing/sketch_181018a/test.py";
  String term = "/Users/yankong/anaconda3/bin/python3 /Users/yankong/Desktop/18Fall/ART122/Final_Project/synesthesia/test_kill.py";
  try {
    Runtime rt = Runtime.getRuntime();
    println("1");
    Process pr = rt.exec(term);
    println("2");
    Field f = pr.getClass().getDeclaredField("pid");
    f.setAccessible(true);
    kill_pid = "kill " + String.valueOf(f.get(pr));
    System.out.println("Process ID : " + f.get(pr));
    
  } 
  catch (Exception e) {
  }
}




void draw() { 
    
  String[] lines = loadStrings("demofile.txt");
  println("length", lines.length);
  println("str:", lines[0]);
  println("int:", Integer.valueOf(lines[0]));
  //if (int(lines[0]) > 200 && stop == true)
  //{
  //    try {
  //    Runtime rt = Runtime.getRuntime();
  //    println("3");
  //    Process pr = rt.exec(kill_pid);
  //    println("4");
  //    stop = false;
  //  }
  //  catch (Exception e) {
  //  }
  //} 
}

void exit(){
try {
  println("execute stop function");
      Runtime rt = Runtime.getRuntime();
      println("3");
      Process pr = rt.exec(kill_pid);
      println("4");
      stop = false;
    }
    catch (Exception e) {
    }
    super.exit();
}
