# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-ant-2 java-pkg-2

DESCRIPTION="Another PostgreSQL Diff Tool is a simple PostgreSQL diff tool that is useful for schema upgrades."
HOMEPAGE="http://apgdiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc source test"

DEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.7.0_rc1
	>=dev-java/ant-junit-1.7.0_rc1
	app-arch/zip
	test? ( >=dev-java/junit-4.1* )"

RDEPEND=">=virtual/jre-1.5"

src_unpack() {
	unpack ${A}

	cp ${FILESDIR}/${P}-build.xml ${S}/build.xml

	mkdir ${S}/lib
	cd ${S}/lib
	use test && java-pkg_jar-from --build-only junit-4
}

src_compile() {
	eant jar $(use_doc)
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar
	java-pkg_dolauncher apgdiff --jar ${PN}.jar

	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/main/java/*
}

src_test() {
	eant test
}