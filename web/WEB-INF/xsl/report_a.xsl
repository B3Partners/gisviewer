<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <xsl:param name="versionParam" select="'1.0'"/>

    <!-- includes -->
    <xsl:include href="report-styles.xsl"/>

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
                    
                    <xsl:if test="count(bronnen) &gt; 0">
                        <fo:block-container width="28.8cm" height="1.5cm" top="0cm" left="0cm" background-color="#166299" xsl:use-attribute-sets="column-block">
                            <xsl:call-template name="title-block"/>
                        </fo:block-container>
                        
                        <fo:block-container width="28.8cm" height="15.0cm" top="1.5cm" left="0cm" xsl:use-attribute-sets="column-block">
                            
                            <fo:block margin-left="0.2cm" margin-top="0.5cm" margin-bottom="0.5cm" font-size="10pt">
                                Gemaakt op: <xsl:value-of select="/reportinfo/datum"/>                
                            </fo:block>
                            
                            <xsl:for-each select="/reportinfo/bronnen/entry">
                                <xsl:if test="value/tableType = 'FLAT_TABLE'">
                                    <xsl:call-template name="flat-table-block">
                                        <xsl:with-param name="myRecord" select="." />
                                    </xsl:call-template>    
                                </xsl:if>
                                
                                <xsl:if test="value/tableType = 'SIMPLE_TABLE'">
                                    <xsl:call-template name="simple-table-block">
                                        <xsl:with-param name="myRecord" select="." />
                                    </xsl:call-template>    
                                </xsl:if>
                            
                            </xsl:for-each>
                        </fo:block-container>
                        
                        <fo:block-container width="7.6cm" height="2.3cm" top="16.5cm" left="20.5cm" xsl:use-attribute-sets="column-block">
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
            <xsl:value-of select="/reportinfo/titel"/>
        </fo:block>
    </xsl:template>
    
    <!-- tabel zonder border met label:value rijen -->
    <xsl:template name="flat-table-block">
        <xsl:param name="myRecord" />
  
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">
                        
            <xsl:if test="count($myRecord/value/labels) &gt; 0">                                            
                <fo:block width="26.0cm">
                    <fo:table>
                        <fo:table-column column-width="6.0cm"/>
                        <fo:table-column column-width="20.0cm"/>

                        <fo:table-header>
                            <fo:table-cell>
                                <fo:block></fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block></fo:block>
                            </fo:table-cell>
                        </fo:table-header>
                                        
                        <fo:table-body>                                        
                            <xsl:for-each select="$myRecord/value/labels">
                                <xsl:variable name="counter" select="position()" />
                                                                           
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block font-weight="bold">
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            : <xsl:value-of select="$myRecord/value/records/entry/value/item[$counter]"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>                                
                            </xsl:for-each>                                        
                        </fo:table-body>
                                    
                    </fo:table>                            
                </fo:block><!-- end table -->                        
                                                                 
            </xsl:if>

        </fo:block>
    </xsl:template>
    
    <!-- tabel met border, koppen en een regel per record -->
    <xsl:template name="simple-table-block">
        <xsl:param name="myRecord" />
        
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="default-font">
                        
            <xsl:variable name="countLabels" select="count($myRecord/value/labels)" />
            <xsl:variable name="column-w" select="concat(26.0 div $countLabels,'cm')" />
            
            <xsl:if test="$countLabels &gt; 0">
                <fo:block>
                                    
                    <fo:table>                                        
                        <xsl:for-each select="$myRecord/value/labels"> 
                            <fo:table-column column-width="$column-w"/>
                        </xsl:for-each>                                        
                                        
                        <fo:table-header>   
                            <fo:table-row>                                            
                                <xsl:for-each select="$myRecord/value/labels">                                            
                                    <fo:table-cell xsl:use-attribute-sets="thinBorder">
                                        <fo:block font-weight="bold">
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </fo:table-header>
                                        
                        <fo:table-body>                                     
                            <xsl:for-each select="$myRecord/value/records/entry"> 
                                                    
                                <fo:table-row>
                                    <xsl:for-each select="value/item">                                                        
                                        <fo:table-cell xsl:use-attribute-sets="thinBorder">
                                            <fo:block>
                                                <xsl:value-of select="."/>
                                            </fo:block>
                                        </fo:table-cell>                                                        
                                    </xsl:for-each>   
                                </fo:table-row>   
                                                                              
                            </xsl:for-each>                                     
                        </fo:table-body>
                                    
                    </fo:table>                            
                </fo:block>                                                                 
            </xsl:if>

        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block margin-top="0.5cm">
            <fo:external-graphic src="url('b3p_logo.png')" width="231px" height="56px"/>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
