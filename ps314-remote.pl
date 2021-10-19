#!/usr/bin/perl
use warnings;
use strict;
$|=1;

my $LIM = 3;

my $BEEP_PIN = 13;
my $BEEP_ON = "raspi-gpio set $BEEP_PIN op pn dh";
my $BEEP_OFF = "raspi-gpio set $BEEP_PIN op pn dl";

sub beep {
	my ($dur,) = @_;
	print `$BEEP_ON ; sleep $dur; $BEEP_OFF`;
}

open RTL, "rtl_433 -F csv|" or die "open: $!";

my %last = ();
while (<RTL>) {
	my $but = "";
	if (	/,Smoke-GS558,,17732,.*,88a880,/ ||
		/,Akhan-100F14,,4433,.*Lock/
		) {
		$but = "D on";
	} elsif (	/,Smoke-GS558,,17732,.*,28a880,/ ||
			/,Akhan-100F14,,4433,.*Mute/
		) {
		$but = "D off";
	} elsif (	/,Smoke-GS558,,20804,.*,8a2880,/ ||
			/,Akhan-100F14,,4421,.*Lock/
		) {
		$but = "C on";
	} elsif (	/,Smoke-GS558,,20804,.*,2a2880,/ ||
			/,Akhan-100F14,,4421,.*Mute/
		) {
		$but = "C off";
	} elsif (	/,Smoke-GS558,,21572,.*,8a8880,/ ||
			/,Akhan-100F14,,4373,.*Lock/
		) {
		$but = "B on";
	} elsif (	/,Smoke-GS558,,21572,.*,2a8880,/ ||
			/,Akhan-100F14,,4373,.*Mute/
		) {
		$but = "B off";
	} elsif (	/,Smoke-GS558,,21764,.*,8aa080,/ ||
			/,Akhan-100F14,,4181,.*Lock/
		) {
		$but = "A on";
	} elsif (	/,Smoke-GS558,,21764,.*,2aa080,/ ||
			/,Akhan-100F14,,4181,.*Mute/
		) {
		$but = "A off";
	} elsif (	/,Oregon-THGR122N,/ ||
			/,Waveman-Switch,.,I,.,/
		) {
		# ignore
	} else {
		warn "UNMATCHED: $_";
	}

	my $act = "";
	if (defined $but && length $but) {
		$last{$but} ||= 0;
		my $now = time;
		if (($last{$but}||0) < ($now-$LIM)) {
			printf "GOT: %s\n", $but;
			$last{$but} = $now;
			$act = $but;
		}
	}

	if (defined $act && length $act) {
		if ($act eq 'D on') {
			&beep(0.2);
			print `ssh -i .ssh/hg-on root\@10.13.0.1`;
			&beep(0.8);
		} elsif ($act eq 'D off') {
			&beep(0.8);
			print `ssh -i .ssh/hg-off root\@10.13.0.1`;
			&beep(0.2);
		}
	}
}



