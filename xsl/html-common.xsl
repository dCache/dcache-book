<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!--
  <xsl:param name="html.ext" select="'.shtml'"/>
  -->

  <xsl:template name="tr.attributes">
    <xsl:param name="row" select="."/>
    <xsl:param name="rownum" select="0"/>
    
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


  <xsl:template match="informalexample">
    <div class="informalexample">
      <xsl:call-template name="anchor"/>
      <p class="title"><b>Example:</b></p>
      <div class="informalexamplebody">
	<xsl:apply-templates/>
      </div>
      <xsl:if test="$spacing.paras != 0"><p/></xsl:if>
    </div>
  </xsl:template>


  <!--  Book-level TOC has only Part- and Chapter- entries,
       whereas Chapters have all sections.

       Taken from http://www.sagehill.net/docbookxsl/TOCcontrol.html -->
  <xsl:template match="preface|chapter|appendix|article" mode="toc">
    <xsl:param name="toc-context" select="."/>

    <xsl:choose>
      <xsl:when test="local-name($toc-context) = 'book'">
	<xsl:call-template name="subtoc">
	  <xsl:with-param name="toc-context" select="$toc-context"/>
	  <xsl:with-param name="nodes" select="foo"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="subtoc">
	  <xsl:with-param name="toc-context" select="$toc-context"/>
	  <xsl:with-param name="nodes"
			  select="section|sect1|glossary|bibliography|index
				  |bridgehead[$bridgehead.in.toc != 0]"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Must be absolute location for CSS file -->
  <!-- TODO: move this to dCache site -->
  <xsl:param name="html.stylesheet"
	     select="'http://www.dcache.org/manuals/Book/book.css'"/>

  
  <!-- Customise our HEAD contents -->
  <xsl:template name="user.head.content">
    <xsl:comment>#include virtual="/template/frags/std-html-head.shtml"</xsl:comment>
  </xsl:template>



</xsl:stylesheet>

