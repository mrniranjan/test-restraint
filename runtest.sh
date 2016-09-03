#!/bin/bash

# Include Beaker environment
. /usr/bin/rhts-environment.sh || exit 1
. /usr/share/beakerlib/beakerlib.sh || exit 1
rlJournalStart
rlPhaseStartTest
rlRun "ls -l /tmp"
rlPhaseEnd
rlJournalPrintText
report=/tmp/rhts.report.$RANDOM.txt
#makereport $report
rhts-submit-log -l $report
rlJournalEnd

