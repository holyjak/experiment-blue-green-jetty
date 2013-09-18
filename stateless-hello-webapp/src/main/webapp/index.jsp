<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Blue-Green Deployment PoC</title>
    <!-- Deployment Bar; we include the zone in the URL to ensure we never get a stale cached version after switching -->
    <script src="/js/deployment-bar.js?zone=<%=net.jakubholy.experiments.bluegreen.HelloServlet.getZone()%>"></script>
</head>
<body>

<h1>Welcome to the Blue-Green deployment proof of concept!</h1>

This is a dynamic HTML page in a Java webapp, which
represents the users-facing part of the app.

You should see a "deployment bar" above, that is the real magic.

<hr style="margin-top: 100em;">
<p style="font-size: small">Copyleft: Jakub Holy, 2013</p>

</body>
</html>
