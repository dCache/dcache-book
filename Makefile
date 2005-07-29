export XML_CATALOG_FILES := software/catalog

### Configuration
#

# The souce files. Written in dCache extended DocBook and using XInclude
#
SOURCES := Book.xml config-PoolManager.xml  config.xml  cookbook.xml  glossary.xml  install.xml  reference.xml  rf-dvl.xml

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

# Default values for output directories
#
#   Directory for all regular HTML output, also used as a temporary dir for dcache.org 
HTML_LOCATION ?= built
#   Directory for dcache.org SHTML output. Some files from $(HTML_LOCATION) get copied here
WEB_LOCATION ?= web-output

# Default value for CVS binary (assume in the path)
#
CVS_BINARY ?= cvs

###### Docbook targets. Pure DocBook is generated from the sources first
#

# Generates and validates DocBook
#
Book.db.xml:	$(SOURCES) xsl/dcb-extensions.xsl xsl/docbook-from-dcb-extensions.xsl
	xsltproc --nonet --xinclude -o Book.db.xml xsl/docbook-from-dcb-extensions.xsl Book.xml
	xmllint --noout --dtdvalid software/db43xml/docbookx.dtd Book.db.xml

# Generates DocBook and adds the correct DOCTYPE
#
Book.db2.xml:	$(SOURCES) xsl/dcb-extensions.xsl xsl/docbook-from-dcb-extensions.xsl
	XML_CATALOG_FILES=$(XML_CATALOG_FILES) xsltproc --nonet --xinclude -o Book.db2.xml xsl/docbook-from-dcb-extensions.xsl Book.xml
	echo '<?xml version="1.0" encoding="UTF-8"?>' > tmp.xml
	echo '<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.3//EN" "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd">' >> tmp.xml
	grep -v '<?xml' Book.db2.xml >> tmp.xml
	mv -f tmp.xml Book.db2.xml

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
singlehtml: $(HTML_LOCATON)/Book.html 
$(HTML_LOCATON)/Book.html: $(STYLESHEETS_HTML) Book.db.xml $(HTML_LOCATION)/dcb.css 
	xsltproc --nonet -o $(HTML_LOCATION)/Book.html xsl/html.xsl Book.db.xml

# Just copying the CSS
#
$(HTML_LOCATION)/dcb.css: xsl/dcb.css
	mkdir -p $(HTML_LOCATION)
	cp -f xsl/dcb.css $(HTML_LOCATION)

###### www.dcache.org SHTML targets
#

# The whole thing
#
dcachedotorg: cvs shtml singlehtml pdf
	cp $(HTML_LOCATION)/Book.html $(WEB_LOCATION)/dCacheBook.html
	cp Book.pdf $(WEB_LOCATION)/dCacheBook.pdf

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

# XSL Formated Output target
#
fo:		Book.fo
Book.fo:	Book.db.xml
#	xsltproc --nonet http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl Book.db.xml > Book.fo
	software/fop/xalan.sh -in Book.db.xml -xsl software/docbook-xsl/fo/docbook.xsl -out Book.fo

# PDF from XSL-FO
#
pdf:		Book.pdf
Book.pdf:	Book.fo
	software/fop/fop.sh Book.fo Book.pdf || true
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
install-software:	software/db43xml/docbookx.dtd software/docbook-xsl/README software/fop/fop.sh software/catalog

software/db43xml/docbook-xml-4.3.zip: 
	mkdir -p software/db43xml/
	cd software/db43xml/ && wget http://docbook.org/xml/4.3/docbook-xml-4.3.zip

software/db43xml/docbookx.dtd: software/db43xml/docbook-xml-4.3.zip
	cd software/db43xml/ && unzip docbook-xml-4.3.zip

software/docbook-xsl-1.68.1.tar.bz2:
	mkdir -p software/
	cd software/ && wget http://mesh.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.68.1.tar.bz2

software/docbook-xsl/README: software/docbook-xsl-1.68.1.tar.bz2
	cd software/ && \
	bzcat docbook-xsl-1.68.1.tar.bz2 | tar xf - && ln -s docbook-xsl-1.68.1 docbook-xsl

software/fop-current-bin.tar.gz:
	mkdir -p software/
	cd software/ && wget http://ftp.uni-erlangen.de/pub/mirrors/apache/xml/fop/fop-current-bin.tar.gz

software/fop/fop.sh: software/fop-current-bin.tar.gz
	cd software/ && gunzip -c fop-current-bin.tar.gz | tar xf - && ln -s fop-0* fop

software/catalog: xsl/catalog
	mkdir -p software/
	cp -f xsl/catalog software/catalog

.PHONY:	singlehtml html pdf fo install-software cvs dcachedotorg

