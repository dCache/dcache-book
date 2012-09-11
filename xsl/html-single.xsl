<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE stylesheet [
   <!ENTITY % build-entities SYSTEM "../build-entities.xml">
   %build-entities;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl"/>

  <xsl:include href="common.xsl"/>
  <xsl:include href="html-common.xsl"/>

  <xsl:template name="user.header.content">
    <xsl:variable name="location" select="concat('/template/l3-docs-book-1.9.12-', $layout, '-header.shtml')"/>

    <xsl:comment>#include virtual="<xsl:value-of select="$location"/>"</xsl:comment>
  </xsl:template>

  <xsl:template name="user.footer.content">
    <xsl:comment>#include virtual="&location-frag-footer;"</xsl:comment>
  </xsl:template>


  <!-- Concatenate class value and draft-status -->
  <xsl:template match="*" mode="class.value">
    <xsl:param name="class" select="local-name(.)"/>
    <!-- permit customization of class value only -->
    <!-- Use element name by default -->
    <xsl:value-of select="$class"/>
    <xsl:if test="((($class = 'chapter') or ($class = 'section')) and (@status = 'draft')) ">
      <xsl:value-of select="concat(' ','draft')"/>
    </xsl:if>
  </xsl:template>


  <!--
      The following supports links to top-of-page, from:
      http://www.sagehill.net/docbookxsl/ReturnToTop.html
  -->
  <xsl:template name="section.titlepage.before.recto">
    <xsl:variable name="top-anchor">
      <xsl:call-template name="object.id">
	<xsl:with-param name="object" select="/*[1]"/>
      </xsl:call-template>
    </xsl:variable>

    <p class="returntotop">
      <xsl:text>[</xsl:text>
      <a href="#{$top-anchor}">
	<xsl:text>return to top</xsl:text>
      </a>
      <xsl:text>]</xsl:text>
    </p>
  </xsl:template>

</xsl:stylesheet>
