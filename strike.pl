#!/usr/bin/perl

# Ubuntu /etc/init/tty1.conf
# exec /sbin/getty -i -n -8 38400 -l /usr/local/bin/strike.pl tty1

# TO DO: Accept multiple prox readers based on a prox prefix
# Different curl IP for each different prox prefix

$|=1;
use strict;
use warnings;
use Term::ReadKey;
use Date::Manip;
use CGI qw/:standard/;

if ( $ENV{GATEWAY_INTERFACE} ) {
	print header;

	if ( my $pin = param('pin') ) {
		chomp($_ = ((grep { /\b$pin$/ } getusers('/etc/strike/users'))[0]) || $pin);
		#$ENV{NOBUZZ} = 1;
		Strike($_);
		viewlog(1);
	} elsif ( param('frontdoorlog') ) {
		viewlog(param('frontdoorlog'));
	} else {
		print start_html('Door Access!');
		print h1(a({-href=>"?frontdoorlog=20"}, 'Door Access!'));
		print start_form;
		print 'For whom? ', textfield('note'), br, 'PIN: ', password_field('pin'), br, submit('frontdoor', 'Open Front Door');
		print end_form;
		print end_html;
	}
} else {
	if ( $ENV{PIN} ) {
		chomp($_ = ((grep { /$ENV{PIN}$/ } getusers('/etc/strike/users'))[0]) || $ENV{PIN});
	} else {
		#print "Striking...\n";
		#my $rfid = $ARGV[1] or die "No strike\n";
		print "Strike: ";
		ReadMode 2;
		chomp($ENV{RFID} = <STDIN>) or die "No strike\n";
		ReadMode 0;
		chomp($_ = $ENV{RFID} =~ /^PRX/ ? ((grep { /\t$ENV{RFID}\b/ } getusers('/etc/strike/users'))[0]) || $ENV{RFID} : $ENV{RFID});
	}
	Strike($_);
}

sub Strike {
	local $_ = shift;

	my ($name, $ok, $label, $rfid, $pin);
	if ( /^(.*?)\s+([210])\t(\d+)\t([^\t]+)\t?(\d{4}?)/ ) {
		($name, $ok, $label, $rfid, $pin) = ($1, $2, $3, $4, $5);
	} else {
		($name, $ok) = ($ENV{RFID}||$ENV{PIN}||param('pin'), -1);
	}

	local $_ = join "\t", grep { $_ } scalar localtime, $name.(param('note')?' ('.param('note').')':''), $ENV{REMOTE_ADDR};
	print unless $ENV{GATEWAY_INTERFACE};
	my $log = 1;
	open DATA, ">>/var/log/strike.log" or $log = 0;
	if ( $ENV{PIN} && $pin && $ENV{PIN} ne $pin ) {
		print DATA "Wrong PIN: $_\n" if $log;
	} elsif ( $ok == 1 || ($ok == 2 && Date_IsWorkDay(ParseDate('now'), 1)) ) {  # 8a-5p
		# use LWP
		qx{curl http://172.16.254.2/state.xml?relayState=2 2>/dev/null} unless $ENV{NOBUZZ};
		# Error codes?
		print DATA "Allow: $_\n" if $log;
	} elsif ( $ok == 2 ) {
		print DATA "Deny After Hours: $_\n" if $log;
	} elsif ( $ok == 0 ) {
		print DATA "Deny: $_\n" if $log;
	} else {
		print DATA "Deny Unknown Attempt: $_\n" if $log;
	}
	close DATA if $log;
}

sub getusers {
	# use MySQL
	open USERS, $_[0] or return ();
	my @users= <USERS>;
	close USERS;
	return @users;
}

sub viewlog {
	open LOG, '/var/log/strike.log';
	my @log = <LOG>;
	close LOG;
	my $start = $#log-$_[0]+1;
	$start = 0 if $start < 0;
	print "Last $_[0] entries", br, br;
	print join br, @log[$start..$#log];
}
