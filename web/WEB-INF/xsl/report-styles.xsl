<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>
    
    <!-- logo -->  
    <xsl:variable name="logo-src" select="'b3p_logo.png'"/>
    <xsl:variable name="logo-width" select="'185px'"/>
    <xsl:variable name="logo-height" select="'46px'"/>
    
    <xsl:variable name="logo-block-width" select="'7.6cm'"/>
    <xsl:variable name="logo-block-height" select="'2.3cm'"/>
        
    <xsl:variable name="logo-top-a4-liggend" select="'18.3cm'"/>
    <xsl:variable name="logo-left-a4-liggend" select="'22.5cm'"/>  
    
    <!-- widths -->
    <xsl:variable name="user-table-width" select="'100%'"/>
    
    <!-- margins -->
    <xsl:variable name="user-margin-left" select="'0.2cm'"/>
    <xsl:variable name="user-margin-top" select="'0.4cm'"/>
    <xsl:variable name="user-margin-bottom" select="'0.2cm'"/>
    
    <!-- fonts -->  
    <xsl:attribute-set name="default-font">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="title-font">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- colors -->  
    <xsl:attribute-set name="title-bg-color" use-attribute-sets="column-block">
        <xsl:attribute name="background-color">#eeeeee</xsl:attribute>
    </xsl:attribute-set>    
    
    <xsl:attribute-set name="date-info-style">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cell-header" use-attribute-sets="thinBorder">
        <xsl:attribute name="background-color">#fcc500</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:variable name="row-color-1" select="'#ffffff'"/>
    <xsl:variable name="row-color-2" select="'#efefef'"/>
    
    <!-- other --> 
    <xsl:attribute-set name="thinBorder">
        <xsl:attribute name="border">solid 0.4mm black</xsl:attribute>
    </xsl:attribute-set>     
    
    <xsl:attribute-set name="column-block">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">0cm</xsl:attribute>
        <xsl:attribute name="left">0cm</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>   

</xsl:stylesheet>