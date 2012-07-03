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
    <xsl:template match="info">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a4-staand">
                <fo:flow flow-name="body">
                    <fo:block-container width="7.6cm" height="2.3cm" top="0cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>                    
                    <fo:block-container width="5.8cm" height="24.0cm" top="1.6cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                    </fo:block-container>
                    <fo:block-container width="14.3cm" height="24.0cm" top="1.6cm" left="6.1cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block"/>
                    </fo:block-container>                    
                    <fo:block-container width="6.6cm" height="4.0cm" top="23.3cm" left="0.5cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="noordpijl-block"/>
                    </fo:block-container>
                    <fo:block-container width="12.0cm" height="2.3cm" top="26.0cm" left="6.1cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>             
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    
    <xsl:template name="logo-block">
        <fo:block>
            <fo:external-graphic src="url('kwr_logo_241x46.png')" width="241px" height="46px"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="info-block">
        <fo:block margin-left="0.2cm" word-spacing="0.075cm" font-size="11pt" font-family="Tahoma" font-weight="bold">
            <xsl:value-of select="titel"/>
        </fo:block>
        
        <fo:block margin-left="0.2cm" margin-top="0.1cm" font-size="8pt" font-family="Tahoma" font-weight="bold">
            <xsl:value-of select="datum"/>
        </fo:block>

        <fo:block margin-left="0.2cm" margin-right="0.4cm" margin-top="0.5cm" line-height="1.5" font-size="8pt" font-family="Tahoma">
            <xsl:value-of select="opmerking"/>
        </fo:block>
    </xsl:template>

    <!-- create map -->    
    <xsl:template name="map-block">
        <xsl:variable name="bbox-corrected">
            <xsl:call-template name="correct-bbox">
                <xsl:with-param name="bbox" select="bbox"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="px-ratio" select="format-number($map-height-px div $map-width-px,'0.##','MyFormat')" />
        <xsl:variable name="map-height-px-corrected" select="kwaliteit"/>
        <xsl:variable name="map-width-px-corrected" select="format-number(kwaliteit div $px-ratio,'0','MyFormat')"/>
        <xsl:variable name="map">
            <xsl:value-of select="imageUrl"/>
            <xsl:text>&amp;width=</xsl:text>
            <xsl:value-of select="$map-width-px-corrected"/>
            <xsl:text>&amp;height=</xsl:text>
            <xsl:value-of select="$map-height-px-corrected"/>
            <xsl:text>&amp;bbox=</xsl:text>
            <xsl:value-of select="$bbox-corrected"/>
        </xsl:variable>

        <fo:block-container margin-top="0.5cm" height="17cm" xsl:use-attribute-sets="column-block">
            <fo:block margin-left="0.05cm" margin-right="0.05cm">
                <fo:external-graphic src="{$map}" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform" width="{$map-width-px}" height="{$map-height-px}"/>
            </fo:block>
        </fo:block-container>
    </xsl:template>
    
    <xsl:template name="noordpijl-block">
        <fo:block margin-left="1.7cm">
            <fo:external-graphic src="url('kwr_noordpijl.png')" width="38px" height="38px"/>
        </fo:block>

        <!-- create scalebar -->
        <fo:block margin-left="0.2cm" margin-top="0.1cm">
            <xsl:call-template name="calc-scale">
                <xsl:with-param name="m-width">
                    <xsl:call-template name="calc-bbox-width-m-corrected">
                        <xsl:with-param name="bbox" select="bbox"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="px-width" select="$map-width-px"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="disclaimer-block">
        <fo:block margin-left="0cm" margin-top="0.1cm" font-size="8pt" font-family="FedraSansI, Tahoma" font-style="italic">
            Aan deze kaart kunnen geen rechten worden ontleend.
        </fo:block>
    </xsl:template>
</xsl:stylesheet>