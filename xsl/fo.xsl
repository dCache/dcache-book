<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!--  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/> -->
  <xsl:import href="urn:docbook:xsl:current:fo/docbook.xsl"/>
  
  <xsl:include href="dcb-docbook-parameters.xsl"/>

  <xsl:param name="generate.toc">
    appendix  toc,title
    article/appendix  nop
    article   toc,title
    book      toc,title
    chapter   nop
    part      nop
    preface   toc,title
    qandadiv  toc
    qandaset  toc
    reference nop
    sect1     nop
    sect2     toc
    sect3     toc
    sect4     toc
    sect5     toc
    section   nop
    set       toc,title
  </xsl:param>
  
  <xsl:include href="dcb-docbook-fo-customizations.xsl"/>
  
  <xsl:include href="dcb-extensions.xsl"/>
  
</xsl:stylesheet>
