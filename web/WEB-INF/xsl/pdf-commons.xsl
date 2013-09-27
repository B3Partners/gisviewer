<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <!-- master set -->
    <xsl:template name="layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="a4-liggend" page-height="210mm" page-width="297mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a4-staand" page-height="297mm" page-width="210mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a3-liggend" page-height="297mm" page-width="420mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a3-staand" page-height="420mm" page-width="297mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a2-liggend" page-height="420mm" page-width="594mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a2-staand" page-height="594mm" page-width="420mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a1-liggend" page-height="594mm" page-width="841mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a1-staand" page-height="841mm" page-width="594mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a0-liggend" page-height="841mm" page-width="1189mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="a0-staand" page-height="1189mm" page-width="841mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
        </fo:layout-master-set>
    </xsl:template>

    <xsl:template name="title-block">        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="title-font">
            <xsl:value-of select="titel"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="disclaimer-block">
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">
            Aan deze kaart kunnen geen rechten worden ontleend.
            U bekijkt een demo ontwerp.
        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block>
            <fo:external-graphic src="url('{$logo-src}')" width="{$logo-width}" height="{$logo-height}"/>
        </fo:block>
    </xsl:template>

    <!-- create map -->    
    <xsl:template name="map-block">
      <xsl:param name="block-height"/>
      <xsl:variable name="bbox-corrected">
            <xsl:call-template name="correct-bbox">
                <xsl:with-param name="bbox" select="bbox"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="px-ratio" select="format-number($map-height-px div $map-width-px,'0.##','MyFormat')" />
        <xsl:variable name="map-width-px-corrected" select="kwaliteit"/>
        <xsl:variable name="map-height-px-corrected" select="format-number(kwaliteit * $px-ratio,'0','MyFormat')"/>
        <xsl:variable name="map">
            <xsl:value-of select="imageUrl"/>
            <xsl:text>&amp;width=</xsl:text>
            <xsl:value-of select="$map-width-px-corrected"/>
            <xsl:text>&amp;height=</xsl:text>
            <xsl:value-of select="$map-height-px-corrected"/>
            <xsl:text>&amp;bbox=</xsl:text>
            <xsl:value-of select="$bbox-corrected"/>
        </xsl:variable>

        <fo:block-container margin-top="0.5cm" height="${block-height}" xsl:use-attribute-sets="column-block">
            <fo:block margin-left="0.05cm" margin-right="0.05cm">
                <fo:external-graphic src="{$map}" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform" width="{$map-width-px}" height="{$map-height-px}"/>
            </fo:block>
        </fo:block-container>
    </xsl:template>
	
	<!-- create legend -->
    <xsl:template name="legend-header-block">        
		<fo:block margin-left="0.2cm" margin-top="0.1cm" xsl:use-attribute-sets="header-font">
			Legenda                 
		</fo:block>
    </xsl:template>
    <xsl:template name="legend-block">
		<xsl:param name="block-height"/>
			<xsl:if test="(count(legendUrls) > 0)">
				<fo:block width="100%" height="0.75cm" xsl:use-attribute-sets="color2-column-block">
					<xsl:call-template name="legend-header-block"/>
				</fo:block>
			</xsl:if>
		<fo:block margin-left="0.2cm" margin-top="0.2cm" margin-bottom="0.5cm">       
			<xsl:for-each select="legendUrls">
				<xsl:variable name="legendUrl" select="." />
				
				<fo:block margin-left="0.0cm" margin-top="0.05cm">
					<fo:external-graphic src="{$legendUrl}" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform"/>
					<!-- height="${block-height}"  -->
				</fo:block>
			</xsl:for-each>
		</fo:block>
    </xsl:template>    

	<!-- create info block-->
    <xsl:template name="info-header-block">        
		<fo:block margin-left="0.2cm" margin-top="0.1cm" xsl:use-attribute-sets="header-font">
			Info
		</fo:block>
    </xsl:template>
	<xsl:template name="info-block">
		<fo:block width="100%" height="0.75cm" xsl:use-attribute-sets="color2-column-block">
			<xsl:call-template name="info-header-block"/>
		</fo:block>
		
		<fo:block>
			<fo:external-graphic src="url('b3p_noordpijl.png')" width="84px" height="77px"/>
		</fo:block>

		<fo:block margin-left="0.2cm" margin-top="0.5cm" font-size="9pt">
			schaalbalk
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

		<fo:block margin-left="0.2cm" margin-top="0.5cm" font-size="10pt">
			<xsl:value-of select="datum"/>
		</fo:block>

		<fo:block margin-left="0.2cm" margin-top="0.3cm"  margin-bottom="0.5cm" font-size="8pt" font-style="italic">
			<xsl:value-of select="opmerking"/>
		</fo:block>

    </xsl:template>

</xsl:stylesheet>
