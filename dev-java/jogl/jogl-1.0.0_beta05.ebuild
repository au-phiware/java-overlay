# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators '_' )
MY_PV=$(replace_version_separator 3 '-' ${MY_PV})

DESCRIPTION="Java(TM) Binding fot the OpenGL(TM) API"
HOMEPAGE="https://jogl.dev.java.net"
SRC_URI="http://download.java.net/media/jogl/builds/archive/jsr-231-beta5/${PN}-src-${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cg doc"

COMMON_DEPEND="cg? ( media-gfx/nvidia-cg-toolkit )"

DEPEND=">=virtual/jdk-1.4
		dev-java/ant-core
		dev-java/antlr
		app-arch/unzip
		${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
		${COMMON_DEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	cd make/
	local antflags="-Dantlr.jar=$(java-pkg_getjars antlr)"
	use cg && antflags="${antflags} -Djogl.cg=1 -Dx11.cg.lib=/usr/lib"
	eant ${antflags} all $(use_doc javadoc.dev.x11)
}

src_install() {
	if use doc; then
		mv javadoc_public api
		mv javadoc_jogl_dev dev_api
		java-pkg_dohtml -r api dev-api
	fi
	java-pkg_doso build/obj/*.so
	java-pkg_dojar build/*.jar
}

