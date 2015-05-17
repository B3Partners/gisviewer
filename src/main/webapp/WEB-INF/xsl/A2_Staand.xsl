<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <!-- afmeting beschikbaar papier: breedte 41.2cm hoogte 58.6cm -->
    <!-- afmeting kaart: breedte 34.4cm hoogte 58.6cm  -->
    <xsl:variable name="map-width-px" select="'970'"/>
    <xsl:variable name="map-height-px" select="'1653'"/>

    <!-- edit when using three column legend layout -->
    <xsl:variable name="legend-column-w" select="42.0 div 3" />
    <xsl:variable name="pageHeightCm" select="59.4" />
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
            
            <fo:page-sequence master-reference="a2-staand">
                <fo:flow flow-name="body">

                    <fo:block-container width="6.6cm" height="1.5cm" top="0cm" left="34.6cm" xsl:use-attribute-sets="color1-column-block">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>
					
                    <fo:block-container width="6.6cm" height="52.4cm" top="1.6cm" left="34.6cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                    </fo:block-container>

                    <fo:block-container width="34.4cm" height="58.6cm" top="0cm" left="0cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block">
                            <xsl:with-param name="block-height" select="'58.6cm'"/>
                        </xsl:call-template>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="2.3cm" top="54.0cm" left="34.6cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container 
                        width="{$logo-block-width}" 
                        height="{$logo-block-height}" 
                        top="{$logo-top-a2-staand}" 
                        left="{$logo-left-a2-staand}" 
                        xsl:use-attribute-sets="column-block">
                        
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
                    
                    <xsl:call-template name="legend-three-columns"/>
    
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>