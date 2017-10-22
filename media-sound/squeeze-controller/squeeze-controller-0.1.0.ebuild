# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit readme.gentoo-r1 eutils versionator

MY_VER="alpha.13"

DESCRIPTION="A stylish controller app for the Logitech Media Server"
HOMEPAGE="https://github.com/michiil/squeeze-controller"
SRC_URI="https://github.com/michiil/${PN}/releases/download/${PV}-${MY_VER}/${PN}-linux-x64.tar.gz -> ${P}-${MY_VER}-linux-x64.tar.gz"
#        https://github.com/michiil/squeeze-controller/releases/download/0.1.0-alpha.13/squeeze-controller-linux-x64.tar.gz
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
"

QA_PREBUILT="opt/${PN}/${PN} opt/${PN}/libffmpeg.so opt/${PN}/libnode.so"

S="${WORKDIR}/Squeeze Controller-linux-x64"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Support thread at:
   http://forums.slimdevices.com/showthread.php?105966-Announce-Squeeze-Controller-windows-linux-osx-Alpha-Testers-Wanted
"

src_install() {
	exeinto /opt/${PN}
	newexe "Squeeze Controller" ${PN}

	insinto /opt/${PN}
	doins libffmpeg.so libnode.so
	doins -r locales resources

	doins \
		blink_image_resources_200_percent.pak \
		content_resources_200_percent.pak \
		content_shell.pak \
		ui_resources_200_percent.pak \
		views_resources_200_percent.pak

	doins \
		icudtl.dat \
		natives_blob.bin \
		snapshot_blob.bin

	make_wrapper "${PN}" ./${PN} /opt/${PN} .

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
