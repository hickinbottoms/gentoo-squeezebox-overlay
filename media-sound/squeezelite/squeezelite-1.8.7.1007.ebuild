# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user flag-o-matic git-r3

DESCRIPTION="Lightweight headless squeezebox client emulator"
HOMEPAGE="https://github.com/ralph-irving/squeezelite"

EGIT_REPO_URI="https://github.com/ralph-irving/squeezelite.git"
EGIT_COMMIT="68770e4ed38d3a547912c39de69edaf41dcace84"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac dsd ffmpeg flac mad mpg123 pulseaudio resample visexport vorbis"

# ffmpeg provides alac and wma codecs
DEPEND="media-libs/alsa-lib
		flac? ( media-libs/flac )
		ffmpeg? ( media-video/ffmpeg )
		vorbis? ( media-libs/libvorbis )
		mad? ( media-libs/libmad )
		mpg123? ( media-sound/mpg123 )
		aac? ( media-libs/faad2 )
		resample? ( media-libs/soxr )
		visexport? ( media-sound/jivelite )
		pulseaudio? ( media-plugins/alsa-plugins[pulseaudio] )
"
RDEPEND="${DEPEND}
		 media-sound/alsa-utils"

pkg_setup() {
	enewgroup squeezelite
	if use pulseaudio ; then
		enewuser squeezelite -1 -1 "/dev/null" "squeezelite"
	else
		enewuser squeezelite -1 -1 "/dev/null" "squeezelite,audio"
	fi
}

src_prepare () {
	epatch "${FILESDIR}/${P}-gentoo-makefile.patch"
	epatch "${FILESDIR}/${P}-gentoo-optional-codecs.patch"
	epatch "${FILESDIR}/${P}-gentoo-optional-codecs-decode.patch"
	eapply_user
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
	elog "If you want start Squeezelite automatically on system boot:"
	elog "  rc-update add squeezelite default"
	elog "Edit /etc/cond.d/squeezelite to customise -- in particular"
	elog "you may want to set the audio device to be used."
}
