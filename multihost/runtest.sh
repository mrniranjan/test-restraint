#!/bin/bash
# vim: dict+=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   runtest.sh of /performance/multihost/Performance/Multi-host-test
#   Description: multi hosts test
#   Author: Neependra Khare <nkhare@redhat.com>
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#   Copyright (c) 2014 Red Hat, Inc.
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 2 of
#   the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be
#   useful, but WITHOUT ANY WARRANTY; without even the implied
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  See the GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see http://www.gnu.org/licenses/.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Include Beaker environment
. /usr/bin/rhts-environment.sh
. /usr/lib/beakerlib/beakerlib.sh

Client() {
    rlPhaseStartTest Client
        rhts-sync-block -s "READY_1" ${SERVER}
        rlRun "date > ~/client"
        rhts-sync-set -s "DONE_1"
    rlPhaseEnd
}

Server() {
    rlPhaseStartTest Server
        rlRun "date > ~/server"
        rhts-sync-set -s "READY_2"
        rhts-sync-block -s "DONE_2" ${CLIENT}
    rlPhaseEnd
}


rlJournalStart
    rlPhaseStartSetup
        rlRun "TmpDir=\`mktemp -d\`" 0 "Creating tmp directory"
        rlRun "pushd $TmpDir"
        rlLog "Server: $SERVER"
        rlLog "Client: $CLIENT"
    rlPhaseEnd

    if echo $SERVER | grep -q $HOSTNAME ; then
        Server
    elif echo $CLIENT | grep -q $HOSTNAME ; then
        Client
    else
        rlReport "Stray" "FAIL"
    fi

    rlPhaseStartCleanup
        rlRun "popd"
        rlRun "rm -r $TmpDir" 0 "Removing tmp directory"
    rlPhaseEnd
rlJournalPrintText
rlJournalEnd
