<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <!-- afmeting beschikbaar papier: breedte 58.6cm hoogte 83.3cm -->
    <!-- afmeting kaart: breedte 51.8cm hoogte 83.3cm  -->
    <xsl:variable name="map-width-px" select="'1461'"/>
    <xsl:variable name="map-height-px" select="'2349'"/>

    <!-- edit when using three column legend layout -->
    <xsl:variable name="legend-column-w" select="59.4 div 3" />
    <xsl:variable name="pageHeightCm" select="84.1" />
    <xsl:variable name="bottom-marge" select="2.0" /> 

    <!-- includes -->
    <xsl:include href="pdf-calc.xsl"/>
    <xsl:include href="pdf-styles.xsl"/>
    <xsl:include href="pdf-commons.xsl"/>
    <xsl:include href="pdf-legend.xsl"/>

    <!-- root -->
    <xsl:template match="info">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a1-staand">
                <fo:flow flow-name="body">

                    <fo:block-container width="6.6cm" height="1.5cm" top="0cm" left="52.0cm" xsl:use-attribute-sets="color1-column-block">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>
					
                    <fo:block-container width="6.6cm" height="77.1cm" top="1.6cm" left="52cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                    </fo:block-container>

                    <fo:block-container width="51.8cm" height="83.3cm" top="0cm" left="0cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block">
                            <xsl:with-param name="block-height" select="'83.3cm'"/>
                        </xsl:call-template>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="2.3cm" top="78.7cm" left="52cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container 
                        width="{$logo-block-width}" 
                        height="{$logo-block-height}" 
                        top="{$logo-top-a1-staand}" 
                        left="{$logo-left-a1-staand}" 
                        xsl:use-attribute-sets="column-block">
                        
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
                    
                    <xsl:call-template name="legend-three-columns"/>
    
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>