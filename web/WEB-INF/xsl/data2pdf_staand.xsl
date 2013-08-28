<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <xsl:variable name="map-width-px" select="'403'"/>
    <xsl:variable name="map-height-px" select="'678'"/>

    <!-- formatter -->
    <xsl:decimal-format name="MyFormat" decimal-separator="." grouping-separator=","
                        infinity="INFINITY" minus-sign="-" NaN="Not a Number" percent="%" per-mille="m"
                        zero-digit="0" digit="#" pattern-separator=";" />

    <!-- includes -->
    <xsl:include href="calc.xsl"/>
    <xsl:include href="styles.xsl"/>

    <!-- master set -->
    <xsl:template name="layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="a4-staand" page-height="297mm" page-width="210mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
        </fo:layout-master-set>
    </xsl:template>

    <!-- root -->
    <xsl:template match="pdfinfo">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a4-staand">
                <fo:flow flow-name="body">
                    
                    <xsl:if test="count(records) &gt; 0">
                        <xsl:for-each select="records/entry">
                            <fo:block-container width="20.45cm" height="1.5cm" top="0cm" left="0cm" background-color="#166299" xsl:use-attribute-sets="column-block">
                                <xsl:call-template name="title-block"/>
                            </fo:block-container>

                            <fo:block-container width="20.45cm" height="24.0cm" top="1.5cm" left="0cm" xsl:use-attribute-sets="column-block">
                                <xsl:call-template name="info-block"/>
                            </fo:block-container>

                            <fo:block-container width="12.0cm" height="2.3cm" top="26.7cm" left="0cm" xsl:use-attribute-sets="column-block">
                                <xsl:call-template name="disclaimer-block"/>
                            </fo:block-container>

                            <fo:block-container width="7.6cm" height="2.3cm" top="26.5cm" left="12.0cm" xsl:use-attribute-sets="column-block">
                                <xsl:call-template name="logo-block"/>
                            </fo:block-container>
                            
                            <fo:block page-break-after="always"/>
                        </xsl:for-each>
                        
                    </xsl:if>                    
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
    
    <!-- blocks -->
    <xsl:template name="title-block">        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="title-font">
            <xsl:value-of select="pdfinfo/titel"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="info-block">
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">

            <fo:block margin-left="0.2cm" margin-top="0cm" font-size="10pt">
                Gemaakt op: <xsl:value-of select="pdfinfo/datum"/>
            </fo:block>
            
            <xsl:if test="count(pdfinfo/records) &gt; 0">
                <fo:block margin-left="0.2cm" margin-top="0.5cm">
                    <xsl:for-each select="pdfinfo/records/entry">                
                        <fo:block margin-left="0cm" margin-top="0cm" font-size="8pt">  
                            Record id <xsl:value-of select="record/key"/>
                        </fo:block>
                    </xsl:for-each>            
                </fo:block>  
            </xsl:if>            

        </fo:block>
    </xsl:template>    
    
    <xsl:template name="disclaimer-block">
        <fo:block margin-left="0.2cm" margin-top="0.5cm" color="#000000" xsl:use-attribute-sets="default-font">
            Aan deze export kunnen geen rechten worden ontleend.
        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block>
            <fo:external-graphic src="url('b3p_logo.png')" width="231px" height="56px"/>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>