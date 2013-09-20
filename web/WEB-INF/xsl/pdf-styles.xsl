<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0" omit-xml-declaration="no" indent="yes"/>
	
	<!-- styles -->
	<xsl:attribute-set name="title-font">
		<xsl:attribute name="font-size">15pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="header-font">
		<xsl:attribute name="font-size">14pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#000000</xsl:attribute>
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
		<xsl:attribute name="background-color">#166299</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color2-column-block" use-attribute-sets="column-block">
		<xsl:attribute name="background-color">#FFD203</xsl:attribute>
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

</xsl:stylesheet>