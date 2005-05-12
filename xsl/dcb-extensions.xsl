<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- Extensions of docbook-xsl for the dCache Book
       Can be used in two ways:
       1. Incluson in customization layer of docbook-xsl for 
          html/pdf/... generation. (e.g. dcb-dcache.org-website.xsl) (This does not work)
       2. Transformation of dCache-Book-extended docbook to
          standard docbook. (e.g. docbook-from-dcb-extensions.xsl)                -->
  
  <xsl:template match="dcpoolprompt">
    <prompt>(<replaceable>poolname</replaceable>) admin &gt; </prompt>
  </xsl:template>
  
  <xsl:template match="dcpmprompt">
    <prompt>(PoolManager) admin &gt; </prompt>
  </xsl:template>
  
  <xsl:template match="rootprompt">
    <prompt>[root@machine ~ ] # </prompt>
  </xsl:template>

  <xsl:template match="cellname">
    <classname>
      <xsl:apply-templates/>
    </classname>
  </xsl:template>

  <xsl:template match="cellattrclassname|cellattrtype|cellattrname|cellattrmlt|cellattrversion">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="cellattributes">
    <refsection>
      <title>Attributes</title>
      <informaltable tabstyle="cellattributes">
        <tgroup cols='2'>
          <thead>
            <row>
              <entry>
                Attribute
              </entry>
              <entry>
                Value
              </entry>
            </row>
          </thead>
          <tbody>
            <row>
              <entry>
                Class Name
              </entry>
              <entry>
                <xsl:apply-templates select="cellattrclassname"/>
              </entry>
            </row>
            <row>
              <entry>
                Cell Type
              </entry>
              <entry>
                <xsl:apply-templates select="cellattrtype"/>
              </entry>
            </row>
            <row>
              <entry>
                Cell Name
              </entry>
              <entry>
                <xsl:apply-templates select="cellattrname"/>
              </entry>
            </row>
            <row>
              <entry>
                Instance Multiplicity
              </entry>
              <entry>
                <xsl:apply-templates select="cellattrmlt"/>
              </entry>
            </row>
            <row>
              <entry>
                Production CVS Version
              </entry>
              <entry>
                <xsl:apply-templates select="cellattrversion"/>
              </entry>
            </row>
          </tbody>
        </tgroup>
      </informaltable>
    </refsection>
  </xsl:template>
  
  <xsl:template match="celloptions">
    <refsection>
      <title>Options</title>
      <informaltable tabstyle="celloptions">
        <tgroup cols='4'>
          <thead>
            <row>
              <entry>
                Option
              </entry>
              <entry>
                Values
              </entry>
              <entry>
                Default Value
              </entry>
              <entry>
                Description
              </entry>
            </row>
          </thead>
          <tbody>
            <xsl:apply-templates select="cellopt"/>
          </tbody>
        </tgroup>
      </informaltable>
      <xsl:apply-templates select="celloptionsdescr"/>
    </refsection>
  </xsl:template>

  <xsl:template match="cellopt">
    <row class="cellopt{@choice}">
      <entry id="{@id}">
        <xsl:attribute name="xreflabel">
          <xsl:value-of select="celloptname"/>
        </xsl:attribute>
        <xsl:apply-templates select="celloptname"/>
      </entry>
      <entry>
        <xsl:apply-templates select="celloptvalues"/>
      </entry>
      <entry>
        <xsl:apply-templates select="celloptdefault"/>
      </entry>
      <entry>
        <xsl:apply-templates select="celloptdescr"/>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="celloptname|celloptvalues|celloptdefault|celloptdescr">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="celloptionsdescr">
    <refsection>
      <xsl:apply-templates/>
    </refsection>
  </xsl:template>

  

</xsl:stylesheet>
