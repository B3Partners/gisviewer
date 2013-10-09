<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:if test="${!empty cmsPage}">
    <h1>${cmsPage.titel}</h1>
    ${cmsPage.tekst}
</c:if>

<c:if test="${empty cmsPage}">
    <h1>CMS Pagina</h1>
</c:if>

<script type="text/javascript">
    /* cmd id klaarzetten voor viewer links */
    var cmsPageId = ${cmsPage.id};
</script>

<c:if test="${showPlainAndMapButton == 'true'}">
    <div class="viewerswitch"></div>
</c:if>

<!-- Loop door tekstblokken heen -->
<c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
    <div class="content_block item">
        <div class="content_title">
            <c:out value="${tb.titel}"/>
            <c:if test="${tb.inlogIcon}">
                <html:image align="top" page="/images/icons/inlog_needed.png" title="Inlog is vereist voor deze applicatie"/>
            </c:if>
        </div>

        <!-- Indien toonUrl aangevinkt is dan inhoud van url in iFrame tonen -->
        <c:if test="${tb.toonUrl}">
            <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
        </c:if>

        <!-- Anders gewoon de tekst tonen van tekstblok -->
        <c:if test="${!tb.toonUrl}">
            <div class="inleiding_body tekstblok${tb.id}">
                ${tb.tekst}

                <c:if test="${!empty tb.url}">
                Meer informatie: <a href="${tb.url}">${tb.url}</a>
                </c:if>

                <c:if test="${tb.toonUrl}">
                    <iframe id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                </c:if>
            </div>
        </c:if>
    </div>
</c:forEach>

<div style="clear: both;"></div>

<c:if test="${showPlainAndMapButton == 'true'}">
    <script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script> 
</c:if>

<script type="text/javascript" src="<html:rewrite page='/scripts/viewerAddCmsId.js' module=''/>"></script>