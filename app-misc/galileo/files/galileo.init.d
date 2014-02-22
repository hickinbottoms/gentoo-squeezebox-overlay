#!/sbin/runscript
# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

pidfile=/var/run/galileo.pid
logdir=/var/log/galileo
uid=galileo
gid=galileo

depend() {
	need net
}

start() {
	ebegin "Starting Galileo tracker synchroniser"

	start-stop-daemon \
		--start --exec /usr/bin/galileo \
		--pidfile ${pidfile} \
		--make-pidfile \
		--user ${uid} \
		--group ${gid} \
		--stderr "${logdir}/galileo.log" \
		--background \
		-- \
		--config /etc/galileorc \
		daemon

	eend $? "Failed to start Galileo tracker synchroniser"
}

stop() {
	ebegin "Stopping Galileo tracker synchroniser"
	start-stop-daemon --retry 10 --stop --pidfile ${pidfile}
	eend $? "Failed to stop Galileo tracker synchroniser"
}
