package net.jakubholy.experiments.bluegreen;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;

/** A simple servlet responding to clients and handling (settable) health checks from HAProxy. */
@WebServlet("/*")
public class HelloServlet extends HttpServlet {

    private static final Date INITIALIZED = new Date(); // reset upon reload/restart
    private static final String HEALTH_URL = "/health";
    private static final String HEALTH_DISABLE_URL = HEALTH_URL + "/disable";
    private static final String HEALTH_ENABLE_URL = HEALTH_URL + "/enable";

    private static AtomicBoolean acceptingNewConnections = new AtomicBoolean(true);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        final HttpSession session = request.getSession(true);

        Object sessionStart = session.getAttribute("sessionStart");
        if (sessionStart == null) {
            sessionStart = "now";
            session.setAttribute("sessionStart", new Date().toString());
        }

        response.setContentType("text/html");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("<h1>Hello Servlet</h1>");
        response.getWriter().println("<br>Running since " + INITIALIZED);
        response.getWriter().println("<br>Your session=" + session.getId() + ", started: " + sessionStart);

        final String env = System.getProperty("env");
        if (env == null) {
            response.getWriter().println("<p style='background:red'>ERROR: env (blue/green) not specified via a system property 'env' as expected</p>");
        }
        response.getWriter().println("<p style='background:" + env + ";width:100%'>Env: " + env + "</p>");

    }

    /**
     * HEAD request to /health is used by HAProxy to check the availability of the server.
     */
    @Override
    protected void doHead(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (HEALTH_URL.equals(req.getRequestURI())) {
            final int status = acceptingNewConnections.get()? HttpServletResponse.SC_OK : HttpServletResponse.SC_SERVICE_UNAVAILABLE;
            resp.setStatus(status);
        } else {
            super.doHead(req, resp);
        }
    }

    /**
     * Post to /health/disable for /health to start responding with an error code to HAProxy's requests,
     * to /health/enable to make it return OK again.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (HEALTH_DISABLE_URL.equals(req.getRequestURI())) {
            boolean wasEnabled = acceptingNewConnections.getAndSet(false);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().println(wasEnabled? "DISABLING the server" : "NoOp, already disabled");
        } else if (HEALTH_ENABLE_URL.equals(req.getRequestURI())) {
            boolean wasEnabled = acceptingNewConnections.getAndSet(true);
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().println(wasEnabled? "NoOp, already enabled" : "ENABLING the server");
        } else {
            super.doPost(req, resp);
        }
    }
}
