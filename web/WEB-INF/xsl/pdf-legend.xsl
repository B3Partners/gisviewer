<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>
    
    <!-- Legend items on new page in three columns -->
    <xsl:template name="legend-three-columns">   
        <xsl:if test="columnOneItems != '' and count(columnOneItems) &gt; 0 or
                        columnTwoItems != '' and count(columnTwoItems) &gt; 0 or
                        columnThreeItems != '' and count(columnThreeItems) &gt; 0">
                        
            <fo:block break-before="page"></fo:block>
                        
            <xsl:variable name="legend-column2-left" select="concat($legend-column-w * 1,'cm')" />
            <xsl:variable name="legend-column3-left" select="concat($legend-column-w * 2,'cm')" />
                        
            <xsl:if test="columnOneItems != '' and count(columnOneItems) &gt; 0">
                <fo:block-container left="0.0cm" xsl:use-attribute-sets="column-block">
                    <xsl:call-template name="legend-block-1" />         
                </fo:block-container>                                           
            </xsl:if>  
                    
            <xsl:if test="columnTwoItems != '' and count(columnTwoItems) &gt; 0">
                <fo:block-container left="{$legend-column2-left}" xsl:use-attribute-sets="column-block">
                    <xsl:call-template name="legend-block-2" />         
                </fo:block-container>                        
            </xsl:if>  
                    
            <xsl:if test="columnThreeItems != '' and count(columnThreeItems) &gt; 0">
                <fo:block-container left="{$legend-column3-left}" xsl:use-attribute-sets="column-block">
                    <xsl:call-template name="legend-block-3" />         
                </fo:block-container>                 
            </xsl:if>          
        </xsl:if>  
       
    </xsl:template>    
    
    <xsl:template name="legend-block-one-column">
        <!-- Legend items each on new pages (no columns) -->
        <xsl:if test="legendItems != '' and count(legendItems) &gt; 0">
            <fo:block break-before="page">
                <xsl:call-template name="legend-block"/>
            </fo:block>
        </xsl:if>        
    </xsl:template>
    
    <!-- Helper blocks -->
    <xsl:template name="legend-header-block">        
        <fo:block margin-left="0.2cm" margin-top="0.1cm" xsl:use-attribute-sets="header-font">
            Legenda                 
        </fo:block>
    </xsl:template>
    
    <xsl:template name="legend-block-1">
        <!-- Count items and calc image height per column for scaling -->      
        <xsl:variable name="itemCount" select="count(columnOneItems/entry)" />
        <xsl:variable name="totalHeight" select="$pageHeightCm - $bottom-marge" />        
        <xsl:variable name="image-height" select="concat($totalHeight div $itemCount, 'cm')" />             
        <xsl:variable name="doScale" select="scaleColumnOne" />
        <xsl:variable name="doTitle" select="titleColumnOne" />
        
        <xsl:for-each select="columnOneItems/entry">                
            <xsl:variable name="columnOneItemsUrl" select="value" />
            
            <xsl:choose>
                <xsl:when test="not($doTitle)"></xsl:when>
                <xsl:otherwise>
                    <fo:block margin-left="0cm" margin-top="0cm">  
                        Legenda van 
                        <xsl:value-of select="key"/> 
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
            
            <fo:block>                
                <xsl:choose>
                    <xsl:when test="not($doScale)">
                        <fo:external-graphic src="{$columnOneItemsUrl}" height="100%" width="100%" scaling="uniform"/>          
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:external-graphic src="{$columnOneItemsUrl}" content-height="scale-to-fit" content-width="100%" height="{$image-height}" scaling="uniform"/>          
                    </xsl:otherwise>
                </xsl:choose>                
            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="legend-block-2">
        <!-- Count items and calc image height per column for scaling -->      
        <xsl:variable name="itemCount" select="count(columnTwoItems/entry)" />
        <xsl:variable name="totalHeight" select="$pageHeightCm - $bottom-marge" />        
        <xsl:variable name="image-height" select="concat($totalHeight div $itemCount, 'cm')" />
        <xsl:variable name="doScale" select="scaleColumnTwo" />
        <xsl:variable name="doTitle" select="titleColumnTwo" />
        
        <xsl:for-each select="columnTwoItems/entry">                
            <xsl:variable name="columnTwoItemsUrl" select="value" />
            
            <xsl:choose>
                <xsl:when test="not($doTitle)"></xsl:when>
                <xsl:otherwise>
                    <fo:block margin-left="0cm" margin-top="0cm">  
                        Legenda van 
                        <xsl:value-of select="key"/> 
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
            
            <fo:block>
                <xsl:choose>
                    <xsl:when test="not($doScale)">
                        <fo:external-graphic src="{$columnTwoItemsUrl}" height="100%" width="100%" scaling="uniform"/>          
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:external-graphic src="{$columnTwoItemsUrl}" content-height="scale-to-fit" content-width="100%" height="{$image-height}" scaling="uniform"/>          
                    </xsl:otherwise>
                </xsl:choose> 
            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="legend-block-3">
        <!-- Count items and calc image height per column for scaling -->      
        <xsl:variable name="itemCount" select="count(columnThreeItems/entry)" />
        <xsl:variable name="totalHeight" select="$pageHeightCm - $bottom-marge" />        
        <xsl:variable name="image-height" select="concat($totalHeight div $itemCount, 'cm')" />
        <xsl:variable name="doScale" select="scaleColumnThree" />
        <xsl:variable name="doTitle" select="titleColumnThree" />
        
        <xsl:for-each select="columnThreeItems/entry">                
            <xsl:variable name="columnThreeItemsUrl" select="value" />
            
            <xsl:choose>
                <xsl:when test="not($doTitle)"></xsl:when>
                <xsl:otherwise>
                    <fo:block margin-left="0cm" margin-top="0cm">  
                        Legenda van 
                        <xsl:value-of select="key"/> 
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
            
            <fo:block>          
                <xsl:choose>
                    <xsl:when test="not($doScale)">
                        <fo:external-graphic src="{$columnThreeItemsUrl}" height="100%" width="100%" scaling="uniform"/>          
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:external-graphic src="{$columnThreeItemsUrl}" content-height="scale-to-fit" content-width="100%" height="{$image-height}" scaling="uniform"/>          
                    </xsl:otherwise>
                </xsl:choose> 
            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="legend-block">
        <!-- Layername and legend image -->
        <fo:block margin-left="0.2cm" margin-top="0.1cm">
            <xsl:for-each select="legendItems/entry">                
                <xsl:variable name="legendUrl" select="value" /> 
                
                <fo:block margin-left="0cm" margin-top="0cm">  
                    Legenda van 
                    <xsl:value-of select="key"/> 
                </fo:block>
                
                <fo:block margin-left="0cm" margin-top="0.05cm" keep-with-previous.within-page="always">
                    <fo:external-graphic src="{$legendUrl}" height="19.0cm" width="100%" content-height="scale-to-fit" content-width="100%" scaling="uniform"/>          
                </fo:block>
            </xsl:for-each>            
        </fo:block>  
    </xsl:template>

</xsl:stylesheet>