# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-maven java-pkg eutils

MY_PN="maven"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The core of Maven"
HOMEPAGE="http://maven.apache.org"
# svn co http://svn.apache.org/repos/asf/maven/maven-1/core/tags/MAVEN_1_0_2 maven-1.0.2
# tar cjvf maven-1.0.2-gentoo.tar.bz2 maven-1.0.2
SRC_URI="http://gentooexperimental.org/distfiles/${MY_P}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	dev-java/commons-collections
	=dev-java/dom4j-1*
	=dev-java/jaxen-1.1*
	dev-java/werkz
	dev-java/xml-commons
	=dev-java/commons-cli-1*
	=dev-java/commons-beanutils-1.6*
	dev-java/forehead
	dev-java/commons-logging
	=dev-java/commons-jexl-1.0*
	dev-java/commons-lang
	dev-java/plexus-utils
	=dev-java/xerces-2*
	dev-java/commons-graph
	dev-java/commons-grant
	=dev-java/commons-jelly-1*
	=dev-java/commons-jelly-tags-define-1*
	dev-java/maven-jelly-tags
	=dev-java/commons-jelly-tags-xml-1*
	=dev-java/commons-jelly-tags-util-1*
	=dev-java/commons-jelly-tags-ant-1*
	=dev-java/commons-io-1*
	dev-java/commons-digester
	=dev-java/commons-httpclient-2*
	dev-java/maven-jelly-tags
	!=dev-java/maven-bin-1*
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"


src_unpack() {
	unpack ${A}
	cd ${S}
	# This patches makes the bootstrap only build the core of maven
	#   and additionally use lib/ to build its classpath (as opposed to 
	#   trying to download them).
	epatch ${FILESDIR}/${P}-coreonly.patch

	# change org.apache.plexus to org.codehaus.plexus
	sed -i -e 's/org\.apache\.plexus/org\.codehaus\.plexus/g' \
		src/java/org/apache/maven/plugin/GoalToJellyScriptHousingMapper.java \
		src/java/org/apache/maven/util/DVSLPathTool.java \
		src/java/org/apache/maven/repository/AbstractArtifact.java

	sed -i -e "s/@pom.currentVersion@/${PV}/" src/conf/driver.properties
	
	# This build.xml was generated by 'maven ant', and fixed slightly.
	cp ${FILESDIR}/build-${PV}.xml build.xml

	mkdir lib
	cd lib
	java-pkg_jar-from commons-collections
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from log4j
	java-pkg_jar-from werkz
	java-pkg_jar-from xml-commons which.jar
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from commons-beanutils-1.6
	java-pkg_jar-from forehead
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-jexl-1.0
	java-pkg_jar-from commons-lang
	java-pkg_jar-from plexus-utils
	java-pkg_jar-from xerces-2
	java-pkg_jar-from commons-betwixt
	java-pkg_jar-from commons-graph
	java-pkg_jar-from commons-grant
	java-pkg_jar-from commons-jelly-1
	java-pkg_jar-from commons-jelly-tags-define-1
	java-pkg_jar-from commons-jelly-tags-xml-1
	java-pkg_jar-from commons-jelly-tags-util-1
	java-pkg_jar-from commons-jelly-tags-ant-1
	java-pkg_jar-from commons-io-1
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-httpclient
	java-pkg_jar-from maven-jelly-tags

#	cd ../src/bin
#	epatch ${FILESDIR}/${P}-script.patch
}

src_compile() {
	local antflags="jar -Dnoget=true"


	ant ${antflags} || die "ant failed"

}

