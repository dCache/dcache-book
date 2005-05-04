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

</xsl:stylesheet>

