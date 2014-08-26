<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form  enctype="multipart/form-data" action="controller/controllerUploadDownload.jsp?action=uploadOverview" method="post">
Project Name <br>
<input id="projectName" name="projectName" type="text" class="shortInput"> <br>
<input name="file" type="file"><br>
<input type="submit" value="Upload" >
</form>
</body>
</html>