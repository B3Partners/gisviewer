<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <!-- afmeting beschikbaar papier: breedte 83.9cm hoogte 118.1cm -->
    <!-- afmeting kaart: breedte 76.7cm hoogte 118cm  -->
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

                    <fo:block-container width="6.6cm" height="1.5cm" top="0cm" left="77.3cm" xsl:use-attribute-sets="color1-column-block">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>
					
                    <fo:block-container width="6.6cm" height="110.4cm" top="1.6cm" left="77.3cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                        <xsl:call-template name="legend-block">
                            <xsl:with-param name="block-height" select="'110.4cm'"/>
                        </xsl:call-template>
                    </fo:block-container>

                    <fo:block-container width="76.7cm" height="118cm" top="0cm" left="0cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block">
                            <xsl:with-param name="block-height" select="'118cm'"/>
                        </xsl:call-template>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="2.3cm" top="113.5cm" left="77.3cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container 
                        width="{$logo-block-width}" 
                        height="{$logo-block-height}" 
                        top="{$logo-top-a0-staand}" 
                        left="{$logo-left-a0-staand}" 
                        xsl:use-attribute-sets="column-block">
                        
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
    
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>