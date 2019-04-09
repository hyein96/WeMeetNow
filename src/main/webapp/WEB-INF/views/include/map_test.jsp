<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/include/getCenter.jsp"/>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">	
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/main.css"/>
   	<link rel="stylesheet" href="css/bootstrap.css">
   	<link rel="stylesheet" href="css/site.css">
   	<script type="text/javascript" src="${pageContext.request.contextPath}/js/map.js"></script>
   	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
   	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>  	
   	<script type="text/javascript" src="js/bootstrap.js"></script>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>우리 지금 만나</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw"></script> <!-- //지도 띄우는 코드 -->
   	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw&submodules=geocoder"></script><!-- // geocoder사용하려면 필요한 자바 스크립트 코드 -->
   	
</head>
<body>
<!-- 검색창 -->
   <div class="search">
         <input id="address" type="text" placeholder="검색할 주소" value="">
        <input id="submit" type="button" value="검색">
   </div>
   
   <!-- 참가자 추가 -->
   <div class="player_add">
         <div class="player_inner">    
            <button name="addStaff">참가자 추가</button> 
            <table border="1" style="margin-top:20px;width:130px">
              <tbody>
               <tr id="trStaff">
                   <td style="width:80px"><strong>참가자</strong></td>
                   <td style="width:50px">주소</td>
               </tr>
              </tbody>
          </table>
         </div>
   </div> 
   
   <!-- 지도 -->
   <div id="map">
   </div>
   
   <!-- 결과선택 -->
   <div>
   		<button type="button" class="btn btn-outline-primary btn-lg" onclick="clearMap()">모든 표시 지우기</button>
                &nbsp;
       	<button type="button" class="btn btn-outline-primary btn-lg" onclick=getCenter(100)>중심부터 100m 찾기</button>&nbsp;
        <button type="button" class="btn btn-outline-primary btn-lg" onclick=getCenter(200)>중심부터 200m 찾기</button>&nbsp;
        <button type="button" class="btn btn-outline-primary btn-lg" onclick=getCenter(500)>중심부터 500m 찾기</button>
   </div>

 
 	<script>
 
 		var map = new naver.maps.Map("map", {
     	center: new naver.maps.LatLng(37.3595316, 127.1052133),
     	zoom: 10,
     	mapTypeControl: true
 		});
 		
 		
 		var infoWindow = new naver.maps.InfoWindow({
     	anchorSkew: true
 		});

 		map.setCursor('pointer');

 		// search by tm128 coordinate
 		function searchCoordinateToAddress(latlng) {
     	var tm128 = naver.maps.TransCoord.fromLatLngToTM128(latlng);

     	var marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(latlng),
            map: map
        });
     	
     	infoWindow.close();

     	naver.maps.Service.reverseGeocode({
        location: tm128,
        coordType: naver.maps.Service.CoordType.TM128,
        encoding: naver.maps.Service.Encoding.UTF_8
     	}, function(status, response) {
        if (status === naver.maps.Service.Status.ERROR) {
             return alert('Something Wrong!');
        }

        var items = response.result.items,
             htmlAddresses = [];

        for (var i=0, ii=items.length, item, addrType; i<ii; i++) {
             item = items[i];
             addrType = item.isRoadAddress ? '[도로명 주소]' : '[지번 주소]';

             htmlAddresses.push((i+1) +'. '+ addrType +' '+ item.address);
         }

         infoWindow.setContent([
                 '<div style="padding:10px;min-width:200px;line-height:150%;">',
                 '<h4 style="margin-top:5px;">검색 좌표</h4><br />',
                 htmlAddresses.join('<br />'),
                 '</div>'
             ].join('\n'));

         infoWindow.open(map, latlng);
     	});
 }

 // result by latlng coordinate
 function searchAddressToCoordinate(address) {
     naver.maps.Service.geocode({
         address: address,
         encoding: naver.maps.Service.Encoding.UTF_8

     }, function(status, response) {
         if (status === naver.maps.Service.Status.ERROR) {
             return alert('Something Wrong!');
         }

         var item = response.result.items[0],
             addrType = item.isRoadAddress ? '[도로명 주소]' : '[지번 주소]',
             point = new naver.maps.Point(item.point.x, item.point.y);

         infoWindow.setContent([
                 '<div style="padding:10px;min-width:200px;line-height:150%;">',
                 '<h4 style="margin-top:5px;">검색 주소 : '+ response.result.userquery +'</h4><br />',
                 addrType +' '+ item.address +'<br />',
                 '</div>'
             ].join('\n'));


         map.setCenter(point);
         infoWindow.open(map, point);
     });
 }
 
 /*참가자 추가*/
 //추가 버튼
 
	function add(){
	  map.addListener('click', function(e){
		  var latlng = e.coord,
         utmk = naver.maps.TransCoord.fromLatLngToUTMK(latlng),
         tm128 = naver.maps.TransCoord.fromUTMKToTM128(utmk),
         naverCoord = naver.maps.TransCoord.fromTM128ToNaver(tm128);

        utmk.x = parseFloat(utmk.x.toFixed(1));
        utmk.y = parseFloat(utmk.y.toFixed(1));

        var addStaffText =  '<tr name="trStaff">'+
            '<td class="active col-md-1"><strong>참가자</strong></td>'+
            '<td class="col-md-11">'+
            ('LatLng: ' + latlng.toString())+
            '<button class="btn btn-default" name="delStaff">삭제</button>'+
            '</td>'+
            '</tr>';
             
        var trHtml = $( "tr[name=trStaff]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
         
        trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.
	  });
        
      //삭제 버튼
        $(document).on("click","button[name=delStaff]",function(){
             
            var trHtml = $(this).parent().parent();
             
            trHtml.remove(); //tr 테그 삭제
             
        });
      searchAddressToCoordinate('');
 }
  
 
 /*function initGeocode() {
	    var latlng = map.getCenter();
	    var utmk = naver.maps.TransCoord.fromLatLngToUTMK(latlng); // 위/경도 -> UTMK
	    var tm128 = naver.maps.TransCoord.fromUTMKToTM128(utmk);   // UTMK -> TM128
	    var naverCoord = naver.maps.TransCoord.fromTM128ToNaver(tm128); // TM128 -> NAVER

	    infoWindow = new naver.maps.InfoWindow({
	        content: ''
	    });

	    map.addListener('click', function(e) {
	        var latlng = e.coord,
	            utmk = naver.maps.TransCoord.fromLatLngToUTMK(latlng),
	            tm128 = naver.maps.TransCoord.fromUTMKToTM128(utmk),
	            naverCoord = naver.maps.TransCoord.fromTM128ToNaver(tm128);

	        utmk.x = parseFloat(utmk.x.toFixed(1));
	        utmk.y = parseFloat(utmk.y.toFixed(1));

	        infoWindow.setContent([
	            '<div style="padding:10px;width:380px;font-size:14px;line-height:20px;">',
	            '<strong>LatLng</strong> : '+ latlng +'<br />',
	            '</div>'
	        ].join(''));

	        infoWindow.open(map, latlng);
	        console.log('LatLng: ' + latlng.toString());
	        console.log('UTMK: ' + utmk.toString());
	        console.log('TM128: ' + tm128.toString());
	        console.log('NAVER: ' + naverCoord.toString());
	    });
	}

	naver.maps.onJSContentLoaded = initGeocode; */

	/*클릭하면 주소 뜨게하는 코드*/
    function initGeocoder() {
         map.addListener('click', function(e) {
             searchCoordinateToAddress(e.coord);
         });
    
         $('#address').on('keydown', function(e) {
             var keyCode = e.which;
    
             if (keyCode === 13) { // Enter Key
                 searchAddressToCoordinate($('#address').val());
             }
         });
    
         $('#submit').on('click', function(e) {
             e.preventDefault();
    
             searchAddressToCoordinate($('#address').val());
         });
         
         add();
    
         searchAddressToCoordinate('');
         
     }
    
     naver.maps.onJSContentLoaded = initGeocoder;
     

 
 </script>
 <script type="text/javascript" src="js/bootstrap.js"></script>
</body>
</html>