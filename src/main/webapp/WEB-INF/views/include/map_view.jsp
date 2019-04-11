<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>우리 지금 만나</title>
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
         <div id="main_title" class="player">
            <div class="title_str">참가자 목록</div>
         </div>
      </div>
   </div>
   <!-- 지도 -->
   <div id="map"></div>
   <!-- 결과선택 -->
   <div id="result">
      <button type="button" class="btn btn-outline-primary btn-lg"
         onclick="clearMap()">모든 표시 지우기</button>
      &nbsp;
      <button type="button" class="btn btn-outline-primary btn-lg"
         onclick="getCenter(100)">중심부터 100m 찾기</button>
      &nbsp;
      <button type="button" class="btn btn-outline-primary btn-lg"
         onclick="getCenter(200)">중심부터 200m 찾기</button>
      &nbsp;
      <button type="button" class="btn btn-outline-primary btn-lg"
         onclick="getCenter(500)">중심부터 500m 찾기</button>
   </div>
</body>
</html>