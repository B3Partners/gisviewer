<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <xsl:variable name="map-width-px" select="'2170'"/>
    <xsl:variable name="map-height-px" select="'3313'"/>

    <!-- includes -->
    <xsl:include href="pdf-calc.xsl"/>
    <xsl:include href="pdf-styles.xsl"/>
    <xsl:include href="pdf-commons.xsl"/>

    <!-- root -->
    <xsl:template match="info">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a0-staand">
                <fo:flow flow-name="body">

                    <fo:block-container width="6.6cm" height="115.0cm" top="2.4cm" left="76.9cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="title-block"/>
						<xsl:call-template name="info-block"/>
						<xsl:call-template name="legend-block">
							<xsl:with-param name="block-height" select="'27.0cm'"/>
						</xsl:call-template>
                   </fo:block-container>

                    <fo:block-container width="76.7cm" height="118cm" top="0.2cm" left="0.2cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block">
							<xsl:with-param name="block-height" select="'118cm'"/>
						</xsl:call-template>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="2.3cm" top="116.2cm" left="76.9cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="2.3cm" top="0cm" left="77.2cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>