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

<div class="tegels">
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="blockwrapper" title="${tb.titel}">
            <div class="tegel tekstblok${tb.id}">
                <c:choose>
                    <c:when test="${tb.toonUrl}">
                        <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${!empty tb.url}">
                            <a href="${tb.url}" class="tegellink-full"></a>
                        </c:if>
                        ${tb.tekst}
                        <c:if test="${!empty tb.url}">
                            
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${showPlainAndMapButton == 'true'}">
    <script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script> 
</c:if>

<script type="text/javascript" src="<html:rewrite page='/scripts/viewerAddCmsId.js' module=''/>"></script>