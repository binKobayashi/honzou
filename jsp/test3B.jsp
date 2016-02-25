<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:requestEncoding value="utf-8" />
<jsp:useBean id="kw" class="pkgHonzou.Search" scope="page" />
<jsp:setProperty property="word" name="kw" value="${param.search}" />

<sql:setDataSource dataSource="jdbc/honzou" var = "ds"/>
<sql:query dataSource="${ds}" var="rs">
SELECT  id,name,vol,page_no, word 
from keywords k,vols v 
where v.id=k.vol
and word like ${kw.word}
order by 3,4
</sql:query>

<%--
<sql:param value="${param.search}"/>
--%>


<html>
<head>
<title>本草通串検索</title>
<style>
body{margin:0 auto;line-height:140%}
	#result{width:25%;text-aling:left;float:left;border-style:dotted;border-width:1px;}
	#content_right{width:74%;text-aling:left;float:left;}
	iframe{float:left;}
	label{font-size:16pt;color:green;text-decoration: underline;cursor: pointer;}
</style>
<script src="./jq/jquery-1.11.0.js"></script>
<script type="text/javascript">
	$(function(){
		$(".link").on("click",function(){
			var v_vol=$(this).prop("id");
			var v_page=$(this).prop("for");
                        var vFrame="<iframe src='./splits/本草通串第"
					+v_vol+"冊_"
					+v_page+".pdf' width='600' height='850'>";

                        vFrame=vFrame+"</iframe>";
			$("#myframe").html( vFrame );
			$("#header_vol").text(v_vol);
			$("#header_page").text(Number(v_page));

			$.ajax({
				url:"getKeyWords.jsp",type:"POST",data:{vol:v_vol,page:v_page},
					success:function(msg){
						$("#mykeywords").html(msg);	
					}
				}
			);


		});
	})
	
</script>
</head>
<body>
<center>

<div id="whole">
<div id="result">
<br />
<img src="fig_kampo.jpg">
<br />
ここに何かロゴ？／下の検索で使えるサンプル語は、<br />
にんじん、人参、おうぎ、黄耆、だけです。
<br />
<form method="POST" action="test3.jsp">
<input type="submit" id="" name="vol" value="閲覧に戻る">
<input type="hidden" id="" name="mokuji" value="${pg.vol}">
<input type="hidden" id="" name="shift_from_search" value="${pg.current}">

</form>
<form method="POST" action="test3B.jsp">
<input type="text" id="search" name="search" size="40" value="${param.search}">
<input type="submit" id="" name="vol" value="検索">
</form >
<hr />
<table>
<c:forEach var="k" items="${rs.rows}" >
<tr>
<fmt:formatNumber var="pg_no" pattern="000" value="${k.page_no}"/>
<td><label class="link" id="${k.vol}" for="${pg_no}">第${k.vol}冊:${k.name}:${k.page_no}ページ</label>
<%--
 href="test3B.jsp?linkVol=${k.vol}&linkPage=${k.page_no}">第${k.vol}冊:${k.name}:${k.page_no}ページ</a></td>
--%>
</tr>
</c:forEach>

</table>

</div>
<div id="content_right">

<h1>
<c:set var="v_word" value="${fn:replace(kw.word,'%','')}" />
本草通串検索（キーワード＝${v_word}）
</h1>
<hr />
<c:set var="fst" value="${rs.rows[0]}" />
<c:if test="${!empty fst}">
	<h2><span>第</span><span id="header_vol">${fst.id}</span><span>冊</span><span id="header_page">${fst.page_no}</span><span>頁</span> ／ ${rs.rowCount}件</h2> 
<hr />
<fmt:formatNumber var="pg_display1" pattern="000" value="${fst.page_no}"/>
<table>
<tr>
<td id="myframe">
<iframe src="./splits/本草通串第${fst.id}冊_${pg_display1}.pdf" width="600" height="850"></iframe>
</td>
<td id="mykeywords">
</td>
</tr>
</table>
</c:if>
<c:if test="${empty fst}">
	<h2>該当する本草通串はありません</h2>
</c:if>
</div>
</div>

</center>
</body>
</html>
