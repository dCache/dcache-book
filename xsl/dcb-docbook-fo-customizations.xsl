<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

  <xsl:param name="refentry.pagebreak" select="0"/>

  <xsl:param name="body.start.indent" select="'0pc'"/>

  <xsl:param name="body.start.indent" select="'0pc'"/>

  <xsl:param name="page.margin.inner" select="'2.5cm'"/>

  <xsl:param name="page.margin.outer" select="'2.5cm'"/>

  <xsl:param name="body.font.master" select="12"/>

  <xsl:param name="shade.verbatim" select="1"/>

<!--

       Customizations of docbook-xsl fo except parameters.



  <xsl:template match="inlineequation">
    <span class="inlineequation">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template name="tr.attributes">
    <xsl:param name="row" select="."/>
    <xsl:param name="rownum" select="0"/>
-->

<!--
    <xsl:if test="$rownum mod 2 = 0">
      <xsl:attribute name="class">oddrow</xsl:attribute>
    </xsl:if>
-->

<!-- 
    <xsl:if test="@class">
      <xsl:attribute name="class">
        <xsl:value-of select="@class"/>
      </xsl:attribute>
    </xsl:if>
  
  </xsl:template>

  <xsl:template match="replaceable" priority="1">
   <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
   </xsl:param>
   <i class="{local-name(.)}"><tt>&lt;<xsl:copy-of select="$content"/>&gt;</tt></i>
   </xsl:template>

-->


</xsl:stylesheet>

