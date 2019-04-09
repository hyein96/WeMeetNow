<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/include/test.jsp"/> 

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">	
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/main.css"/>
   	<link rel="stylesheet" href="css/bootstrap.min.css">
   	<script type="text/javascript" src="${pageContext.request.contextPath}/js/map.js"></script>
   	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
   	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>  	
   	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>우리 지금 만나</title>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw"></script> <!-- //지도 띄우는 코드 -->
   	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw&submodules=geocoder"></script><!-- // geocoder사용하려면 필요한 자바 스크립트 코드 -->
   	
</head>
<body>

 
 	<script>
		var markerList = [];
		var markerCnt = 0;
		var markerCenter;
		var centerChk = false;
		var item
 
 		var map = new naver.maps.Map("map", {
     	center: new naver.maps.LatLng(37.3595316, 127.1052133),
     	zoom: 10,
     	mapTypeControl: true
 		});
 		
 		
 		var infoWindow = new naver.maps.InfoWindow({
     	anchorSkew: true
 		});

 		map.setCursor('pointer');
 		
 		function openMap(f){
 	          var myaddress = f.firAddr.value;// 도로명 주소나 지번 주소만 가능 (건물명 불가!!!!)
 	          naver.maps.Service.geocode({address: myaddress}, function(status, response) {
 	              
 	              if (status !== naver.maps.Service.Status.OK) {
 	                  return alert(myaddress + '의 검색 결과가 없거나 기타 네트워크 에러');
 	              }
 	              var result = response.result;
 	              var myaddr = new naver.maps.Point(result.items[0].point.x, result.items[0].point.y);
 	              
 	              map.setCenter(myaddr); // 검색된 좌표로 지도 이동
 	              //이전에 마크가 찍혀있는지 확인_있다면 center 처리만 하고 return
 	              for(var i = 0; i< markerList.length; i++){
 	                  if(markerList[i].position.x == myaddr.x && markerList[i].position.y == myaddr.y){
 	                      var markerChk = true;
 	                      break;
 	                  }
 	              }
 	              
 	              if(markerChk == true) return;
 	              // 마커 표시
 	              var marker = new naver.maps.Marker({
 	                position: new naver.maps.LatLng(myaddr)
 	                ,map: map
 	                ,title: markerCnt++
 	                ,animation: naver.maps.Animation.BOUNCE
 	              }); 
 	              
 	              markerList.push(marker);
 	              
 	              console.log('m' + markerCnt + ' x : ' + myaddr.x + ' y : ' + myaddr.y);
 	              // 마커 클릭 이벤트 처리
 	              naver.maps.Event.addListener(marker, "click", function(e) {
 	                if (infowindow.getMap()) {
 	                    infowindow.close();
 	                    marker.setAnimation(null);
 	                } else {
 	                    infowindow.open(map, marker);
 	                    marker.setAnimation(naver.maps.Animation.BOUNCE);
 	                }
 	              });
 	     		var infoWindow = new naver.maps.InfoWindow({
 	     	     	anchorSkew: true
 	     	 	});
 	            infowindow.open(map, marker);
 	          });
 	        }


 /*지도에서 마커모두 삭제*/
 
 function clearMap(){
            for(var i = 0; i < markerList.length; i++){
                markerList[i].setMap(null);
            }
            markerList.splice(0,markerList.length);
            markerChk = false;
            if(markerCenter != null) markerCenter.setMap(null);
            if(centerCircle != null) centerCircle.setMap(null);
            centerChk = false;
            markerCnt = 0;
        }
 
