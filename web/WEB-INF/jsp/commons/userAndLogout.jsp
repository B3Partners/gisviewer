<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:choose>
    <c:when test="${pageContext.request.remoteUser != null}">
        <script type="text/javascript">  
            function logout() {
                var kburl = '${kburl}';
                var logoutLocation = '/kaartenbalie/logout.do'
                if (kburl!='') {
                    var pos = kburl.lastIndexOf("wms");
                    if (pos>=0) {
                        logoutLocation = kburl.substring(0,pos) + "logout.do";
                    }
                }
                lof = document.getElementById('logoutframe'); 
                lof.src=logoutLocation;
                location.href = '<html:rewrite page="/logout.do" module=""/>';
            };
        </script>
        <div id="logoutvak" style="display: none;">
            <iframe id="logoutframe" name="logoutframe" src=""></iframe>
        </div>
        Ingelogd als: <c:out value="${pageContext.request.remoteUser}"/> | <a href="#"  onclick="javascript:logout();">Uitloggen</a>
    </c:when>
    <c:otherwise>
        <html:link page="/login.do" module="">Inloggen</html:link>
    </c:otherwise>
</c:choose>
