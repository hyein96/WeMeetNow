<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/include/map_view.jsp" />
<jsp:include page="/WEB-INF/views/include/center.jsp" />



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/css/main.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/map.js"></script>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<title>우리 지금 만나</title>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw"></script>
<!-- //지도 띄우는 코드 -->
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=3jkj67jisw&submodules=geocoder"></script>
<!-- // geocoder사용하려면 필요한 자바 스크립트 코드 -->
<script type="text/javascript" src="js/bootstrap.js"></script>

</head>
<body>
	<script>
		var map = new naver.maps.Map("map", {
			center : new naver.maps.LatLng(37.3595316, 127.1052133),
			zoom : 10,
			mapTypeControl : true
		});

		var infoWindow = new naver.maps.InfoWindow({
			anchorSkew : true
		});

		map.setCursor('pointer');

		function openMap(f) {
			var myaddress = f.firAddr.value;// 도로명 주소나 지번 주소만 가능 (건물명 불가!!!!)
			naver.maps.Service.geocode({
				address : myaddress
			}, function(status, response) {

				if (status !== naver.maps.Service.Status.OK) {
					return alert(myaddress + '의 검색 결과가 없거나 기타 네트워크 에러');
				}
				var result = response.result;
				var myaddr = new naver.maps.Point(result.items[0].point.x,
						result.items[0].point.y);

				map.setCenter(myaddr); // 검색된 좌표로 지도 이동
				//이전에 마크가 찍혀있는지 확인_있다면 center 처리만 하고 return
				for (var i = 0; i < markerList.length; i++) {
					if (markerList[i].position.x == myaddr.x
							&& markerList[i].position.y == myaddr.y) {
						var markerChk = true;
						break;
					}
				}

				if (markerChk == true)
					return;
				// 마커 표시
				var marker = new naver.maps.Marker({
					position : new naver.maps.LatLng(myaddr),
					map : map,
					title : markerCnt++,
					animation : naver.maps.Animation.BOUNCE
				});

				markerList.push(marker);

				console.log('m' + markerCnt + ' x : ' + myaddr.x + ' y : '
						+ myaddr.y);
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
					anchorSkew : true
				});
				infowindow.open(map, marker);
			});

		}

		// search by tm128 coordinate
		function searchCoordinateToAddress(latlng) {
			var tm128 = naver.maps.TransCoord.fromLatLngToTM128(latlng);

			//클릭하는 곳 마커 띄우는 코드
			var marker = new naver.maps.Marker({
				position : new naver.maps.LatLng(latlng),
				map : map,
				title : markerCnt++
			});

			markerList.push(marker);

			infoWindow.close();

			naver.maps.Service
					.reverseGeocode(
							{
								location : tm128,
								coordType : naver.maps.Service.CoordType.TM128,
								encoding : naver.maps.Service.Encoding.UTF_8
							},
							function(status, response) {
								if (status === naver.maps.Service.Status.ERROR) {
									return alert('Something Wrong!');
								}

								var items = response.result.items, htmlAddresses = [];

								for (var i = 0, ii = items.length, item, addrType; i < ii; i++) {
									item = items[i];
									addrType = item.isRoadAddress ? '[도로명 주소]'
											: '[지번 주소]';

									htmlAddresses.push((i + 1) + '. '
											+ addrType + ' ' + item.address);
								}

								infoWindow
										.setContent([
												'<div style="padding:10px;min-width:200px;line-height:150%;">',
												htmlAddresses.join('<br />'),
												'</div>' ].join('\n'));

								j++;

								// 지도 클릭할 때 옆에 참가자 추가 하기위해 만든 코드
								var addStaffText = '<div class="player">'
										+ '<div><strong>참가자</strong>'
										+ j
										+ '</div>'
										+ '<div class="des_str">'
										+ (infoWindow.getContent()).toString()
										+ '</div>'
										+ '<div class="des_btn">'
										+ '<button class="btn btn-default" name="delStaff" id = '+j+'>삭제</button>'
										+ '</div>' + '</div>';

								var trHtml = $("div[class=player]:last"); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
								trHtml.after(addStaffText); //마지막 trStaff태그(test.jsp) 뒤에 addStaffText 추가

								//var del = $("div[id=m]:last").text();

								//좌표로 얻어온 정보 지도에 띄우기
								infoWindow.open(map, latlng);
								//삭제 버튼
								$(document).on(
										"click",
										"button[name=delStaff]",
										function() {
											var trHtml = $(this).parent()
													.parent();
											trHtml.remove(); //tr 테그 삭제 

											var del = $(this).attr("id");
											markerList[del - 1].setMap(null);
										});

							});
		}

		// result by latlng coordinate
		function searchAddressToCoordinate(address) {
			naver.maps.Service
					.geocode(
							{
								address : address,
								encoding : naver.maps.Service.Encoding.UTF_8
							},
							function(status, response) {
								if (status === naver.maps.Service.Status.ERROR) {
									return alert('Something Wrong!');
								}

								var item = response.result.items[0], addrType = item.isRoadAddress ? '[도로명 주소]'
										: '[지번 주소]', point = new naver.maps.Point(
										item.point.x, item.point.y);

								infoWindow
										.setContent([
												'<div style="padding:10px;min-width:200px;line-height:150%;">',
												'<h4 style="margin-top:5px;">검색 주소 : '
														+ response.result.userquery
														+ '</h4><br />',
												addrType + ' ' + item.address
														+ '<br />', '</div>' ]
												.join('\n'));

								map.setCenter(point);
								infoWindow.open(map, point);
							});
		}

		/*클릭하면 주소 뜨게하는 코드*/
		function initGeocoder() {
			map.addListener('click', function(e) {
				searchCoordinateToAddress(e.coord);
				add(e.coord);
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
		}

		var mouseInfoWindow = new naver.maps.InfoWindow({
			anchorSkew : true,
			backgroundColor : '#fff'
		//      ,disableAnchor: true
		});

		naver.maps.onJSContentLoaded = initGeocoder;
		map.setCursor('pointer');

		/*인포 윈도우 없어지기*/

		function closeMouseInfoWindow() {
			mouseInfoWindow.close();
		}
	</script>
</body>
</html>