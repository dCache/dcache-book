######## Configuration
#

# The souce files. Written in dCache extended DocBook and using XInclude
#
SOURCES := Book.xml config-hsm.xml config-pnfs.xml config-PoolManager.xml config-cellpackage.xml config.xml cookbook-accounting.xml  cookbook-advanced.xml  cookbook-general.xml  cookbook-net.xml  cookbook-pool.xml  cookbook-protos.xml cookbook.xml  glossary.xml  intro.xml install.xml  reference.xml  rf-cc-common.xml  rf-cc-pm.xml  rf-cc-pnfsm.xml rf-dvl.xml rf-glossary.xml intouch.xml

# All stylesheets included by xsl/html-chunk.xsl
#
STYLESHEETS_CHUNK := xsl/html-chunk.xsl \
                    xsl/dcb-docbook-parameters.xsl xsl/dcb-docbook-html-chunk-customizations.xsl

# All stylesheets included by xsl/html.xsl
#
STYLESHEETS_HTML := xsl/html.xsl \
                    xsl/dcb-docbook-parameters.xsl xsl/dcb-docbook-html-chunk-customizations.xsl

# All stylesheets included by xsl/html-dcache.org-sidebar.xsl
#
STYLESHEETS_SIDEBAR := xsl/html-dcache.org-sidebar.xsl xsl/dcb-dcache.org-customizations.xsl \
                       xsl/dcb-docbook-parameters.xsl xsl/dcb-docbook-html-chunk-customizations.xsl \
                       xsl/dcb-dcache.org-sidebar-title.xsl 

# All stylesheets included by xsl/html-dcache.org.xsl
#
STYLESHEETS_MAIN := xsl/html-dcache.org.xsl xsl/dcb-dcache.org-customizations.xsl \
                    xsl/dcb-docbook-parameters.xsl xsl/dcb-docbook-html-chunk-customizations.xsl

# All stylesheets included by xsl/fo.xsl
#
STYLESHEETS_FO := xsl/fo.xsl xsl/dcb-docbook-fo-customizations.xsl \
                    xsl/dcb-docbook-parameters.xsl

# Default values for output directories
#
#   Directory for all regular HTML output, also used as a temporary dir for dcache.org 
HTML_LOCATION ?= built
#   Directory for dcache.org SHTML output. Some files from $(HTML_LOCATION) get copied here
WEB_LOCATION ?= web-output

######### Software Configs
#

# Default value for CVS binary (assume in the path)
#
CVS_BINARY ?= cvs

# Default value for docbook-xml version
#
DBXML_VERSION ?= 1.68.1

# xsltproc and so will use env. $XML_CATALOG_FILES
export XML_CATALOG_FILES := xsl/catalog

# xalan command
# The xalan script doesnt work, since xalan is in the JRE and will use the Xbootclasspath for
# dynamically loading org.apache.xml.resolver.tools.CatalogResolver and not classpath
#
XALAN := java -Xbootclasspath/p:software/fop/lib/xml-apis.jar:software/fop/lib/xercesImpl-2.2.1.jar:software/fop/lib/xalan-2.4.1.jar:software/fop/lib/resolver.jar:software/fop/lib/batik.jar:software/fop/lib/avalon-framework-cvs-20020806.jar:software/fop/build/fop.jar -Dxml.catalog.files=$(XML_CATALOG_FILES) -Dxml.catalog.prefer=public -Dxml.catalog.verbosity=9 -Dxml.catalog.staticCatalog=yes org.apache.xalan.xslt.Process -UriResolver org.apache.xml.resolver.tools.CatalogResolver

# FOP command
#
FOP := java -classpath software/fop/lib/xml-apis.jar:software/fop/lib/xercesImpl-2.2.1.jar:software/fop/lib/xalan-2.4.1.jar:software/fop/lib/resolver.jar:software/fop/lib/batik.jar:software/fop/lib/avalon-framework-cvs-20020806.jar:software/fop/build/fop.jar: org.apache.fop.apps.Fop

###### Docbook targets. Pure DocBook is generated from the sources first
#

# Generates and validates DocBook and checks for xinclude error of xsltproc -- other procs probably dont need that
#
Book.db.xml:	$(SOURCES) xsl/dcb-extensions.xsl xsl/docbook-from-dcb-extensions.xsl
	xsltproc --nonet --xinclude -o Book.db.xml xsl/docbook-from-dcb-extensions.xsl Book.xml 2> xsltproc.output
	cat xsltproc.output
	if grep error xsltproc.output >/dev/null ; then echo "Error in xi:include statement" ; rm Book.db.xml ; exit 1 ; fi
	if ! xmllint --noout --dtdvalid software/db43xml/docbookx.dtd Book.db.xml ; then mv Book.db.xml Book.broken.xml; exit 1 ; fi

