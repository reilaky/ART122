void runPython(String term)
{
  try{
    Runtime rt = Runtime.getRuntime();
    Process pr = rt.exec(term);
    Field f = pr.getClass().getDeclaredField("pid");
    f.setAccessible(true);
    kill_pid = "kill " + String.valueOf(f.get(pr));
    System.out.println("Process ID : " + f.get(pr));
  } 
  catch (Exception e) {
  }
}
