package net.jakubholy.experiments.bluegreen;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

/**
 * Start the embedded Jetty server to serve this webapp.
 */
public class Main {

    public static void main(String[] args) throws Exception {

        if (args.length != 1) throw new IllegalArgumentException("Exactly one argument is required: the port to listen to");
        final int port = Integer.parseInt(args[0]);

        final String thisWarPath = Main.class.getProtectionDomain().getCodeSource().getLocation().toExternalForm();

        Server server = new Server(port);

        // Enable discovery of annotated servlets
        org.eclipse.jetty.webapp.Configuration.ClassList classlist = org.eclipse.jetty.webapp.Configuration.ClassList.setServerDefault(server);
        classlist.addBefore("org.eclipse.jetty.webapp.JettyWebXmlConfiguration", "org.eclipse.jetty.annotations.AnnotationConfiguration");

        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath("/*");
        webapp.setWar(thisWarPath);
        server.setHandler(webapp);

        server.start();
        server.join();
    }
}
