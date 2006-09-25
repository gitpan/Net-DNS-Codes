# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.
# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..107\n"; }
END {print "not ok 1\n" unless $loaded;}

use Net::DNS::Codes qw(:RRs);

$loaded = 1;
print "ok 1\n";
######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$test = 2;

sub ok {
  print "ok $test\n";
  ++$test;
}

## test 2-6 check class codes
my %classes = (
        C_IN            => 1,  
        C_CHAOS         => 3,
        C_HS            => 4,
        C_NONE          => 254,
        C_ANY           => 255,
);

foreach(sort {
	$classes{$a} <=> $classes{$b}
	} keys %classes) {
  printf("class %s\ngot: %d\nexp: %d\nnot ",$_,&$_,$classes{$_})
	unless &$_ == $classes{$_};
  &ok;
}

## test 7-11
my %revclasses = reverse %classes;

foreach(sort keys %revclasses) {
  printf("class %d\ngot: %s\nexp: %s\nnot ",$_,ClassTxt->{$_},$revclasses{$_})
	unless ClassTxt->{$_} eq $revclasses{$_};
  &ok;
}

## test 12-59
my %types = (
        T_A             => 1,
        T_NS            => 2,
        T_MD            => 3,
        T_MF            => 4,
        T_CNAME         => 5,
        T_SOA           => 6,
        T_MB            => 7,
        T_MG            => 8,
        T_MR            => 9,
        T_NULL          => 10,
        T_WKS           => 11,
        T_PTR           => 12,
        T_HINFO         => 13,
        T_MINFO         => 14,
        T_MX            => 15,
        T_TXT           => 16,
        T_RP            => 17,
        T_AFSDB         => 18,
        T_X25           => 19,
        T_ISDN          => 20,
        T_RT            => 21,
        T_NSAP          => 22, 
        T_NSAP_PTR      => 23, 
        T_SIG           => 24, 
        T_KEY           => 25,
        T_PX            => 26,
        T_GPOS          => 27,
        T_AAAA          => 28,
        T_LOC           => 29,
        T_NXT           => 30, 
        T_EID           => 31,
        T_NIMLOC        => 32,
        T_SRV           => 33,
        T_ATMA          => 34, 
        T_NAPTR         => 35,
        T_KX            => 36,
        T_CERT          => 37,
        T_A6            => 38,
        T_DNAME         => 39, 
        T_SINK          => 40, 
        T_OPT           => 41, 
	T_TKEY		=> 249,
        T_TSIG          => 250,
        T_IXFR          => 251,
        T_AXFR          => 252,
        T_MAILB         => 253,
        T_MAILA         => 254,
        T_ANY           => 255,
);

foreach(sort {
	$types{$a} <=> $types{$b}
	} keys %types) {
  printf("type %s\ngot: %d\nexp: %d\nnot ",$_,&$_,$types{$_})
	unless &$_ == $types{$_};
  &ok;
}

## test 60-108
my %revtypes = reverse %types;

foreach(sort keys %revtypes) {
  printf("type %d\ngot: %s\nexp: %s\nnot ",$_,TypeTxt->{$_},$revtypes{$_})
	unless TypeTxt->{$_} eq $revtypes{$_};
  &ok;
}
