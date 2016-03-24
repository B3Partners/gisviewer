<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html" version="5.0" indent="yes"/>
	<!-- formatter -->
	<xsl:decimal-format name="MyFormat" decimal-separator="." grouping-separator="," infinity="INFINITY" minus-sign="-" NaN="Not a Number" percent="%" per-mille="m" zero-digit="0" digit="#" pattern-separator=";"/>
	<!-- includes -->
	<xsl:template match="pdfinfo">
		<html>
			<xsl:if test="count(records) &gt; 0">
				<xsl:for-each select="/pdfinfo/records/entry">
					<xsl:call-template name="title-block">
						<xsl:with-param name="currentRecord" select="position()"/>
						<xsl:with-param name="totalRecords" select="count(/pdfinfo/records/entry)"/>
					</xsl:call-template>
					<xsl:call-template name="info-block">
						<xsl:with-param name="myRecord" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<xsl:call-template name="footer-block"/>
		</html>
	</xsl:template>
	<!-- blocks -->
	<xsl:template name="title-block">
		<xsl:param name="currentRecord"/>
		<xsl:param name="totalRecords"/>
		<h1><xsl:value-of select="/pdfinfo/titel"/> (<xsl:value-of select="$currentRecord"/> van <xsl:value-of select="$totalRecords"/>)</h1>
    </xsl:template>
	<xsl:template name="footer-block">
		<hr/>
		<h6><xsl:value-of select="/pdfinfo/titel"/><xsl:text> - </xsl:text> <xsl:value-of select="/pdfinfo/datum"/></h6>
    </xsl:template>
	<xsl:template name="info-block">
		<xsl:param name="myRecord"/>
		<!-- Toon objectdata en uitsnede in tabel -->
		<xsl:if test="count($myRecord/value/items/entry) &gt; 0">
			<table>
				<tr valign="top">
					<td>
						<table>
							<!-- table with objectdata fields -->
							<xsl:for-each select="$myRecord/value/items/entry">
								<tr>
									<td>
										<xsl:value-of select="key"/>
									</td>
									<td>
                                                             : <xsl:value-of select="value"/>
									</td>
								</tr>
							</xsl:for-each>
						</table>
					</td>
					<!-- Tonen uitsnede -->
					<td>
						<xsl:variable name="url" select="$myRecord/value/imageUrl"/>
						<xsl:if test="$url">
							<img border-style="solid" border-width="medium" src="data:image/jpeg;base64,{$url}'" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform" width="500" height="375"/>
						</xsl:if>
					</td>
				</tr>
			</table>
			<!-- end table -->
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
