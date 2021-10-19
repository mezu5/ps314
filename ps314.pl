#!/usr/bin/perl
use warnings;
use strict;
$|=1;

my $SLP = 5;
my $IMG = "/home/pi/img/pi314.a.img";
die "no $IMG" unless -f $IMG;

my $BEEP_PIN = 13;
#my $BEEP_SHORT = "gpio -g write $BEEP_PIN 1; sleep 0.1; gpio -g write $BEEP_PIN 0";
#my $BEEP_LONG = "gpio -g write $BEEP_PIN 1; sleep 2; gpio -g write $BEEP_PIN 0";
my $BEEP_ON = "raspi-gpio set $BEEP_PIN op pn dh";
my $BEEP_OFF = "raspi-gpio set $BEEP_PIN op pn dl";
my $BEEP_SHORT = "$BEEP_ON ; sleep 0.1; $BEEP_OFF";
my $BEEP_LONG = "$BEEP_ON ; sleep 1; $BEEP_OFF";

#print `gpio -g mode $BEEP_PIN out`;
print `$BEEP_LONG`;

use File::stat;
my $st = stat($IMG) or die "stat($IMG): $!";

#my $lm = $st->mtime;
my $lm = 0;
while (1) {
	my $st = stat($IMG) or die "stat($IMG): $!";
	my $cm = $st->mtime;

	if ($cm == $lm) {
		print "=";
		sleep $SLP;
		next;
	}

	if ($cm < $lm) {
		print "-";
		sleep $SLP;
		$lm = $cm - 1;
		next;
	}

	my $dm = time - $cm;
	if ($dm < 120) {
		print "<";
		print `$BEEP_SHORT`;
		sleep $SLP;
		next;
	}

	print `$BEEP_LONG`;
	print `sh ps314-sync.sh`;
	print `$BEEP_LONG`;
	
	print "\n";
	$lm = $cm;
	sleep $SLP;
}

exit 23;












