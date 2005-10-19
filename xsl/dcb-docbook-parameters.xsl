<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

  <!-- 

       Customization of docbook-xsl with the provided parameters
       and independent of output format.

       Should be used in both html and pdf output. Since pdf has
       not been tested very much, this might have to be changed.
       
       -->

  <xsl:param name="generate.toc">
    appendix  toc,title
    article/appendix  nop
    article   toc,title
    book      toc,title
    chapter   toc,title
    part      toc,title
    preface   toc,title
    qandadiv  toc
    qandaset  toc
    reference toc,title
    sect1     toc,title
    sect2     toc
    sect3     toc
    sect4     toc
    sect5     toc
    section   toc,title
    set       toc,title
  </xsl:param>



  <xsl:param name="refentry.generate.name" select="0"/>

  <xsl:param name="refentry.generate.title" select="1"/>

  <xsl:param name="refentry.xref.manvolnum" select="0"></xsl:param>



  <xsl:param name="paper.type" select="'A4'"/>
  
  <xsl:param name="generate.section.toc.level" select="1"></xsl:param>
  
  <xsl:param name="toc.section.depth" select="1"></xsl:param>
  
  <xsl:param name="chunk.section.depth" select="1"></xsl:param>
  
  <xsl:param name="chunk.first.sections" select="1"></xsl:param>
  
  <!-- <xsl:param name="chunker.output.encoding" select="'ASCII'"></xsl:param> -->
  
  <xsl:param name="chunker.output.indent" select="'yes'"></xsl:param>
  
  <xsl:param name="use.id.as.filename" select="1"></xsl:param>
  
  <xsl:param name="paper.type" select="'A4'"></xsl:param>
  
  <xsl:param name="html.stylesheet.type">text/css</xsl:param>
  
  <xsl:param name="html.stylesheet" select="'dcb.css'"></xsl:param>

  <xsl:param name="glossary.as.blocks" select="1"/>

  
  
  <!-- ***************  Pagination and General Styles  *********************  -->
  <!-- ***************************************************  -->
  
  <!-- Specify the default text alignment. The default text alignment is used for most body text. -->
  <xsl:param name="alignment">justify</xsl:param>
  
  
  <!--  Specifies the default point size for body text. The body font size is specified in two parameters (body.font.master and body.font.size) so that math can be performed on the font size by XSLT. -->
  <!-- DOESNT WORK?
       <xsl:param name="body.font.master">
         12
       </xsl:param>
       -->
       


  <!--  Selects draft mode. If draft.mode is "yes", the entire document will be treated as a draft. If it is "no", the entire document will be treated as a final copy. If it is "maybe", individual sections will be treated as draft or final independently, depending on how their status attribute is set. -->
       
  <xsl:param name="draft.mode" select="'no'"></xsl:param>
  
  
  <!--  This parameter adjusts the left margin for titles, effectively leaving the titles at the left margin and indenting the body text. The default value is -4pc, which means the body text is indented 4 picas relative to the titles. If you set the value to zero, be sure to still include a unit indicator such as 0pt, or the FO processor will report errors. This parameter is set to 0pt if the passivetex.extensions parameter is nonzero because PassiveTeX cannot handle the math expression with negative values used to calculate the indents. -->
  <!-- DOESNT WORK?
       <xsl:param name="title.margin.left">
         <xsl:choose>
           <xsl:when test="$passivetex.extensions != 0">
             0pt
           </xsl:when>
           <xsl:otherwise>
             0pc
           </xsl:otherwise>
         </xsl:choose>
       </xsl:param>
       -->
      
  <!-- TLDP Params -->
            
  <!-- Number all sections in the style of 'CH.S1.S2 Section Title' where
       CH is the chapter number,  S1 is the section number and S2 is the
       sub-section number.  The lables are not limited to any particular
       depth and can go as far as there are sections. -->
  
  <xsl:param name="section.autolabel" select="1"></xsl:param>
  <xsl:param name="section.label.includes.component.label" select="0"></xsl:param>
  
  
  <!-- Turn off the default 'full justify' and go with 'left justify'
       instead.  This avoids the large gaps that can sometimes appear
       between words in fully-justified documents.  -->
  <!--
       <xsl:param name="alignment">start</xsl:param>
       -->
       
  <!-- Create bookmarks in .PDF files -->
  
  <xsl:param name="fop.extensions" select="1"/>
  
  
  
</xsl:stylesheet>
               
               
