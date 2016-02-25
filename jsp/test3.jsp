<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<sql:setDataSource dataSource="jdbc/honzou" var = "ds"/>
<sql:query dataSource="${ds}" var="rs">
SELECT  id, name from vols order by id
</sql:query>

<fmt:requestEncoding value="utf-8" />
<c:if test="${!empty param.mokuji}">
<fmt:parseNumber var="vol" value="${param.mokuji}" integerOnly="true" />
</c:if>
<c:if test="${!empty param.shift_from_search}">
<fmt:parseNumber var="pg_c" value="${param.shift_from_search}"  integerOnly="true"/>
</c:if>
<c:if test="${empty param.mokuji}">
<fmt:parseNumber var="vol" value="1" integerOnly="true" />
</c:if>

<sql:query dataSource="${ds}" var="rs_vol">
SELECT  id, name,pages from vols where id=?
<sql:param value="${vol}" />
</sql:query>

<jsp:useBean id="pg" class="pkgHonzou.Pager" scope="session" />
<jsp:setProperty property="vol" name="pg" value="${vol}" />
<jsp:setProperty property="size" name="pg" value="${rs_vol.rows[0].pages}" />

<c:if test="${!empty param.shift and param.shift eq '次頁'}">
	<c:set var="pg_c" value="${pg.next}" />
</c:if>
<c:if test="${!empty param.shift and param.shift eq '最後'}">
	<c:set var="pg_c" value="${pg.last}" />
</c:if>
<c:if test="${!empty param.shift and param.shift eq '前頁'}">
	<c:set var="pg_c" value="${pg.prev}" />
</c:if>
<c:if test="${!empty param.shift and param.shift eq '表紙'}">
	<c:set var="pg_c" value="${pg.top}" />
</c:if>
<c:if test="${!empty param.shift and param.shift eq '移動'}">
	<fmt:parseNumber var="pos" value="${param.pos}" integerOnly="true" />
	<jsp:setProperty property="current" name="pg" value="${pos}" />
	<c:set var="pg_c" value="${pg.current}" />
</c:if>
<c:if test="${empty param.shift and empty param.shift_from_search}">
	<c:set var="pg_c" value="${pg.top}" />
</c:if>

<html>
<head>
<title>本草通串</title>
<style>
body{margin:0 auto;line-height:140%}
	#index{width:25%;text-aling:left;float:left;border-style:dotted;border-width:1px;/*overflow:scroll*/}
	#content_right{width:74%;text-aling:left;float:left;}
	#next{width:100px;text-aling:left;float:left;font-size:16pt;}
	#prev{width:100px;text-aling:right;float:left;font-size:16pt;}
	iframe{float:left;}
	td{vertical-align: top; white-space: nowrap;}
</style>
</head>
<body>
<center>

<div id="whole">
<div id="index">
<br />
<img src="fig_kampo.jpg">
<br />
ここに何か前書き<br />
<br />
<form method="POST" action="test3B.jsp">
<input type="text" id="search" name="search" size="40" value="">
<input type="submit" id="" name="vol" value="検索">
</form >
<form method="POST" action="test3.jsp">
<input type="submit" id="" name="vol" value="下の冊子を指定して閲覧">
<hr />
<select name="mokuji" size="30">
<c:forEach var="m" items="${rs.rows}" varStatus="st">
	<c:set var="selected" value="" />
	<c:if test="${m.id eq pg.vol}">
		<c:set var="selected" value="selected" />
	</c:if>
	<option value="${m.id}" ${selected}>第${m.id}冊:${m.name}</option>
</c:forEach>
</select>
</form>
</div>
<div id="content_right">

<h1>
本草通串第${pg.vol}冊（${rs_vol.rows[0].name}）
</h1>
<hr />
	<h2> ${pg.current+1}頁 ${pg.current}頁 ／ ${pg.size}頁 
<hr />
<fmt:formatNumber var="pg_display1" pattern="000" value="${pg.current}"/>
<fmt:formatNumber var="pg_display2" pattern="000" value="${pg.current+1}"/>
<sql:query dataSource="${ds}" var="rs_keys1">
SELECT  vol,page_no, word from keywords where vol=? and page_no=? 
<sql:param value="${vol}"/>
<sql:param value="${pg.current}"/>
</sql:query>
<sql:query dataSource="${ds}" var="rs_keys2">
SELECT  vol,page_no, word from keywords where vol=? and page_no=? 
<sql:param value="${vol}"/>
<sql:param value="${pg.current+1}"/>
</sql:query>
<table>
	<tr>
	<form method="POST" action="test3.jsp">
		<td nowrap>
		<select name="pos">
		<c:forEach var="idx" begin="1" end="${pg.size}">
			<c:set var="selected" value="" />
			<c:if test="${idx eq pg.current}">
				<c:set var="selected" value="selected" />
			</c:if>
			<option value="${idx}" ${selected}>${idx}</option>
		</c:forEach>
		</select>
		<input type="hidden" id="" name="mokuji" value="${pg.vol}">
		<input type="submit" id="" name="shift" value="移動">
		</td>
		<c:if test="${pg.hasNext eq true}">
			<td><input type="submit" id="next" name="shift" value="最後">
			<input type="submit" id="next" name="shift" value="次頁"></td>
		</c:if>
		<c:if test="${pg.hasNext ne true}">
			<td><input type="submit" id="next" name="shift" value="最後" disabled>
			<input type="submit" id="next" name="shift" value="次頁" disabled></td>
		</c:if>
		<c:if test="${pg.hasPrev eq true}">
			<td><input type="submit" id="prev" name="shift" value="前頁">
			<input type="submit" id="prev" name="shift" value="表紙"></td>
		</c:if>
		<c:if test="${pg.hasPrev ne true}">
			<td><input type="submit" id="prev" name="shift" value="前頁" disabled>
			<input type="submit" id="prev" name="shift" value="表紙" disabled></td>
		</c:if>

	</form>
	</tr>
<tr>

<td>
<c:forEach var="k" items="${rs_keys2.rows}">
${k.word}
<br />
</c:forEach>
</td>
<td><iframe src="./splits/本草通串第${vol}冊_${pg_display2}.pdf" width="600" height="850"></iframe></td>
<td><iframe src="./splits/本草通串第${vol}冊_${pg_display1}.pdf" width="600" height="850"></iframe></td>
<td>
<c:forEach var="k" items="${rs_keys1.rows}">
${k.word}
<br />
</c:forEach>
</td>
</tr>
</table>

</div>
</div>

</center>
</body>
</html>
