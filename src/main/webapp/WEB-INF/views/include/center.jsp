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
	var j=0;
	var item;
	var arr = [];
	
	
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
				fillOpacity: 0.8,
				clickable: true
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

		
		 
/**		function getCenterNopin(Cx, Cy){
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
	**/
	
	</script>

	</body>
	</html>
