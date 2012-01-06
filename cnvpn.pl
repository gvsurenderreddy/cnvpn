#!/usr/bin/perl
use strict;
use warnings;
use feature 'switch';
use feature 'say';

my $checktun=`ip link list | grep tun`;
sub getconf {
   my %confa;
   open FILE, "cnvpn.conf" or die "$!"; 
     while (<FILE>) {
     chomp;
     my ($param, $value) = split /=/;
     $confa{$param} .= exists $confa{$param} ? "$value":$value;
     }
   close FILE;
   return %confa;
   }

if ($checktun =~ m/tun/) {
print "vpn tun already exists. terminate it (y/n)? \n";
my $response=<STDIN>;
chomp($response); 
        given ($response) { 
                when (/['y','yes']/i) {
                say 'closing vpn connection';
                system("sudo kill `pidof openconnect`");
                 }            
                when (/['n','no']/i) {
                say 'leave it be...';
                exit 0;
                }            
                default {
                die "wrong entry. use y or n.";
                exit 0;
                    }
        }
} else {
my %conf=&getconf;
print "connect vpn at $conf{serverurl} as $conf{username}(y/n)?";
my $response=<STDIN>;
chomp($response); 
        given ($response) { 
                when (/['y','yes']/i) {
                say 'connecting...';
                system("echo $conf{password} | sudo openconnect -u $conf{username} $conf{serverurl} --passwd-on-stdin -q -b");
                 }            
                when (/['n','no']/i) {
                say 'ok...over and out.';
                exit 0;
                }            
                default {
                die "wrong entry. use y or n.";
                exit 0;
                    }
        }


}
