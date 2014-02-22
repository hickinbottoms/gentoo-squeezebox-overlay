# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

/var/log/galileo/galileo.log /var/log/galileo/galileo.err {
	missingok
	notifempty
	copytruncate
	rotate 5
	size 100k
}