src_install() {
	java-pkg_dojar target/${MY_PN}.jar

	doman src/man/*

	dodir ${JAVA_MAVEN_SYSTEM_HOME}
	insinto ${JAVA_MAVEN_SYSTEM_HOME}
	doins src/xsd/*

	dodir ${JAVA_MAVEN_SYSTEM_BIN}
	cp src/bin/maven ${D}/${JAVA_MAVEN_SYSTEM_BIN}
	insinto ${JAVA_MAVEN_SYSTEM_BIN}
	doins ${FILESDIR}/forehead.conf

	dodir /usr/bin
#	ln -s ${JAVA_MAVEN_SYSTEM_BIN}/maven ${D}/usr/bin/maven
	dosym ${JAVA_MAVEN_SYSTEM_BIN}/maven /usr/bin/${MY_PN}

	keepdir ${JAVA_MAVEN_SYSTEM_PLUGINS}

	dodir ${JAVA_MAVEN_SYSTEM_LIB}
	cd ${D}/${JAVA_MAVEN_SYSTEM_LIB}
	java-pkg_jar-from ant-core ant.jar ant-1.5.3-1.jar
	java-pkg_jar-from ant-tasks
	java-pkg_jar-from commons-collections commons-collections.jar \
		commons-collections-2.1.jar
	java-pkg_jar-from dom4j-1 dom4j.jar dom4j-1.4-dev-8.jar
	java-pkg_jar-from log4j log4j.jar log4j-1.2.8.jar
	java-pkg_jar-from werkz werkz.jar werkz-20040426.222000.jar
	java-pkg_jar-from xml-commons which.jar which-1.0.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar \
		commons-cli-1.0-beta-2.jar
	java-pkg_jar-from commons-beanutils-1.6 commons-beanutils.jar \
		commons-beanutils-1.6.1.jar
	# forehead needs to be named properly
	java-pkg_jar-from forehead forehead.jar forehead-1.0-beta-5.jar
	java-pkg_jar-from commons-logging commons-logging.jar \
		commons-logging-1.0.3.jar
	java-pkg_jar-from commons-jexl-1.0 commons-jexl.jar \
		commons-jexl-1.0-beta-1.jar
	java-pkg_jar-from commons-lang commons-lang.jar \
		commons-lang-2.0.jar
	java-pkg_jar-from plexus-utils plexus-utils.jar \
		plexus-0.6.jar
	java-pkg_jar-from commons-betwixt commons-betwixt.jar \
		commons-betwixt-1.0-beta-1.20030111.103454.jar
	java-pkg_jar-from commons-graph commons-graph.jar \
		commons-graph-0.8.1.jar
	java-pkg_jar-from commons-grant commons-grant.jar \
		commons-grant-1.0-beta-4.jar
	java-pkg_jar-from commons-jelly-1 commons-jelly.jar \
		commons-jelly-20030902.160215.jar
	java-pkg_jar-from commons-jelly-tags-define-1 commons-jelly-tags-define.jar \
		commons-jelly-tags-define-20030211.142932.jar
	java-pkg_jar-from commons-jelly-tags-xml-1 commons-jelly-tags-xml.jar \
		commons-jelly-tags-xml-20040613.030723.jar
	java-pkg_jar-from commons-jelly-tags-util-1 commons-jelly-tags-util.jar \
		commons-jelly-tags-util-20030211.141939.jar
	java-pkg_jar-from commons-jelly-tags-ant-1 commons-jelly-tags-ant.jar \
		commons-jelly-tags-ant-20030625.032346.jar
	java-pkg_jar-from commons-io-1 commons-io.jar \
		commons-io-20030203.000550.jar
	java-pkg_jar-from commons-digester commons-digester.jar \
		commons-digester-1.4.1.jar
	java-pkg_jar-from commons-httpclient commons-httpclient.jar \
		commons-httpclient-2.0.jar
	java-pkg_jar-from maven-jelly-tags maven-jelly-tags.jar \
		maven-jelly-tags-1.0.jar
	java-pkg_jar-from jaxen-1.1
	ln -sf /usr/share/maven-core-1/lib/maven.jar

	mkdir endorsed
	cd endorsed
	java-pkg_jar-from xerces-2 xercesImpl.jar xerces-2.4.0.jar
	java-pkg_jar-from xerces-2 xml-apis.jar xml-apis-1.0.b2.jar
}
