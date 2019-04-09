<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=mn7cwsrvym"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<meta charset="UTF-8">
<title>거리 구하기</title>
</head>
<body>
	<script type = "text/javascript">
	function makeLengthInfo(data){
    	var iwContent = '';
    	var distanceArray = [];
    	data.reduce(function(a,b){
        	var d = [];
        	var position1 = new naver.maps.LatLng(Number(a.split('/')[0]),Number(a.split('/')[1]));
        	var position2 = new naver.maps.LatLng(Number(b.split('/')[0]),Number(b.split('/')[1]));
        	d.push(position1, position2);
        	var x = (Number(a.split('/')[0])+Number(b.split('/')[0]))/2;
        	var y = (Number(a.split('/')[1])+Number(b.split('/')[1]))/2;
        	var positions = new naver.maps.LatLng(x,y);
        	var infoWinArray = new naver.maps.InfoWindow({
            	position: positions,
            	zIndex:1,
             	content:(getDistanceFromLatLonInKm(d)/1000)+"Km"
        	}).setMap(map);
        return b;
    });
    	
    	function getDistanceFromLatLonInKm(array) {
    	    var lat1 = array[0].jb;
    	    var lng1 = array[0].ib;
    	    var lat2 = array[1].jb;
    	    var lng2 = array[1].ib;
    	    
    	    function deg2rad(deg) {
    	        return deg * (Math.PI/180)
    	    }
    	    var r = 6371; //지구의 반지름(km)
    	    var dLat = deg2rad(lat2-lat1);
    	    var dLon = deg2rad(lng2-lng1);
    	    var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2);
    	    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    	    var d = r * c; // Distance in km
    	    return Math.round(d*1000);
    	}
}
</script>
</body>
</html>