# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit readme.gentoo-r1 eutils bash-completion-r1 git-r3

DESCRIPTION="command-line control of squeezebox network players via squeezeserver"
HOMEPAGE="https://github.com/pssc/squeezy"
EGIT_REPO_URI="https://github.com/pssc/squeezy.git"
EGIT_COMMIT="3f3ef31e4d7cd6a8d88863f272297fd07a85ab23"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/JSON-RPC
"

DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1
DOC_CONTENTS="
   The emerge install warning 'Problems with installed bash completions...' is
   covered in the documentation (search for: 'squeezy -print_links'). If it
   still complains about missing alias/symlinks, then check for duplicate players
   in the output of:

   squeezy -verbose -players

   (e.g. finding servers twice once by IP, and once by name)

Support thread at:
   http://forums.slimdevices.com/showthread.php?87636-squeezy-a-command-line-wrapper-around-the-squeezeserver-telnet-CLI
"

PATCHES=( \
		"${FILESDIR}/cant-locate-sqs.patch" \
		"${FILESDIR}/fix-bash-completion.patch"
)

src_install() {
	dobin squeezy
	dodoc squeezy.README.txt squeezy.HELP.txt
	newdoc squeezy.conf squeezy.conf.example

	newbashcomp _squeezy.bash ${PN}

	# zsh
	insinto /usr/share/zsh/site-functions
	doins _squeezy

	insinto /etc
	newins squeezy.conf squeezy.conf.example

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
