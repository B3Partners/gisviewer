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
                        <fo:block-container width="20.45cm" height="1.5cm" top="0cm" left="0cm" background-color="#166299" xsl:use-attribute-sets="column-block">
                            <xsl:call-template name="title-block"/>
                        </fo:block-container>

                        <fo:block-container width="20.45cm" height="24.0cm" top="1.5cm" left="0cm" xsl:use-attribute-sets="column-block">
                            <xsl:call-template name="info-block"/>
                        </fo:block-container>

                        <fo:block-container width="7.6cm" height="2.3cm" top="26.5cm" left="12.0cm" xsl:use-attribute-sets="column-block">
                            <xsl:call-template name="logo-block"/>
                        </fo:block-container>                        
                    </xsl:if>                    
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
    
    <!-- blocks -->
    <xsl:template name="title-block">        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="title-font">
            <xsl:value-of select="/pdfinfo/titel"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="info-block">
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">

            <fo:block margin-left="0.2cm" margin-top="0cm" margin-bottom="0.2cm" font-size="10pt">
                Gemaakt op: <xsl:value-of select="/pdfinfo/datum"/>
            </fo:block>
            
            <!-- Loop door objectdata records -->
            <xsl:if test="count(/pdfinfo/records/entry) &gt; 0">
                <xsl:for-each select="/pdfinfo/records/entry">
                        
                    <!-- Toon objectdata en uitsnede in tabel -->
                    <xsl:if test="count(value/items/entry) &gt; 0">
                        
                        <fo:table margin-bottom="0.7cm">
                                                                
                            <fo:table-column column-width="12.0cm"/>
                            <fo:table-column column-width="8.0cm"/>

                            <fo:table-header>
                                <fo:table-cell>
                                    <fo:block></fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block></fo:block>
                                </fo:table-cell>
                            </fo:table-header>

                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell>                                                    
                                            
                                        <fo:block width="11.0cm">
                                            <fo:table>

                                                <fo:table-column column-width="5.0cm"/>
                                                <fo:table-column column-width="6.0cm"/>

                                                <fo:table-header>
                                                    <fo:table-cell>
                                                        <fo:block></fo:block>
                                                    </fo:table-cell>
                                                    <fo:table-cell>
                                                        <fo:block></fo:block>
                                                    </fo:table-cell>
                                                </fo:table-header>
                                                    
                                                <!-- table with objectdata fields -->
                                                <fo:table-body>                                        
                                                    <xsl:for-each select="value/items/entry">                                
                                                        <fo:table-row>
                                                            <fo:table-cell>
                                                                <fo:block font-weight="bold">
                                                                    <xsl:value-of select="key"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                            <fo:table-cell>
                                                                <fo:block>
                                                                    : <xsl:value-of select="value"/>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>                                
                                                    </xsl:for-each>                                        
                                                </fo:table-body>
                                    
                                            </fo:table>                            
                                        </fo:block><!-- end table objectdata fields -->
                            
                                    </fo:table-cell>
                            
                                    <!-- Tonen uitsnede -->
                                    <fo:table-cell>                                            
                                        <xsl:variable name="url" select="value/imageUrl"/>                        
                                        <fo:block width="7.0cm">
                                            <fo:external-graphic border-style="solid" border-width="medium" src="url('data:image/jpeg;base64,{$url}')" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform" width="150" height="100"/>
                                        </fo:block>                            
                                    </fo:table-cell>
                            
                                </fo:table-row>                                             
                            </fo:table-body>
                                    
                        </fo:table> <!-- end table -->
                                                                 
                    </xsl:if>
                </xsl:for-each> 
            </xsl:if>            

        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block margin-top="0.5cm">
            <fo:external-graphic src="url('b3p_logo.png')" width="231px" height="56px"/>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>