# Generates DocBook and adds the correct DOCTYPE (not needed at the moment and should be added differently)
#
Book.db2.xml:	$(SOURCES) xsl/dcb-extensions.xsl xsl/docbook-from-dcb-extensions.xsl
	xsltproc --nonet --xinclude -o Book.db2.xml xsl/docbook-from-dcb-extensions.xsl Book.xml
	echo '<?xml version="1.0" encoding="UTF-8"?>' > tmp.xml
	echo '<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.3//EN" "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd">' >> tmp.xml
	grep -v '<?xml' Book.db2.xml >> tmp.xml
	mv -f tmp.xml Book.db2.xml

# Generates and validates DocBook including the unfinished parts and todo entries
#
Book.draft.xml:	$(SOURCES) xsl/dcb-extensions.xsl xsl/docbook-draft-from-dcb-extensions.xsl
	xsltproc --nonet --xinclude -o Book.draft.xml xsl/docbook-draft-from-dcb-extensions.xsl Book.xml 2> xsltproc.output
	cat xsltproc.output
	if grep error xsltproc.output >/dev/null ; then echo "Error in xi:include statement" ; rm Book.draft.xml ; exit 1 ; fi
	if ! xmllint --noout --dtdvalid software/db43xml/docbookx.dtd Book.draft.xml ; then mv Book.draft.xml Book.broken.xml ; exit 1 ; fi

###### HTML targets
#

#  Plain chunked HTML
#
html:		.html.built
.html.built:	$(STYLESHEETS_CHUNK) Book.db.xml $(HTML_LOCATION)/dcb.css
	xsltproc --nonet -o $(HTML_LOCATION)/ xsl/html-chunk.xsl Book.db.xml
	touch .html.built

# Plain single HTML
#
singlehtml: $(HTML_LOCATION)/Book.html 
$(HTML_LOCATION)/Book.html: $(STYLESHEETS_HTML) Book.db.xml $(HTML_LOCATION)/dcb.css
	xsltproc --nonet -o $(HTML_LOCATION)/Book.html xsl/html.xsl Book.db.xml

# Plain single HTML with unfinished and todos
#
draft: $(HTML_LOCATION)/Book.draft.html 
$(HTML_LOCATION)/Book.draft.html: $(STYLESHEETS_HTML) Book.draft.xml $(HTML_LOCATION)/dcb.css
	xsltproc --nonet -o $(HTML_LOCATION)/Book.draft.html xsl/html.xsl Book.draft.xml

# Just copying the CSS
#
$(HTML_LOCATION)/dcb.css: xsl/dcb.css
	mkdir -p $(HTML_LOCATION)
	cp -f xsl/dcb.css $(HTML_LOCATION)

###### www.dcache.org SHTML targets
#

# The whole thing
#
dcache.org: $(WEB_LOCATION)/dCacheBook.html $(WEB_LOCATION)/dCacheBook.pdf shtml
$(WEB_LOCATION)/dCacheBook.html: $(HTML_LOCATION)/Book.html
	cp $(HTML_LOCATION)/Book.html $(WEB_LOCATION)/dCacheBook.html
$(WEB_LOCATION)/dCacheBook.pdf: Book.pdf
	cp Book.pdf $(WEB_LOCATION)/dCacheBook.pdf

# Copy the WEB_LOCATION to the correct spot on www.dcache.org
#
ssh-dcache.org: .ssh-dcache.org-copied dcache.org
.ssh-dcache.org-copied: 
	cd $(WEB_LOCATION)/ && tar cf - * | ssh cvs-dcache 'cd /home/dcache.org/manuals/Book && sh -c "rm -rf *" && tar xf -'
	touch .ssh-dcache.org-copied

# Titlepage customization for Sidebar
#
xsl/dcb-dcache.org-sidebar-title.xsl: xsl/dcb-dcache.org-sidebar-title-tpl.xml
	xsltproc -nonet -output xsl/dcb-dcache.org-sidebar-title.xsl \
	http://docbook.sourceforge.net/release/xsl/current/template/titlepage.xsl \
	xsl/dcb-dcache.org-sidebar-title-tpl.xml

