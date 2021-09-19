# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils systemd

DESCRIPTION="Logitechmediaserver in a container"
HOMEPAGE="https://github.com/lmiphay/logitechmediaserver-docker"
SRC_URI="https://github.com/lmiphay/${PN}/archive/refs/tags/${PVR}.tar.gz -> ${PN}-${PVR}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-emulation/docker
	sys-apps/coreutils
	sys-apps/grep
"
DEPEND="
"

DOCS="README.md"

S="${WORKDIR}/${PF}"

src_install() {
	dobin "bin/logitechmediaserver-docker"

	newconfd "openrc/logitechmediaserver.conf.d" "logitechmediaserver"
	newinitd "openrc/logitechmediaserver.init.d" "logitechmediaserver"

	systemd_dounit "etc/logitechmediaserver.service"

	insinto "/etc"
	doins "etc/logitechmediaserver.conf"
}
