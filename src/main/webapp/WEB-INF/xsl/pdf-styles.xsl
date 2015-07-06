<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>
	
    <!-- styles -->
    <xsl:attribute-set name="title-font">
        <xsl:attribute name="font-size">15pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header-font">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">#ffffff</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="default-font">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="disclaimer-font">
        <xsl:attribute name="font-size">6pt</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="simple-border">
        <xsl:attribute name="border-top-color">#000000</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">thin</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#000000</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">thin</xsl:attribute>
        <xsl:attribute name="border-left-color">#000000</xsl:attribute>
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-width">thin</xsl:attribute>
        <xsl:attribute name="border-right-color">#000000</xsl:attribute>
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="column-block">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">0cm</xsl:attribute>
        <xsl:attribute name="left">0cm</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="color1-column-block" use-attribute-sets="column-block">
        <xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="color2-column-block" use-attribute-sets="column-block">
        <xsl:attribute name="background-color">#008DBC</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="column-block-border" use-attribute-sets="simple-border">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">0cm</xsl:attribute>
        <xsl:attribute name="left">0cm</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>

	
    <!-- formatter -->
    <xsl:decimal-format name="MyFormat" decimal-separator="." grouping-separator=","
                        infinity="INFINITY" minus-sign="-" NaN="Not a Number" percent="%" per-mille="m"
                        zero-digit="0" digit="#" pattern-separator=";" />
                    
    <!-- EDIT: logo source, size and positions-->    
    <xsl:variable name="logo-src" select="'logo_lelystad_small.gif'"/>
    <xsl:variable name="logo-width" select="'123px'"/>
    <xsl:variable name="logo-height" select="'50px'"/>    
    <xsl:variable name="logo-block-width" select="'7.6cm'"/>
    <xsl:variable name="logo-block-height" select="'2.3cm'"/>
    
    <xsl:variable name="logo-top-a4-liggend" select="'18.2cm'"/>
    <xsl:variable name="logo-left-a4-liggend" select="'24.0cm'"/>    
    <xsl:variable name="logo-top-a4-staand" select="'26.0cm'"/>
    <xsl:variable name="logo-left-a4-staand" select="'16.0cm'"/>
    
    <xsl:variable name="logo-top-a3-liggend" select="'26.8cm'"/>
    <xsl:variable name="logo-left-a3-liggend" select="'36.5cm'"/>  
    <xsl:variable name="logo-top-a3-staand" select="'39.1cm'"/>
    <xsl:variable name="logo-left-a3-staand" select="'23.8cm'"/> 
    
    <xsl:variable name="logo-top-a2-liggend" select="'38.9cm'"/>
    <xsl:variable name="logo-left-a2-liggend" select="'52.0cm'"/>    
    <xsl:variable name="logo-top-a2-staand" select="'56.3cm'"/>
    <xsl:variable name="logo-left-a2-staand" select="'34.6cm'"/>  
    
    <xsl:variable name="logo-top-a1-liggend" select="'56.3cm'"/>
    <xsl:variable name="logo-left-a1-liggend" select="'76.7cm'"/>  
    <xsl:variable name="logo-top-a1-staand" select="'81.0cm'"/>
    <xsl:variable name="logo-left-a1-staand" select="'52.0cm'"/>  
    
    <xsl:variable name="logo-top-a0-liggend" select="'81.0cm'"/>
    <xsl:variable name="logo-left-a0-liggend" select="'111.5cm'"/>  
    <xsl:variable name="logo-top-a0-staand" select="'115.8cm'"/>
    <xsl:variable name="logo-left-a0-staand" select="'77.3cm'"/>  

</xsl:stylesheet>
