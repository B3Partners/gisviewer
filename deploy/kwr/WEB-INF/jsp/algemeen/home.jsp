<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript">
    <!--
    function reloadOpener() {
        window.opener.document.forms[0].submit();
    }

    function reloadAndClose() {
        //reloadOpener();
        window.close();
    }
    // -->
</script>

<tiles:insert definition="actionMessages"/>

<!-- Loop door tekstblokken heen -->
<c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
    <div class="content_block">
        <div class="content_title"><c:out value="${tb.titel}"/></div>

        <!-- Indien toonUrl aangevinkt is dan inhoud van url in iFrame tonen -->
        <c:if test="${tb.toonUrl}">
            <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
        </c:if>

        <!-- Anders gewoon de tekst tonen van tekstblok -->
        <c:if test="${!tb.toonUrl}">
        <div class="inleiding_body">
            ${tb.tekst}

            <c:if test="${!empty tb.url}">
            Meer informatie: <a href="${tb.url}" target="_new">${tb.url}</a>
            </c:if>

            <c:if test="${tb.toonUrl}">
                <iframe id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
            </c:if>
        </div>
        </c:if>
    </div>
</c:forEach>

<c:if test="${pageContext.request.remoteUser != null}">
    <div class="uitloggen">
        <p><tiles:insert name="loginblock"/></p>
    </div>
</c:if>
