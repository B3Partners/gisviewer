<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<tiles:insert page="/templates/template.jsp" flush="true">
  <tiles:put name="menu"   value="/nav/themabeheermenu.jsp" />
  <tiles:put name="content"   value="/etl/etlhome.jsp" />
</tiles:insert>
