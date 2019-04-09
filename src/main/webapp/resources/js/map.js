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

       searchAddressToCoordinate('정자동 178-1');
   }

   naver.maps.onJSContentLoaded = initGeocoder;
  
   /*  var mapOptions = {
         center: new naver.maps.LatLng(37.3595704, 127.105399),
         zoom: 10
   };

   var map = new naver.maps.Map('map', mapOptions); */
   