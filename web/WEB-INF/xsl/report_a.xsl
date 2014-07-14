<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <!-- includes -->    
    <xsl:include href="report-styles.xsl"/>
    <xsl:include href="report-commons.xsl"/>    

    <!-- master set -->
    <xsl:template name="layout-master-set">
        <fo:layout-master-set>
            <fo:simple-page-master master-name="a4-liggend" page-width="29.7cm" page-height="21.0cm" margin-top="0.1cm" margin-bottom="0.1cm" margin-left="0.1cm" margin-right="0.1cm">              
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
                    
                    <fo:block-container width="29.5cm" height="1.5cm" top="0cm" left="0cm" xsl:use-attribute-sets="title-bg-color">
                        <xsl:call-template name="title-block"/>
                    </fo:block-container>      
                            
                    <xsl:if test="count(bron) &gt; 0">
                        <fo:block-container width="25.0cm" height="1.5cm" top="1.5cm" left="0cm" xsl:use-attribute-sets="column-block">                          
                            <fo:block margin-left="{$user-margin-left}" margin-top="{$user-margin-top}" margin-bottom="{$user-margin-bottom}" xsl:use-attribute-sets="date-info-style">
                                Gemaakt op: <xsl:value-of select="/reportinfo/datum"/>                
                            </fo:block>
                        </fo:block-container>
                        
                        <fo:block-container margin-top="1.7cm" margin-left="9.85cm"> 
                            <xsl:variable name="url" select="/reportinfo/image_url"/>                        
                            <fo:block>
                                <fo:external-graphic border-style="solid" border-width="medium" src="url('data:image/jpeg;base64,{$url}')" content-height="scale-to-fit" content-width="scale-to-fit" scaling="uniform" width="{$uitsnede-w}" height="{$uitsnede-h}"/>
                            </fo:block>   
                        </fo:block-container>
                        
                        <xsl:if test="/reportinfo/bron/layout = 'FLAT_TABLE'">
                            <fo:block-container top="2.2cm" left="0cm" xsl:use-attribute-sets="column-block">              
                                <xsl:call-template name="flat-table-block">
                                    <xsl:with-param name="myRecord" select="/reportinfo/bron" />
                                </xsl:call-template>                                
                            </fo:block-container>
                        </xsl:if>
                          
                        <xsl:if test="count(/reportinfo/bron/records/bronnen) &gt; 0">
                            <fo:block-container margin-top="{$child-top-start}" left="0cm">      
                                <xsl:for-each select="/reportinfo/bron/records/bronnen">                                
                                    <xsl:variable name="nummer" select="position()"/>
                                
                                    <xsl:call-template name="simple-table-block">
                                        <xsl:with-param name="myRecord" select="." />
                                        <xsl:with-param name="volgNummer" select="$nummer"/>
                                    </xsl:call-template>                                                        
                                </xsl:for-each>
                            </fo:block-container>
                        </xsl:if>                        
                                                                                         
                    </xsl:if>  
                    
                    <fo:block-container 
                        width="{$logo-block-width}" 
                        height="{$logo-block-height}" 
                        top="{$logo-top-a4-liggend}" 
                        left="{$logo-left-a4-liggend}" 
                        xsl:use-attribute-sets="column-block">
                        
                        <xsl:call-template name="logo-block"/>
                    </fo:block-container>
                                                                          
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>    
   
</xsl:stylesheet>