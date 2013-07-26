[DBus (name = "org.example.Demo")]
public class DemoServer : Object {
  private int counter;
  public int ping (string msg) {
    stdout.printf ("%s\n", msg);
    return counter++;
  }
  public int ping_with_signal (string msg) {
    stdout.printf ("%s\n", msg);
    pong(counter, msg);
    return counter++;
  }
  public int ping_with_sender (string msg, GLib.BusName sender) {
    stdout.printf ("%s, from: %s\n", msg, sender);
    return counter++;
  }
  public void ping_error () throws Error {
    throw new DemoError.SOME_ERROR ("There was an error!");
  }
  public signal void pong (int count, string msg);
}

[DBus (name = "org.example.DemoError")]
public errordomain DemoError
{
  SOME_ERROR
}

void on_bus_aquired (DBusConnection conn) {
  try {
    conn.register_object ("/org/example/demo", new DemoServer ());
  } catch (IOError e) {
    stderr.printf ("Cound not register service\n");
  }
}

void main () {
  Bus.own_name (BusType.SESSION,
  	        "org.example.Demo",
		BusNameOwnerFlags.NONE,
		on_bus_aquired,
		() => {},
		() => stderr.printf ("Cound not aquire name\n"));
  new MainLoop ().run ();
}