# Sidebar
#
$(WEB_LOCATION)/sidebar-index.shtml: $(STYLESHEETS_SIDEBAR) Book.db.xml
	mkdir -p $(HTML_LOCATION)
	mkdir -p $(WEB_LOCATION)
	xsltproc --nonet --xinclude -o $(HTML_LOCATION)/ xsl/html-dcache.org-sidebar.xsl Book.db.xml
	cp $(HTML_LOCATION)/index.shtml $(WEB_LOCATION)/sidebar-index.shtml

# Main part 
#
shtml:		.shtml.built
.shtml.built:	$(STYLESHEETS_MAIN) Book.db.xml $(WEB_LOCATION)/dcb.css $(WEB_LOCATION)/sidebar-index.shtml
	xsltproc --nonet -o $(WEB_LOCATION)/ xsl/html-dcache.org.xsl Book.db.xml
	touch .shtml.built

# Just copying the CSS
#
$(WEB_LOCATION)/dcb.css: xsl/dcb.css
	mkdir -p $(WEB_LOCATION)
	cp -f xsl/dcb.css $(WEB_LOCATION)

###### Printable targets
#

# XSL Formated Output target (xsltproc doesnt work together with fop)
#
fo:		Book.fo
Book.fo:	Book.db.xml $(STYLESHEETS_FO)
#	xsltproc --nonet xsl/fo.xsl Book.db.xml > Book.fo
	$(XALAN) -in Book.db.xml -xsl xsl/fo.xsl -out Book.fo

#-ENTITYRESOLVER org.apache.xml.resolver.tools.CatalogResolver -URIRESOLVER org.apache.xml.resolver.tools.CatalogResolver


# PDF from XSL-FO
#
pdf:		Book.pdf
Book.pdf:	Book.fo
	$(FOP) Book.fo Book.pdf 
#	pdfxmltex Book.fo

# PDF directly via xmlto (still broken)
#
Book.db2.pdf:	Book.db2.xml
	xmlto pdf Book.db2.xml

###### Utility and install targets
#

# Get current version
#
cvs:
	$(CVS_BINARY) update -d

# Install DTD, XSL stylesheet, and FOP (xsltproc, xmllint, 
#
install-software:	software/db43xml/docbookx.dtd software/docbook-xsl/README software/fop/fop.sh software/fop/lib/resolver.jar

software/db43xml/docbook-xml-4.3.zip: 
	mkdir -p software/db43xml/
	cd software/db43xml/ && wget http://docbook.org/xml/4.3/docbook-xml-4.3.zip

software/db43xml/docbookx.dtd: software/db43xml/docbook-xml-4.3.zip
	cd software/db43xml/ && unzip docbook-xml-4.3.zip
	touch software/db43xml/docbookx.dtd

software/docbook-xsl-$(DBXML_VERSION).tar.bz2:
	mkdir -p software/
	cd software/ && wget http://mesh.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-$(DBXML_VERSION).tar.bz2

software/docbook-xsl/README: software/docbook-xsl-$(DBXML_VERSION).tar.bz2
	cd software/ && \
	bzcat docbook-xsl-$(DBXML_VERSION).tar.bz2 | tar xf - && ln -ns docbook-xsl-$(DBXML_VERSION) docbook-xsl
	touch software/docbook-xsl/README

software/fop-current-bin.tar.gz:
	mkdir -p software/
	cd software/ && wget http://ftp.uni-erlangen.de/pub/mirrors/apache/xml/fop/fop-current-bin.tar.gz

software/fop/fop.sh: software/fop-current-bin.tar.gz
	cd software/ && gunzip -c fop-current-bin.tar.gz | tar xf - && ln -ns fop-0* fop
	touch software/fop/fop.sh

software/xml-commons-resolver-latest.tar.gz:
	mkdir -p software/
	cd software/ && wget http://www.apache.org/dist/xml/commons/xml-commons-resolver-latest.tar.gz
	touch software/xml-commons-resolver-latest.tar.gz

software/xml-commons-resolver/resolver.jar: software/xml-commons-resolver-latest.tar.gz
	cd software && gunzip -c xml-commons-resolver-latest.tar.gz | tar xf - && \
	  ln -ns `gunzip -c xml-commons-resolver-latest.tar.gz | tar tf - | head -1` xml-commons-resolver
	touch software/xml-commons-resolver/resolver.jar

software/fop/lib/resolver.jar: software/xml-commons-resolver/resolver.jar software/fop/fop.sh
	cp software/xml-commons-resolver/resolver.jar software/fop/lib/resolver.jar

.PHONY:	singlehtml html pdf fo install-software cvs dcache.org ssh-dcache.org

