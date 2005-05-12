<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

  <!--

       Customizations of docbook-xsl html-chunk except parameters and
       customizations specific to www.dcache.org.

       Mainly stuff in connection with 'dcb.css'.

       -->

  <xsl:template match="inlineequation">
    <span class="inlineequation">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template name="tr.attributes">
    <xsl:param name="row" select="."/>
    <xsl:param name="rownum" select="0"/>
    
    <!--
    <xsl:if test="$rownum mod 2 = 0">
      <xsl:attribute name="class">oddrow</xsl:attribute>
    </xsl:if>
    -->
    
    <xsl:if test="@class">
      <xsl:attribute name="class">
        <xsl:value-of select="@class"/>
      </xsl:attribute>
    </xsl:if>
  
  </xsl:template>



</xsl:stylesheet>

