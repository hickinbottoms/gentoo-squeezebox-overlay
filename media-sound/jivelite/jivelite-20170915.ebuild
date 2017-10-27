# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="Community logitech media server control application"
HOMEPAGE="https://github.com/ralph-irving/jivelite"

EGIT_REPO_URI="https://github.com/ralph-irving/jivelite.git"
EGIT_COMMIT="d3f683ca70ea1c959e8e994e7c94d9f036963760"

LICENSE="jivelite"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/luajit
	dev-lua/lua-cjson
	dev-lua/luacrypto
	dev-lua/luaexpat
	dev-lua/luafilesystem
	dev-lua/luasocket
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/sdl-gfx
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's;-lpthread;-lpthread -lrt;' "src/Makefile"

	sed -i -e 's;CFLAGS  = -O2;CFLAGS  +=;' "lib-src/luazipfilter/Makefile"
	sed -i -e 's;LDFLAGS =;LDFLAGS += -shared;' "lib-src/luazipfilter/Makefile"

	sed -i '/CC= gcc/d' "lib-src/luamd5/Makefile"
	sed -i -e 's;CFLAGS= $(INCS) $(DEFS) $(WARN) -O2 $G -fPIC;CFLAGS += $(INCS) $(DEFS) -fPIC;' "lib-src/luamd5/Makefile"
	sed -i -e 's;$(MYLDFLAGS);-shared $(LDFLAGS) $(MYLDFLAGS);' "lib-src/luamd5/Makefile"

	sed -i -e 's;"arp ";"/sbin/arp ";' "share/jive/jive/net/NetworkThread.lua"
	eapply_user
}

src_compile() {
	emake -C src PREFIX=/usr
	emake -C lib-src/luazipfilter PREFIX=/usr
	emake -C lib-src/luamd5 PREFIX=/usr MYNAME=sha1
	emake -C lib-src/luamd5 PREFIX=/usr MYNAME=md5
}

src_install() {
	dobin bin/jivelite
	insinto /usr/share/jive

	doins -r share/jive/jive

	doins -r share/jive/fonts
	doins -r share/jive/applets

	for i in loop ltn12.lua lxp mime.lua socket socket.lua ; do
		doins -r share/lua/5.1/$i
	done

	doins lib-src/luazipfilter/zipfilter.so
	doins lib-src/luamd5/md5.so
	doins lib-src/luamd5/sha1.so
}

pkg_postinst() {
	elog "Support thread at: http://forums.slimdevices.com/showthread.php?98156-Announce-JiveLite-cut-down-squeezebox-control-application"
}
