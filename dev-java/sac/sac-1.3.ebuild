# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg

DESCRIPTION="SAC is a standard interface for CSS parser"

HOMEPAGE="http://www.w3.org/Style/CSS/SAC/"

SRC_URI="http://www.w3.org/2002/06/sacjava-${PV}.zip"

LICENSE="w3c"

SLOT="0"

KEYWORDS="~x86"

IUSE="doc jikes source"

DEPEND="app-arch/unzip
		virtual/jdk
		jikes? (dev-java/jikes)
		source? (app-arch/zip)
		"

RDEPEND="virtual/jre"

src_unpack() {
	unpack $A
	cp ${FILESDIR}/build.xml $S
	cd $S
	rm -fr sac.jar META-INF
	mkdir src
	mv org src
}
 
src_compile() {
	local antflags
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant || die "Compiling failed"
}

src_install() {
	use doc && java-pkg_dohtml -r ./doc/*
	dohtml COPYRIGHT.html

	if use source; then
		java-pkg_dosrc src/* || die "Failed to package sources"
	fi

	cd dist
	dojar sac.jar
}
