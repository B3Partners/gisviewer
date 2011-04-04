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
                    <fo:block-container width="18.2cm" height="1.5cm" top="0cm" left="0cm" background-color="#9E3A56" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>

                    <fo:block-container width="1.5cm" height="1.5cm" top="0cm" left="18.2cm" background-color="#76B6D1" xsl:use-attribute-sets="column-block">
                        <fo:block />
                    </fo:block-container>

                    <fo:block-container width="6.0cm" height="0.75cm" top="1.6cm" left="0cm" background-color="#76B6D1" xsl:use-attribute-sets="column-block">
                        <fo:block margin-left="0.2cm" margin-top="0.2cm" xsl:use-attribute-sets="default-font">
                            Info
                        </fo:block>
                    </fo:block-container>

                    <fo:block-container width="5.8cm" height="20.3cm" top="2.35cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="info-block"/>
                    </fo:block-container>

                    <fo:block-container width="5.8cm" height="3.7cm" top="22.2cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="scale-block"/>
                    </fo:block-container>

                    <fo:block-container width="14.3cm" height="24.0cm" top="1.6cm" left="6.1cm" xsl:use-attribute-sets="column-block-border">
                        <xsl:call-template name="map-block"/>
                    </fo:block-container>

                    <fo:block-container width="11.5cm" height="2.3cm" top="25.6cm" left="0cm" xsl:use-attribute-sets="column-block">
                        <xsl:call-template name="disclaimer-block"/>
                    </fo:block-container>

                    <fo:block-container width="7.6cm" height="2.3cm" top="26.5cm" left="12.6cm" xsl:use-attribute-sets="column-block">
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
            <fo:block margin-left="0.2cm" margin-top="1.5cm" font-size="8pt" font-style="italic">
                <xsl:value-of select="opmerking"/>
            </fo:block>

        </fo:block>
    </xsl:template>

    <xsl:template name="scale-block">
        <fo:block vertical-align="bottom" margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">
            <fo:block>
                <fo:external-graphic src="url('limburg_noordpijl.jpg')" width="45px" height="46px"/>
            </fo:block>

            <fo:block margin-left="0.2cm" font-size="9pt">
                <fo:table margin-left="-0.2cm">
                    <fo:table-column column-width="2.7cm"/>
                    <fo:table-column column-width="2.7cm"/>

                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block>schaal</fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block><xsl:value-of select="datum"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>

            <!-- create scalebar -->
            <fo:block margin-left="0.2cm" margin-top="0.2cm">
                <xsl:call-template name="calc-scale">
                    <xsl:with-param name="m-width">
                        <xsl:call-template name="calc-bbox-width-m-corrected">
                            <xsl:with-param name="bbox" select="bbox"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="px-width" select="$map-width-px"/>
                </xsl:call-template>
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