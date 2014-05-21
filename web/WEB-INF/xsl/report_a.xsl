<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <!-- includes -->    
    <xsl:include href="report-styles.xsl"/>
    <xsl:include href="report-commons.xsl"/>    

    <!-- master set -->
    <xsl:template name="layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="a4-liggend" page-height="210mm" page-width="297mm" margin-top="0.4cm" margin-bottom="0.4cm" margin-left="0.4cm" margin-right="0.4cm">
                <fo:region-body region-name="body"/>
            </fo:simple-page-master>
        </fo:layout-master-set>
    </xsl:template>

    <!-- root -->
    <xsl:template match="reportinfo">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:call-template name="layout-master-set"/>
            
            <fo:page-sequence master-reference="a4-liggend">
                <fo:flow flow-name="body">
                    
                    <xsl:if test="count(bron) &gt; 0">
                        <fo:block-container width="28.8cm" height="1.5cm" top="0cm" left="0cm" xsl:use-attribute-sets="title-bg-color">
                            <xsl:call-template name="title-block"/>
                        </fo:block-container>
                        
                        <fo:block-container width="28.8cm" height="15.0cm" top="1.5cm" left="0cm" xsl:use-attribute-sets="column-block">
                            
                            <fo:block margin-left="0.2cm" margin-top="0.5cm" margin-bottom="0.5cm" xsl:use-attribute-sets="date-info-style">
                                Gemaakt op: <xsl:value-of select="/reportinfo/datum"/>                
                            </fo:block>
                            
                            <xsl:if test="/reportinfo/bron/layout = 'FLAT_TABLE'">
                                <xsl:call-template name="flat-table-block">
                                    <xsl:with-param name="myRecord" select="/reportinfo/bron" />
                                </xsl:call-template>    
                            </xsl:if>
                            
                            <xsl:for-each select="/reportinfo/bron/records/bronnen">
                                <xsl:call-template name="simple-table-block">
                                    <xsl:with-param name="myRecord" select="." />
                                </xsl:call-template>  
                            </xsl:for-each>
                            
                        </fo:block-container>
                        
                        <fo:block-container 
                            width="{$logo-block-width}" 
                            height="{$logo-block-height}" 
                            top="{$logo-top-a4-liggend}" 
                            left="{$logo-left-a4-liggend}" 
                            xsl:use-attribute-sets="column-block">
                        
                            <xsl:call-template name="logo-block"/>
                        </fo:block-container>  
                                                                    
                    </xsl:if>   
                                     
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>
