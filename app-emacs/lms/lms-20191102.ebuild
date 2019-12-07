# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 elisp

HASH="14e2e8432425429430a394870db7823ee9445e0d"
SHORTHASH="14e2e8432425"

DESCRIPTION="Frontend for Squeezebox / Logitech Media Server"
HOMEPAGE="https://hg.serna.eu/emacs/lms"
SRC_URI="https://hg.serna.eu/emacs/lms/archive/${HASH}.zip?subrepos=false -> ${P}.zip"
RESTRICT="mirror"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="helm"

# need seq.el included in emacs 25
RDEPEND="
	>=app-editors/emacs-25.2
	helm? ( app-emacs/helm )
"
BDEPEND="${RDEPEND}"

DOCS="README.org"
DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="customize:

 lms-hostname, lms-telnet-port, lms-html-port, lms-username, lms-password

and run with: lms-ui

Then read complete documentation by pressing the 'h' key

For an overview of what it can do see: https://inigo.katxi.org/blog/2017/07/31/lms_el.html

Support thread at: http://forums.slimdevices.com/showthread.php?107769-Announce-lms-el-a-squeezebox-controller-for-emacs
"

S="${WORKDIR}/lms-${SHORTHASH}"

src_install() {
	readme.gentoo_create_doc
	elisp_src_install
}

pkg_postinst() {
	readme.gentoo_print_elog
}
