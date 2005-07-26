<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  
  <xsl:param name="chunker.output.encoding" select="'ASCII'"></xsl:param>
  
  <xsl:param name="html.ext" select="'.shtml'"></xsl:param>
  
  <xsl:template name="chunk-element-content">
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="nav.context"/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>
    
    <!-- <xsl:call-template name="user.preroot"/> -->
    
    <!--
    <html>
      <xsl:call-template name="html.head">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
      
      <body> 
        <xsl:call-template name="body.attributes"/> 
        -->    

        <xsl:comment>#include virtual="../manual_body.shtml"</xsl:comment>
        
        <table width="100%" cellpadding="0px" cellspacing="0px">
          <link rel="stylesheet" type="text/css" href="dcb.css"/>
          <tr cellspacing="10px">
            <td width="75%" valign="top" style="padding-right: 20px; padding-bottom: 20px; padding-top: 20px;">
              
              <!--
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr height="27px" width="100%"/>
                <tr>
                  <td width="100%" valign="top">
                    -->
                    
                    <xsl:call-template name="user.header.navigation"/>
                    
                    <xsl:call-template name="header.navigation">
                      <xsl:with-param name="prev" select="$prev"/>
                      <xsl:with-param name="next" select="$next"/>
                      <xsl:with-param name="nav.context" select="$nav.context"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="user.header.content"/>
        
                    <!--
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="25%" valign="top">
                          <xsl:comment>#include virtual="sidebar-index.shtml"</xsl:comment>
                        </td>
                        <td width="75%" valign="top">
                          -->
       
                          <xsl:copy-of select="$content"/>
                          
                    <!--          
                        </td>
                      </tr>
                    </table>
                    -->
        
                    <xsl:call-template name="user.footer.content"/>
                    
                    <xsl:call-template name="footer.navigation">
                      <xsl:with-param name="prev" select="$prev"/>
                      <xsl:with-param name="next" select="$next"/>
                      <xsl:with-param name="nav.context" select="$nav.context"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="user.footer.navigation"/>
        
               <!--
                  </td>
                </tr>
              </table>
              -->
            </td>
            <td width="25%" height="700px" valign="top" style="background: #d5e7f2; padding: 20px; padding-top: 40px">
              <!--
              <div style="position: fixed;">
                -->
                <h2><a href="index.shtml">dCache Book</a></h2>

                <p><a href="dCacheBook.html">Print Version</a> | <a href="dCacheBook.pdf">PDF Version</a></p>
          
                <xsl:comment>#include virtual="sidebar-index.shtml"</xsl:comment>
                <!--   
              </div>
              -->
            </td>
          </tr>
        </table>
        
        <xsl:comment>#include virtual="../manual_end.shtml"</xsl:comment>
     
   <!--
      </body>
    </html>
    -->
    
    
    
  </xsl:template>
  
</xsl:stylesheet>

