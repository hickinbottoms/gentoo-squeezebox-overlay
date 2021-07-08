# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit readme.gentoo-r1

DESCRIPTION="logitechmediaserver in a gentoo docker"
HOMEPAGE="https://github.com/lmiphay/lms-gd"
SRC_URI="https://github.com/lmiphay/lms-gd/archive/v0.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-emulation/docker
	dev-vcs/git
"

DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1
DOC_CONTENTS="
  This is an experimental attempt at running logitechmediaserver in a gentoo docker

  Please report issues at the bug tracker: https://github.com/lmiphay/lms-gd/issues
"

DOCS=( "README.md" )

src_install() {
	dobin "${PN}"

	insinto /usr/share/lms-gd
	doins Dockerfile lms.keywords lms.use make.conf.lms-gd squeezebox.conf

	newconfd "${PN}.conf.d" "${PN}"
	newinitd "${PN}.init.d" "${PN}"

	readme.gentoo_create_doc

	default
}

pkg_postinst() {
	readme.gentoo_print_elog
}
