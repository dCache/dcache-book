export XML_CATALOG_FILES := software/catalog

### Configuration
#

# The souce files. Written in dCache extended DocBook and using XInclude
#
SOURCES := Book.xml config-PoolManager.xml  config.xml  cookbook.xml  glossary.xml  install.xml  reference.xml  rf-dvl.xml


HTML_LOCATION ?= built
WEB_LOCATION ?= web-output


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
	xsltproc --nonet --xinclude -o Book.dcb.xml xsl/docbook-from-dcb-extensions.xsl Book.xml
	echo '<?xml version="1.0" encoding="UTF-8"?>' > tmp.xml
	echo '<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.3//EN" "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd">' >> tmp.xml
	grep -v '<?xml' Book.dcb.xml >> tmp.xml
	mv -f tmp.xml Book.dcb.xml

###### HTML targets
#

#  Plain chunked HTML
#
html:		.html.built
.html.built:	Book.db.xml $(HTML_LOCATION)/dcb.css
	xsltproc --nonet -o $(HTML_LOCATION)/ xsl/html-chunk.xsl Book.db.xml
	touch .html.built

# Plain single HTML
#
singlehtml: $(HTML_LOCATON)/Book.html 
$(HTML_LOCATON)/Book.html: Book.db.xml $(HTML_LOCATION)/dcb.css 
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
dcachedotorg: cvs shtml

# Sidebar
#
$(WEB_LOCATION)/sidebar-index.shtml: Book.db.xml
	mkdir -p $(HTML_LOCATION)
	mkdir -p $(WEB_LOCATION)
	xsltproc --nonet --xinclude -o $(HTML_LOCATION)/ xsl/html-dcache.org-sidebar.xsl Book.db.xml
	cp $(HTML_LOCATION)/index.shtml $(WEB_LOCATION)/sidebar-index.shtml

# Main part 
#
shtml:		.shtml.built
.shtml.built:	Book.db.xml $(WEB_LOCATION)/dcb.css $(WEB_LOCATION)/sidebar-index.shtml
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
#	XML_CATALOG_FILES=software/catalog xsltproc --nonet http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl Book.db.xml > Book.fo
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
	/opt/sfw/bin/cvs update -d

# Install DTD, XSL stylesheet, and FOP (xsltproc, xmllint, 
#
install-software:	software/db43xml/docbookx.dtd software/docbook-xsl/README software/fop/fop.sh software/catalog

software/db43xml/docbookx.dtd:
	mkdir -p software/db43xml/
	cd software/db43xml/ && wget http://docbook.org/xml/4.3/docbook-xml-4.3.zip && unzip docbook-xml-4.3.zip

software/docbook-xsl/README:
	mkdir -p software/
	cd software/ && wget http://mesh.dl.sourceforge.net/sourceforge/docbook/docbook-xsl-1.68.1.tar.bz2  && \
	tar xjf docbook-xsl-1.68.1.tar.bz2 && ln -s docbook-xsl-1.68.1 docbook-xsl

software/fop/fop.sh:
	mkdir -p software/
	cd software/ && wget http://ftp.uni-erlangen.de/pub/mirrors/apache/xml/fop/fop-current-bin.tar.gz && tar xzf fop-current-bin.tar.gz && ln -s fop-0* fop

software/catalog: xsl/catalog
	mkdir -p software/
	cp -f xsl/catalog software/catalog

.PHONY:	singlehtml html pdf fo install-software cvs dcachedotorg

