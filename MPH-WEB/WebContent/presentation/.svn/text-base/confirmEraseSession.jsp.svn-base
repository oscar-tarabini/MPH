<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
Another session is still active in your browser for MPH website (either it is open or
it has been badly closed without logout).<Br/>
To continue with this new login, it's necessary to logout from the other session and then
push the button "Retry Login". <br/>
In case it's not possible to perform the logout from the other session, please restart the browser
(if you have opened multiple instances of your browser with sessions with MPH in which
it's not possible to normally logout, it may be necessary to close all
of them, sorry).
<!--  <br/>If you want to delete it,
and start a new one, confirm to erase session after login.<br/>
<h3>Attention: the other session will be lost!</h3>
-->
<% 	String username = request.getParameter("username");
 	String password = request.getParameter("password");
 	String action = request.getParameter("action"); %>

<form id="confirmEraseSession" method="post" action="../controller/controllerLogin.jsp?action=<%if(action != null) out.print(action);%>" class="form">
  <!--  	<select name="confirmEraseSession">
  	<option value="yes">yes, erase previous session</option>
  	<option value="no">no, keep alive previous session</option>
  	</select>	-->
  	<input type="hidden" name="username" value='<%if(username != null) out.print(username);%>'></input>
  	<input type="hidden" name="password" value='<%if(password != null) out.print(password);%>'></input>		
 
 	<input type="submit" class="confirmButton" id="" name="loginDataConfirmation" value="Retry Login"></input>
</form>
</body>
</html>