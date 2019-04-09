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
	var markerList = [];
	var markerCnt = 0;
	var markerCenter;
	var centerChk = false;
	var item

	naver.maps.Event.addListener(map, 'click', function(e) {

    	var point = e.coord;

    	new naver.maps.Marker({
        	map: map,
        	position: point
    	});
	});

function getCenter(metre) {
	if(centerChk == true){
        centerCircle.setMap(null);
        centerChk = false;
        markerCenter.setMap(null);
    }
    if(markerList[0] == null || markerList[1] == null || markerList[2] == null){
        alert('최소 3개의 핀을 지정해 주셔야 합니다!');
        return;
    }
    closeMouseInfoWindow();
    var A = 0, Cx = 0, Cy = 0;
    for(var i = 0; i< markerList.length; i++){
        var x = markerList[i].position.x;
        var xN = markerList[(i+1) % markerList.length].position.x;
        var y = markerList[i].position.y;
        var yN = markerList[(i+1) % markerList.length].position.y;
        var fac = (x * yN - xN * y);
        A += fac;
        Cx += (x + xN) * fac;
        Cy += (y + yN) * fac;
    }
    A /= 2;
    A *= 6;
    fac = 1 / A;
    Cx *= fac;
    Cy *= fac;
    console.log('x : ' + Cx + ' y : ' + Cy);
    centerAddr = new naver.maps.Point(Cx, Cy);
    
    map.setCenter(centerAddr); 
    markerCenter = new naver.maps.Marker({
    position: new naver.maps.LatLng(centerAddr)
    ,map: map
    ,title: '원을 클릭해 보세요!'
    ,animation: naver.maps.Animation.DROP
    }); 


var circle = new naver.maps.Circle({
    map: map,
 	center: centerAddr,
    radius: metre,
    fillColor: 'crimson',
    fillOpacity: 0.8
});
}


</script>
</body>
</html>