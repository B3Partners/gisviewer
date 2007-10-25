<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:if test="${!fn:startsWith(pageContext.request.requestURL, \"https\")}">
    <!-- Google analytics -->
    <script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
    </script>
    <script type="text/javascript">
        _uacct = "UA-2873163-1";
        urchinTracker();
    </script>
</c:if>
