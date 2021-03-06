<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>

    <!-- blocks -->
    <xsl:template name="title-block">                
        <fo:block margin-left="0.2cm" margin-top="0.5cm" xsl:use-attribute-sets="title-font">
            <xsl:value-of select="/reportinfo/titel"/>
        </fo:block>
    </xsl:template>
    
    <!-- tabel zonder border met label:value rijen -->
    <xsl:template name="flat-table-block">
        <xsl:param name="myRecord" />
  
        <fo:block margin-left="{$user-margin-left}" margin-top="{$user-margin-top}" xsl:use-attribute-sets="default-font">
                        
            <xsl:if test="count($myRecord/labels) &gt; 0">                                            
                <fo:block width="27.0">
                    
                    <!-- labels met uitsnede -->
                    <fo:table>                                                                
                        <fo:table-column column-width="14.0cm"/>

                        <fo:table-header>
                            <fo:table-cell>
                                <fo:block></fo:block>
                            </fo:table-cell>
                        </fo:table-header>

                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell>                                                    
                                            
                                    <fo:block width="10.0cm">
                                        <fo:table>

                                            <fo:table-column column-width="6.0cm" />
                                            <fo:table-column column-width="8.0cm" />

                                            <fo:table-header>
                                                <fo:table-cell>
                                                    <fo:block></fo:block>
                                                </fo:table-cell>
                                            </fo:table-header>
                                                    
                                            <!-- labels -->
                                            <fo:table-body>                                        
                                                <xsl:for-each select="$myRecord/labels">                                
                                                    <xsl:variable name="counter" select="position()" />
                                                    
                                                    <fo:table-row>
                                                        <fo:table-cell>
                                                            <fo:block font-weight="bold">
                                                                <xsl:value-of select="."/>
                                                            </fo:block>
                                                        </fo:table-cell>
                                                        <fo:table-cell>
                                                            <fo:block>
                                                                : <xsl:value-of select="$myRecord/records/values[$counter]"/>
                                                            </fo:block>
                                                        </fo:table-cell>
                                                    </fo:table-row>                                
                                                </xsl:for-each>                                        
                                            </fo:table-body>
                                    
                                        </fo:table>                            
                                    </fo:block><!-- end labels -->
                            
                                </fo:table-cell>
                            
                            </fo:table-row>                                      
                        </fo:table-body>
                                    
                    </fo:table>      
                </fo:block><!-- end table -->                        
                                                                 
            </xsl:if>

        </fo:block>
    </xsl:template>
    
    <!-- tabel met border, koppen en een regel per record -->
    <xsl:template name="simple-table-block">
        <xsl:param name="myRecord" />
        <xsl:param name="volgNummer" />
        
        <fo:block margin-left="{$user-margin-left}" margin-top="{$user-margin-top}" xsl:use-attribute-sets="default-font">
            <!--<xsl:value-of select="$myRecord/titel"/>-->
        </fo:block>
        
        <fo:block margin-left="{$user-margin-left}" margin-top="{$user-margin-top}" xsl:use-attribute-sets="default-font">
                        
            <xsl:variable name="countLabels" select="count($myRecord/labels)" />
            
            <xsl:if test="$countLabels &gt; 0">
                <fo:block>                                    
                    <fo:table table-layout="fixed" width="{$user-table-width}">     
                        
                        <!-- extra kolom ervoor met titel en volgnummer -->
                        <fo:table-column column-width="proportional-column-width(1)"/>
                                                  
                        <xsl:for-each select="$myRecord/labels">
                            <fo:table-column column-width="proportional-column-width(1)"/>
                        </xsl:for-each>                                        
                                        
                        <fo:table-header>   
                            <fo:table-row keep-with-previous="always">  
                                
                                <!-- extra header voor volgnummer met titel -->
                                <fo:table-cell xsl:use-attribute-sets="cell-header">
                                    <fo:block>
                                        <xsl:value-of select="$myRecord/titel"/>
                                    </fo:block>
                                </fo:table-cell>
                                                                              
                                <xsl:for-each select="$myRecord/labels">     
                                    <fo:table-cell xsl:use-attribute-sets="cell-header">
                                        <fo:block>
                                            <xsl:value-of select="."/>
                                        </fo:block>
                                    </fo:table-cell>
                                </xsl:for-each>
                            </fo:table-row>
                        </fo:table-header>
                                        
                        <fo:table-body>                                     
                            <xsl:for-each select="$myRecord/records">  
                                
                                <!-- Using choose to alternate row colors -->
                                <xsl:choose>                                    
                                    <xsl:when test="position() mod 2 = 0">
                                        <fo:table-row keep-with-previous="always">
                                            
                                            <!-- extra cell met volgnummer -->
                                            <fo:table-cell background-color="{$row-color-1}" xsl:use-attribute-sets="thinBorder">
                                                <fo:block>
                                                    <xsl:value-of select="concat($volgNummer, '.', position())"/>
                                                </fo:block>
                                            </fo:table-cell>                                            
                                            
                                            <xsl:for-each select="values">                                     
                                                <fo:table-cell background-color="{$row-color-1}" xsl:use-attribute-sets="thinBorder">
                                                    <fo:block>
                                                        <xsl:value-of select="."/>
                                                    </fo:block>
                                                </fo:table-cell>                                                        
                                            </xsl:for-each>   
                                        </fo:table-row> 
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <fo:table-row keep-with-previous="always">
                                            
                                            <!-- extra cell met volgnummer -->
                                            <fo:table-cell background-color="{$row-color-2}" xsl:use-attribute-sets="thinBorder">
                                                <fo:block>
                                                    <xsl:value-of select="concat($volgNummer, '.', position())"/>
                                                </fo:block>
                                            </fo:table-cell>
                                            
                                            <xsl:for-each select="values">                                     
                                                <fo:table-cell background-color="{$row-color-2}" xsl:use-attribute-sets="thinBorder">
                                                    <fo:block>
                                                        <xsl:value-of select="."/>
                                                    </fo:block>
                                                </fo:table-cell>                                                        
                                            </xsl:for-each>   
                                        </fo:table-row>                                            
                                    </xsl:otherwise>                                    
                                </xsl:choose>
                                                                              
                            </xsl:for-each>                                     
                        </fo:table-body>
                                    
                    </fo:table> 
                     
                </fo:block>                                                                                                                      
            </xsl:if>
            
            <!-- voor subbronnen nog een keer aanroepen -->
            <xsl:for-each select="records/bronnen">      
                <xsl:variable name="nummer" select="position()"/>
                          
                <xsl:call-template name="simple-table-block">
                    <xsl:with-param name="myRecord" select="." />
                    <xsl:with-param name="volgNummer" select="concat($volgNummer, '.', $nummer)"/>
                </xsl:call-template>  
            </xsl:for-each>

        </fo:block>
    </xsl:template>

    <xsl:template name="logo-block">
        <fo:block margin-top="{$user-margin-top}">
            <fo:external-graphic src="url('{$logo-src}')" width="{$logo-width}" height="{$logo-height}"/>
        </fo:block>
    </xsl:template>    
</xsl:stylesheet>