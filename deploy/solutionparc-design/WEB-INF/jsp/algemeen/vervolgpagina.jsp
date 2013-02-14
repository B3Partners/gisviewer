<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<h1><img src="<html:rewrite page="/images/solutionparc-design/pageicons/${icon}.png"/>" alt="" /> ${titel}</h1>

<div class="solutionparc_vervolgblocks">
    <c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
        <div class="blockwrapper">
            <h2 class="content_title"><c:out value="${tb.titel}"/></h2>
            <c:set var="style" value="" />
            <c:if test="${!empty tb.kleur}">
                <c:set var="style" value=" style=\"background-color: ${tb.kleur}\"" />
            </c:if>
            <div class="vervolg_tegel"${style}>
                <div class="innerwrapper">
                    <c:choose>
                        <c:when test="${tb.toonUrl}">
                            <iframe class="iframe_tekstblok" id="iframe_${tb.titel}" name="iframe_${tb.titel}" frameborder="0" src="${tb.url}"></iframe>
                        </c:when>
                        <c:otherwise>
                            ${tb.tekst}
                            <c:if test="${!empty tb.url}">
                                <a href="${tb.url}" target="_new">${tb.url}</a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<div style="clear: both;"></div>

<hr>
<div>
    <div style="float: right;">
        <address>Zonnebaan 12C</address>
    </div>
</div>
<script type="text/javascript" src="<html:rewrite page='/scripts/viewerswitch.js' module=''/>"></script>