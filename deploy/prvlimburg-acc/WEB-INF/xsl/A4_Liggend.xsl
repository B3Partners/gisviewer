<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <!-- formatter -->
    <xsl:decimal-format name="MyFormat" decimal-separator="." grouping-separator=","
    infinity="INFINITY" minus-sign="-" NaN="Not a Number" percent="%" per-mille="m"
    zero-digit="0" digit="#" pattern-separator=";" />

    <!-- vars -->
    <xsl:variable name="ratio" select="format-number(info/mapHeight div info/mapWidth,'0.##','MyFormat')" />

    <xsl:variable name="map-height">455</xsl:variable>
    <xsl:variable name="map-width" select="format-number($map-height div $ratio,'####','MyFormat')" />

    <!-- includes -->
    <xsl:include href="calc.xsl"/>
    <xsl:include href="styles.xsl"/>

    <!-- master set -->
    <xsl:template name="layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="a4-liggend" page-height="210mm" page-width="297mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
        </fo:layout-master-set>
    </xsl:template>

    <!-- root -->
    <xsl:template match="info">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a4-liggend">
                <fo:flow flow-name="body">
                    <fo:block-container width="26.9cm" height="1.5cm" top="0cm" left="0cm" background-color="#9E3A56" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>

                    <fo:block-container width="1.5cm" height="1.5cm" top="0cm" left="26.9cm" background-color="#76B6D1" xsl:use-attribute-sets="column-block">
                        <fo:block />
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="0.75cm" top="1.6cm" left="0cm" background-color="#76B6D1" xsl:use-attribute-sets="column-block">
                        <fo:block margin-left="0.2cm" margin-top="0.2cm" xsl:use-attribute-sets="default-font">
                            Info
                        </fo:block>
                    </fo:block-container>

                    <fo:block-container width="6.6cm" height="15.4cm" top="2.35cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                    </fo:block-container>

                    <fo:block-container width="21.7cm" height="16.2cm" top="1.6cm" left="6.7cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block"/>
                    </fo:block-container>

                    <fo:block-container width="19.0cm" height="2.3cm" top="17.9cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container width="7.6cm" height="2.3cm" top="17.9cm" left="20.8cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
    
    <!-- blocks -->
    <xsl:template name="title-block">        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="title-font">
            <xsl:value-of select="titel"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="info-block">        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">
            <fo:block>
                <fo:external-graphic src="url('limburg_noordpijl.jpg')" width="45px" height="46px"/>
            </fo:block>

            <fo:block margin-left="0.2cm" margin-top="0.5cm" font-size="9pt">
                schaal
            </fo:block>

            <!-- create scalebar -->
            <fo:block margin-left="0.2cm" margin-top="0.2cm">
                <xsl:call-template name="calc-scale">
                    <xsl:with-param name="m-width">
                        <xsl:call-template name="calc-bbox-width-m-corrected">
                            <xsl:with-param name="bbox" select="bbox"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="px-width" select="$map-width"/>
                </xsl:call-template>
            </fo:block>

            <fo:block margin-left="0.2cm" margin-top="0.5cm" font-size="10pt">
                <xsl:value-of select="datum"/>
            </fo:block>

            <fo:block margin-left="0.2cm" margin-top="0.1cm" font-size="10pt">
                bureau Geo en Administraties
            </fo:block>

            <fo:block margin-left="0.2cm" margin-top="0.1cm" font-size="10pt" color="#9E3A56" font-weight="bold">
                sector GIS
            </fo:block>

            <fo:block margin-left="0.2cm" margin-top="0.3cm" font-size="8pt" font-style="italic">
                <xsl:value-of select="opmerking"/>
            </fo:block>

        </fo:block>
    </xsl:template>

    <!-- create map -->    
    <xsl:template name="map-block">
        <xsl:variable name="bbox-corrected">
            <xsl:call-template name="correct-bbox">
                <xsl:with-param name="bbox" select="bbox"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="map">
            <xsl:value-of select="imageUrl"/>
        </xsl:variable>

        <fo:block margin-left="0.1cm" margin-top="0.05cm">
            <fo:external-graphic
                src="{$map}"
                content-width="scale-to-fit"
                content-height="scale-to-fit"
                scaling="uniform"
                width="{$map-width}"
                height="{$map-height}"
            />
        </fo:block>
    </xsl:template>
    
    <xsl:template name="disclaimer-block">
        <fo:block margin-left="0.2cm" margin-top="0.5cm" color="#000000" xsl:use-attribute-sets="default-font">
            <fo:block xsl:use-attribute-sets="disclaimer-font" font-weight="bold">
                Disclaimer
            </fo:block>
            <fo:block xsl:use-attribute-sets="disclaimer-font">
                Op het gebruik van de door de provincie Limburg aan u verstrekte
                gegevens zijn de volgende gebruiksvoorwaarden van toepassing.
            </fo:block>
            <fo:block xsl:use-attribute-sets="disclaimer-font" margin-left="0.7cm">
                1. De juistheid, volledigheid en actualiteit van de gegevens kan
                niet worden gegarandeerd.
            </fo:block>
            <fo:block xsl:use-attribute-sets="disclaimer-font" margin-left="0.7cm">
                2. Het gebruik van de verstrekte gegevens geschiedt op eigen risico,
                de provincie Limburg kan niet aansprakelijk worden gesteld voor
                schade van welke aard dan ook die voortvloeit uit of in verband
                staat met het gebruik van de verstrekte gegevens.
            </fo:block>
            <fo:block xsl:use-attribute-sets="disclaimer-font" margin-left="0.7cm">
                3. De verstrekte gegevens mogen ter beschikking worden gesteld
                aan derden, onder voorwaarde dat deze gebruiksvoorwaarden door
                u aan de betreffende derden worden verstrekt.
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block>
            <fo:external-graphic src="url('limburg_logo.jpg')" width="283px" height="57px"/>
        </fo:block>
    </xsl:template>    
</xsl:stylesheet>