/*센터 구하기*/
 
 function getCenter(metre){
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
            centerCircle = new naver.maps.Circle({
                map: map,
                center: centerAddr,
                radius: metre,
                fillColor: '#69F499',
                fillOpacity: 0.8
                ,clickable: true
            }); 
            centerChk = true;
            naver.maps.Event.addListener(centerCircle, 'mouseover', function() {
                centerCircle.setOptions({
                    fillColor: '#777777'
                });
            });
            naver.maps.Event.addListener(centerCircle, 'mouseout', function() {
                centerCircle.setOptions({
                    fillColor: '#69F499'
                });
            });
            naver.maps.Event.addListener(centerCircle, 'click', function() {
                var f = document.createElement("form"); // form 엘리멘트 생성 
                f.setAttribute("method","post"); // method 속성 설정 
                f.setAttribute("action","/map"); // action 속성 설정 
                document.body.appendChild(f); // 현재 페이지에 form 엘리멘트 추가 
               
                var cenX = centerAddr.x;
                var cenY = centerAddr.y;
                
                var i = document.createElement("input");  
                i.setAttribute("type","hidden");
                i.setAttribute("name","cenX"); 
                i.setAttribute("value",cenX); 
                f.appendChild(i); 
                var j = document.createElement("input"); // input 엘리멘트 생성 
                j.setAttribute("type","hidden"); // type 속성을 hidden으로 설정 
                j.setAttribute("name","cenY"); 
                j.setAttribute("value",cenY); 
                f.appendChild(j); 
                var z = document.createElement("input");
                z.setAttribute("type","hidden"); 
                z.setAttribute("name","area"); 
                z.setAttribute("value",metre); 
                f.appendChild(z); 
                
                f.submit(); // 전송 
            });
        }
        
//////////////////////////////////////////        
 
function getCenterNopin(Cx, Cy){
            if(centerChk == true){
                centerCircle.setMap(null);
                centerChk = false;
                markerCenter.setMap(null);
            }
            
            console.log('x : ' + Cx + ' y : ' + Cy);
            centerAddr = new naver.maps.Point(Cx, Cy);
            
            map.setCenter(centerAddr); 
            markerCenter = new naver.maps.Marker({
            position: new naver.maps.LatLng(centerAddr)
            ,map: map
            ,title: '원을 클릭해 보세요!'
            ,animation: naver.maps.Animation.DROP
            }); 
            centerCircle = new naver.maps.Circle({
                map: map,
                center: centerAddr,
                radius: 200,
                fillColor: '#69F499',
                fillOpacity: 0.8
                ,clickable: true
            }); 
            centerChk = true;
            naver.maps.Event.addListener(centerCircle, 'mouseover', function() {
                centerCircle.setOptions({
                    fillColor: '#777777'
                });
            });
            naver.maps.Event.addListener(centerCircle, 'mouseout', function() {
                centerCircle.setOptions({
                    fillColor: '#69F499'
                });
            });
            naver.maps.Event.addListener(centerCircle, 'click', function() {
                var f = document.createElement("form"); // form 엘리멘트 생성 
                f.setAttribute("method","post"); // method 속성 설정 
                f.setAttribute("action","/map"); // action 속성 설정 
                document.body.appendChild(f); // 현재 페이지에 form 엘리멘트 추가 
               
                var cenX = centerAddr.x;
                var cenY = centerAddr.y;
                
                var i = document.createElement("input");  
                i.setAttribute("type","hidden");
                i.setAttribute("name","cenX"); 
                i.setAttribute("value",cenX); 
                f.appendChild(i); 
                var j = document.createElement("input"); // input 엘리멘트 생성 
                j.setAttribute("type","hidden"); // type 속성을 hidden으로 설정 
                j.setAttribute("name","cenY"); 
                j.setAttribute("value",cenY); 
                f.appendChild(j); 
                var z = document.createElement("input");
                z.setAttribute("type","hidden"); 
                z.setAttribute("name","area"); 
                z.setAttribute("value",100); 
                f.appendChild(z); 
                
                f.submit(); // 전송 
            });
        }
        
	// search by tm128 coordinate    
	function searchCoordinateToAddress(latlng) {
     	var tm128 = naver.maps.TransCoord.fromLatLngToTM128(latlng);

     	var marker = new naver.maps.Marker({
            position: new naver.maps.LatLng(latlng),
            map: map,
            title: markerCnt++          
        });
     	
     	markerList.push(marker);
     	
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
    
     
     var mouseInfoWindow = new naver.maps.InfoWindow({
         anchorSkew: true
           ,backgroundColor: '#fff'
//           ,disableAnchor: true
       });
     
     naver.maps.onJSContentLoaded = initGeocoder;
     map.setCursor('pointer');
     
     
     /*인포 윈도우 없어지기*/
     
     function closeMouseInfoWindow(){
              mouseInfoWindow.close();
          }

 
 </script>
 <script type="text/javascript" src="js/bootstrap.js"></script>
</body>
</html>