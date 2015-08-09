# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user flag-o-matic git-r3

DESCRIPTION="Squeezelite is a small headless Squeezebox emulator for Linux using ALSA audio output"
HOMEPAGE="https://code.google.com/p/squeezelite"

EGIT_REPO_URI="https://code.google.com/p/squeezelite"
GIT_ECLASS="git-r3"
EGIT_COMMIT="8b8dfe6918ebe45ade5f3d9b68d453d7b8128d99"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac dsd ffmpeg flac mad mpg123 resample visexport vorbis"

# ToDo: visexport use flag needs jivelite - add ebuild for https://code.google.com/p/jivelite/

# ffmpeg provides alac and wma codecs
DEPEND="media-libs/alsa-lib
		flac? ( media-libs/flac )
		ffmpeg? ( media-video/ffmpeg )
		vorbis? ( media-libs/libvorbis )
		mad? ( media-libs/libmad )
		mpg123? ( media-sound/mpg123 )
		aac? ( media-libs/faad2 )
		resample? ( media-libs/soxr )
"
RDEPEND="${DEPEND}
		 media-sound/alsa-utils"

pkg_setup() {
	# Create the user and group if not already present
	enewuser squeezelite -1 -1 "/dev/null" audio
}

src_prepare () {
	# Apply patches
	epatch "${FILESDIR}/${P}-gentoo-makefile.patch"
	epatch "${FILESDIR}/${P}-gentoo-optional-codecs.patch"
}

src_compile() {

	if use dsd; then
		append-cflags "-DDSD"
		einfo "dsd support enabled via dsd2pcm"
	fi

	if use ffmpeg; then
		append-cflags "-DFFMPEG"
		einfo "alac and wma support enabled via ffmpeg"
	fi

	if use resample; then
		append-cflags "-DRESAMPLE"
		einfo "resample support enabled via soxr"
	fi

	if use visexport; then
		append-cflags "-DVISEXPORT"
		einfo "audio data export to jivelite support enabled"
	fi

	# Configure other optional codec support; this is added to the original
	# source via a patch in this ebuild at present.
	if ! use flac; then
		append-cflags "-DSL_NO_FLAC"
		einfo "FLAC support disabled; add 'flac' USE flag if you need it"
	fi
	if ! use vorbis; then
		append-cflags "-DSL_NO_OGG"
		einfo "Ogg/Vorbis support disabled; add 'vorbis' USE flag if you need it"
	fi
	if ! use mad; then
		append-cflags "-DSL_NO_MAD"
	fi
	if ! use mpg123; then
		append-cflags "-DSL_NO_MPG123"
	fi
	if ! use mad && ! use mpg123; then
		einfo "MP3 support disabled; add 'mad' (recommended)"
		einfo "  or 'mpg123' USE flag if you need it"
	fi
	if ! use aac; then
		append-cflags "-DSL_NO_AAC"
		einfo "AAC support disabled; add 'aac' USE flag if you need it"
	fi

	# Build it
	emake || die "emake failed"
}

src_install() {
	dobin squeezelite
	dodoc LICENSE.txt

	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}

pkg_postinst() {
	# Provide some post-installation tips.
	elog "If you want start Squeezelite automatically on system boot:"
	elog "  rc-update add squeezelite default"
	elog "Edit /etc/cond.d/squeezelite to customise -- in particular"
	elog "you may want to set the audio device to be used."
}
