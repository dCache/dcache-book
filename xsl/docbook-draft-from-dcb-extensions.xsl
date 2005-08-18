<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

  <!--
       
       Toplevel XSLT for transforming dCache Book extended docbook
       to standard docbook 
       
       Not tested very thoroughly.
       
       -->
  
  <xsl:output method="xml"/>

  <xsl:include href="dcb-extensions.xsl"/>

  <xsl:template match="unfinished">
    <section status="unfinished">
      <title>Unfinished Part</title>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>


  
</xsl:stylesheet>
