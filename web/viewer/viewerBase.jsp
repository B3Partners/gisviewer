<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<tiles:insert page="/templates/template.jsp" flush="true">
  <tiles:put name="menu"   value="/nav/topmenu.jsp" />
  <tiles:put name="content"   value="/viewer/Cviewer.jsp" />
</tiles:insert>
