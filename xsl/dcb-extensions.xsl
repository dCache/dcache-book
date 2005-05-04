<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- Extensions of docbook-xsl for the dCache Book
       Can be used in two ways:
       1. Incluson in customization layer of docbook-xsl for 
          html/pdf/... generation. (e.g. dcb-dcache.org-website.xsl)
       2. Transformation of dCache-Book-extended docbook to
          standard docbook. (e.g. dcb-to-docbook.xsl)                -->
  
  <xsl:template match="dcpoolprompt">
    <prompt>(<replaceable>poolname</replaceable>) admin &gt; </prompt>
  </xsl:template>
  
  <xsl:template match="dcpmprompt">
    <prompt>(PoolManager) admin &gt; </prompt>
  </xsl:template>
  
  <xsl:template match="rootprompt">
    <prompt>[root@machine ~ ] # </prompt>
  </xsl:template>

  

</xsl:stylesheet>
