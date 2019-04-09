<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<script>

	naver.maps.Event.addListener(map, 'click', function(e) {

    	var point = e.coord;

    	new naver.maps.Marker({
        	map: map,
        	position: point
    	});
	});



var circle = new naver.maps.Circle({
    map: map,
 	center: centerAddr,
    radius: 2000,
    fillColor: 'crimson',
    fillOpacity: 0.8
});


</script>
</body>
</html>