#!/usr/bin/perl

$| = 1;
#$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME}=0; # Uncomment to ignore SSL/TLS issues.

use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Cookies;
use DateTime;

my $ua = LWP::UserAgent->new(requests_redirectable => [ 'GET', 'HEAD', 'POST' ], cookie_jar => HTTP::Cookies->new);
#$ua->ssl_opts( verify_hostnames => 0 ,SSL_verify_mode => 0x00); # Uncomment to ignore SSL/TLS issues.

my $host = '{bomgar-address}';
my $username = '{username}';
my $passwd = '{password}';
my $backup_path = '/tmp/backup/bomgar';

print 'Trying to connect to the BOMGAR appliance... ';
my $res = $ua->get('https://'.$host.'/api/backup?username='.$username.'&password='.$passwd);
if ($res->is_success) {
	if (index($res->content, 'Invalid credentials') != -1) {
		print 'Bad credentials!';
	} else {
		print "Success!\nFetching the backup file... ";
		$path = $backup_path.'/bomgar-'.DateTime->now->ymd.'.nsb';
		open (OUTPUT, '>'.$path);
		print OUTPUT $res->content;
		print "Done!\nThe configuration was backed-up to '".$path."'.";
	}
} else { print 'Failed!'; }
