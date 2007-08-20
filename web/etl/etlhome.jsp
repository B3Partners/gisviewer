<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>

INLOGGEN HIER GRAAG!!!!
DOE MAAR NU!!!
<%--
<c:set var="focus" value="j_username" scope="request"/> 
<tiles:insert definition="common.setFocus"/> 

<form action="j_security_check" method='post' >
    <div class="item">
        <fmt:message key="themabeheer.username"/>:
    </div>
    <div class="value">
        <input type="text" name="j_username">
    </div>
    <div class="item">
        <fmt:message key="themabeheer.password"/>:
    </div>
    <div class="value">
        <input type="password" name="j_password">
    </div>
    
    <html:submit property="login" styleClass="knop">
        <fmt:message key="button.login"/>
    </html:submit>
</form>
--%>
<h1>Overzicht verschillende Thema's met bijhorende resultaten</h1>
<table border="1">
    <tr>
        <td><b>Thema naam</b></td>
        <td><b>Aantal NO</b></td>
        <td><b>Aantal OAO</b></td>
        <td><b>Aantal OGO</b></td>
        <td><b>Aantal GO</b></td>
        <td><b>Aantal VO</b></td>
        <td><b>Aantal FO</b></td>
        <td><b>Aantal OO</b></td>
        <td><b>Totaal Aantal</b></td>
        <td><b>% incorrect</b></td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
    <tr>
        <td><b>Tankstation</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>71</td>
        <td>33 %</td>
    </tr>
    <tr>
        <td><b>GGA Gebieden</b></td>
        <td>8</td>
        <td>6</td>
        <td>44</td>
        <td>12</td>
        <td>121</td>
        <td>2</td>
        <td>9</td>
        <td>55</td>
        <td>12 %</td>
    </tr>
    <tr>
        <td><b>Gemeenten</b></td>
        <td>5</td>
        <td>6</td>
        <td>8</td>
        <td>12</td>
        <td>11</td>
        <td>2</td>
        <td>7</td>
        <td>234</td>
        <td>66 %</td>
    </tr>
</table>

<ul>
    <li>NO  - Nieuwe objecten</li>
    <li>OAO - Onvolledig Administratieve Objecten</li>
    <li>OGO - Onvolledig Geografische Objecten</li>
    <li>GO  - Geupdate Objecten</li>
    <li>VO  - Verwijderde Objecten</li>
    <li>FO  - Niet verwerkbare Objecten</li>
    <li>OO  - Ongewijzigde Objecten</li>
    <li>Totaal: alle objecten bij elkaar opgeteld</li>
    <li>% incorrect: de verhouding tussen OAO + OGO + FO en het totaal.</li>
</ul>
