<?xml version="1.0" encoding="utf-8"?>

<!--

   XSL-FO specific stylesheet.

   This is intended to be used for generating PDF files (although
   potentially, it could be useful elsewhere)

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl"/>
 
  <!-- Include docbook that is common to all output -->
  <xsl:include href="common.xsl"/>

  <!-- Include our custom title page -->
  <xsl:include href="fo-titlepage.xsl"/>

  <xsl:param name="monospace.font.family"
	     select="'monospace,ZapfDingbats'"/>

  <xsl:param name="toc.section.depth" select="1" />
  <xsl:param name="glossary.as.blocks" select="1" />


  <!-- change default text from 'Draft' to 'Outdated' -->
  <xsl:template name="draft.text">
    <xsl:choose>
      <xsl:when test="$draft.mode = 'yes'">
      Outdated
      </xsl:when>
      <xsl:when test="$draft.mode = 'no'">
	<!-- nop -->
      </xsl:when>
      <xsl:when test="ancestor-or-self::*[@status][1]/@status = 'draft'">
      Outdated
      </xsl:when>
      <xsl:otherwise>
	<!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- format lineoutput better -->
  <xsl:attribute-set name="monospace.verbatim.properties"
                     use-attribute-sets="verbatim.properties">

    <xsl:attribute name="text-align">start</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>

    <xsl:attribute name="font-family">
      <xsl:value-of select="$monospace.font.family"/>
    </xsl:attribute>

    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 0.7"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>

    <xsl:attribute name="border-color">#8fbc8f</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">thin</xsl:attribute>
    <xsl:attribute name="padding">0pt</xsl:attribute>
    <xsl:attribute name="background-color">
      <xsl:choose>
	<xsl:when test="self::programlisting">#FFFFF8</xsl:when>
	<xsl:otherwise>#FDFFFD</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>


  <xsl:param name="refentry.pagebreak" select="0"/>
  <xsl:param name="body.start.indent" select="'0pc'"/>
  <xsl:param name="body.start.indent" select="'0pc'"/>
  <xsl:param name="page.margin.inner" select="'2.5cm'"/>
  <xsl:param name="page.margin.outer" select="'2.5cm'"/>
  <xsl:param name="body.font.master" select="11"/>
  <xsl:param name="shade.verbatim" select="1"/>
  <xsl:param name="variablelist.as.blocks" select="1"/>

  <xsl:param name="fop1.extensions" select="1"/>

  <xsl:param name="generate.toc">
    appendix  toc,title
    article/appendix  nop
    article   toc,title
    book      toc,title
    chapter   nop
    part      toc
    preface   toc,title
    qandadiv  toc
    qandaset  toc
    reference nop
    set       toc,title
  </xsl:param>


  <!--  Use the body text font, but in italics  -->
  <xsl:template match="lineannotation">
    <fo:inline font-family="{$body.font.family}"
               font-style="italic">
      <xsl:call-template name="inline.charseq"/>
    </fo:inline>
  </xsl:template>

  <!-- Add 'Example' to informalexample -->
  <xsl:template name="informal.object">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <!-- Some don't have a pgwide attribute, so may use a PI -->
  <xsl:variable name="pgwide.pi">
    <xsl:call-template name="pi.dbfo_pgwide"/>
  </xsl:variable>

  <xsl:variable name="pgwide">
    <xsl:choose>
      <xsl:when test="@pgwide">
        <xsl:value-of select="@pgwide"/>
      </xsl:when>
      <xsl:when test="$pgwide.pi">
        <xsl:value-of select="$pgwide.pi"/>
      </xsl:when>
      <!-- child element may set pgwide -->
      <xsl:when test="*[@pgwide]">
        <xsl:value-of select="*[@pgwide][1]/@pgwide"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- informaltables have their own templates and
         are not handled by formal.object -->
    <xsl:when test="local-name(.) = 'equation'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="equation.without.title"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="equation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:call-template name="equation.without.title"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name(.) = 'procedure'">
      <fo:block id="{$id}"
                xsl:use-attribute-sets="procedure.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:when>
    <xsl:when test="local-name(.) = 'informalfigure'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalfigure.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="local-name(.) = 'informalexample'">

      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}" border-style="solid" border-width="thin" border-color="grey"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalexample.properties">

            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
	    <fo:block margin-left="2%" margin-right="2%" margin-top="1%" margin-bottom="1%">
            <fo:inline font-weight="bold">Example:</fo:inline>
            <xsl:apply-templates/>
            </fo:block>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
	  <fo:block id="{$id}" border-style="solid" border-width="thin" border-color="grey"
                    xsl:use-attribute-sets="informalexample.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <fo:block margin-left="2%" margin-right="2%" margin-top="1%" margin-bottom="1%">
                <fo:inline font-weight="bold">Example:</fo:inline>
            <xsl:apply-templates/>
            </fo:block>

          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name(.) = 'informalequation'">
      <xsl:choose>
        <xsl:when test="$pgwide = '1'">
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="pgwide.properties
                                            informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block id="{$id}"
                    xsl:use-attribute-sets="informalequation.properties">
            <xsl:if test="$keep.together != ''">
              <xsl:attribute name="keep-together.within-column"><xsl:value-of
                              select="$keep.together"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                xsl:use-attribute-sets="informal.object.properties">
        <xsl:if test="$keep.together != ''">
          <xsl:attribute name="keep-together.within-column"><xsl:value-of
                          select="$keep.together"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


  <!-- add brackets for replaceable -->

  <xsl:template match="replaceable">
    <xsl:call-template name="inline.add-brackets"/>
  </xsl:template>

  <xsl:template name="inline.add-brackets">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
	<xsl:with-param name="content">
	  <xsl:apply-templates/>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:param>

    <fo:inline color="#268bd2" xsl:use-attribute-sets="monospace.properties">
      <xsl:call-template name="anchor"/>
      <xsl:if test="@dir">
	<xsl:attribute name="direction">
	  <xsl:choose>
	    <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
	    <xsl:otherwise>rtl</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="concat('&lt;',$content,'&gt;')"/>
    </fo:inline>
  </xsl:template>


  <!-- Support tables with tabstyle='small' -->
  <xsl:attribute-set name="table.table.properties">
    <xsl:attribute name="font-size">
      <xsl:choose>
	<xsl:when test="ancestor-or-self::table[1]/@tabstyle='small' or
			ancestor-or-self::informaltable[1]/@tabstyle='small'">
	  <xsl:value-of select="$body.font.master * 0.7"/><xsl:text>pt</xsl:text>
	</xsl:when>
	<xsl:otherwise>inherit</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>


  <!-- Skip certain material from the PDF Bookmark/Contents -->
 <xsl:template match="section" mode="fop1.outline" />


 <!-- From:
 http://www.sagehill.net/docbookxsl/PrintToc.html#PartToc
 -->
 <!-- Generate TOC for part as part of part titlepage -->
 <xsl:template name="part.titlepage.before.verso" priority="1">
   <xsl:variable name="toc.params">
     <xsl:call-template name="find.path.params">
       <xsl:with-param name="table"
		       select="normalize-space($generate.toc)"/>
     </xsl:call-template>
   </xsl:variable>
   <xsl:if test="contains($toc.params, 'toc')">
     <xsl:call-template name="division.toc">
       <xsl:with-param name="toc.context" select="."/>
     </xsl:call-template>
   </xsl:if>
 </xsl:template>

 <!-- Switch off the original  part toc page-sequence template -->
 <xsl:template name="generate.part.toc"/>
  
</xsl:stylesheet>
