#!/usr/bin/perl
package Net::DNS::Codes;
use strict;
#use diagnostics;
use Carp;

use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS $AUTOLOAD);
require Exporter;
@ISA = qw(Exporter);

$VERSION = do { my @r = (q$Revision: 0.12 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

# various EXPORT variables are declared at end of this module

sub AUTOLOAD {
  no strict;
  my $sub = $AUTOLOAD;
  (my $func = $sub) =~ s/.*:://;
  if (defined (my $val = &_Code->{$func})) {
    *$sub = sub { $val };
    goto &$sub;
  }
  croak "Undefined function Net::DNS::Codes::${func}";
}

=head1 NAME

Net::DNS::Codes - collection of C<C> library DNS codes

=head1 SYNOPSIS

  use Net::DNS::Codes qw(
	:header
	:RRs
	:constants
	:all
    (or any individual item)
  );

  --------- :header -------

  $textval = RBitsTxt->{masked_bits};
  $textval = RcodeTxt->{numeric};
  $textval = OpcodeTxt->{numeric};
  $code = (one of text below)

QR AA TC RD RA MBZ Z AD CD

BITS_QUERY
BITS_IQUERY
BITS_STATUS
BITS_NS_NOTIFY_OP
BITS_NS_UPDATE_OP

QUERY
IQUERY
STATUS
NS_NOTIFY_OP
NS_UPDATE_OP

NOERROR
FORMERR
SERVFAIL
NXDOMAIN
NOTIMP
REFUSED
YXDOMAIN
YXRRSET
NXRRSET
NOTAUTH
NOTZONE
BADSIG
BADKEY
BADTIME

  for flag manipulation

RCODE_MASK
BITS_OPCODE_MASK

  ------- :RRs -------

  $textval = ClassTxt->{numeric};  
  $textval = TypeTxt->{numeric};
  $code = (one of text below)

C_IN
C_CHAOS
C_HS
C_NONE
C_ANY

T_A
T_NS
T_MD
T_MF
T_CNAME
T_SOA
T_MB
T_MG
T_MR
T_NULL
T_WKS
T_PTR
T_HINFO
T_MINFO
T_MX
T_TXT
T_RP
T_AFSDB
T_X25
T_ISDN
T_RT
T_NSAP
T_NSAP_PTR
T_SIG
T_KEY
T_PX
T_GPOS
T_AAAA
T_LOC
T_NXT
T_EID
T_NIMLOC
T_SRV
T_ATMA
T_NAPTR
T_KX
T_CERT
T_A6
T_DNAME
T_SINK
T_OPT
T_TKEY
T_TSIG
T_IXFR
T_AXFR
T_MAILB
T_MAILA
T_ANY

  ------- :constants -------
  $code = (one of test below)

PACKETSZ NS_PACKETSZ MAXDNAME NS_MAXDNAME 
MAXCDNAME NS_MAXCDNAME MAXLABEL NS_MAXLABEL HFIXEDSZ NS_HFIXEDSZ   
QFIXEDSZ NS_QFIXEDSZ RRFIXEDSZ NS_RRFIXEDSZ INT32SZ NS_INT32SZ
INT16SZ NS_INT16SZ NS_INT8SZ INADDRSZ NS_INADDRSZ 
IN6ADDRSZ NS_IN6ADDRSZ INDIR_MASK NS_CMPRSFLGS  
NAMESERVER_PORT NS_DEFAULTPORT
  
  $code = INT8SZ (not a DNS code, added for convenience)

=head1 DESCRIPTION

B<Net::DNS::Codes> provides forward and reverse lookup for most
common C<C> library DNS codes as well as all the codes for the DNS 
HEADER field.

=over 4

=item * $bitmask = XX

  Return the bitmask for the code:

   15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
  |QR|   Opcode  |AA|TC|RD|RA| Z|AD|CD|   Rcode   |
  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15

  QR		=>	1000_0000_0000_0000
  BitsOpcode	=>	Opcode binary value
			left shifted 11 bits
  AA		=>	100_0000_0000
  TC		=>	10_0000_0000
  RD		=>	1_0000_0000
  RA		=>	1000_0000
  MBZ or Z	=>	100_0000
  AD		=>	10_0000
  CD		=>	1_0000
  Rcode		=>	Rcode binary value

  RCODE_MASK	=>	1111_1111_1111_0000

  where BitsOpcode =

  BITS_QUERY	    =>      0, 
  BITS_IQUERY	    =>      1000_0000_0000 # 1 << 11
  BITS_STATUS	    =>    1_0000_0000_0000 # 2 << 11
  BITS_NS_NOTIFY_OP =>   10_0000_0000_0000 # 4 << 11
  BITS_NS_UPDATE_OP =>   10_1000_0000_0000 # 5 << 11

  BITS_OPCODE_MASK  => 1000_0111_1111_1111

=cut

my %_query = (
	QR		=> 0x1<<15,
	AA		=> 0x1<<10,
	TC		=> 0x1<<9,
	RD		=> 0x1<<8,
	RA		=> 0x1<<7,
	MBZ		=> 0x1<<6,
	AD		=> 0x1<<5,
	CD		=> 0x1<<4,
   BITS_QUERY		=> 0, 
   BITS_IQUERY		=> 1 << 11,	
   BITS_STATUS		=> 2 << 11,
   BITS_NS_NOTIFY_OP	=> 4 << 11,
   BITS_NS_UPDATE_OP	=> 5 << 11,
   BITS_OPCODE_MASK	=> 0xF<<11 ^ 0xFFFF,
   RCODE_MASK		=> 0xFFF0,
);

my %_querytxt;
while (my($key,$val) = each %_query) {
  $key =~ s/BITS_//;
  $_querytxt{$val} = $key;
}

$_query{Z} = $_query{MBZ};

sub RBitsTxt { \%_querytxt };  

=item * $textval = RBitsTxt->{masked_bits};

Returns the TEXT string for the bit fields above.

  NOTE: that MBZ and Z have the same value. 
  The text string 'MBZ' is returned for 0x1 << 6

=item * $textval = RcodeTxt->{numeric};

  Return the TEXT string for numeric code.

	NOERROR		=> 0,
	FORMERR		=> 1,
	SERVFAIL	=> 2,
	NXDOMAIN	=> 3,
	NOTIMP		=> 4,
	REFUSED		=> 5,
	YXDOMAIN	=> 6,
	YXRRSET		=> 7,
	NXRRSET		=> 8,
	NOTAUTH		=> 9,
	NOTZONE		=> 10,
	BADSIG		=> 16,
	BADKEY		=> 17,
	BADTIME		=> 18,

=cut

my %_rcode = (
	NOERROR		=> 0,
	FORMERR		=> 1,
	SERVFAIL	=> 2,
	NXDOMAIN	=> 3,
	NOTIMP		=> 4,
	REFUSED		=> 5,
	YXDOMAIN	=> 6,
	YXRRSET		=> 7,
	NXRRSET		=> 8,
	NOTAUTH		=> 9,
	NOTZONE		=> 10,
	BADSIG		=> 16,
	BADKEY		=> 17,
	BADTIME		=> 18,
);

my %_rcodeTxt = reverse %_rcode;

sub RcodeTxt	{\%_rcodeTxt};

=item * $textval = OpcodeTxt->{numeric};

  Return the TEXT string for numeric code.

	QUERY		=> 0,
	IQUERY		=> 1,
	STATUS		=> 2, 
	NS_NOTIFY_OP	=> 4, 
	NS_UPDATE_OP	=> 5,  

=cut

my %_opcode = (
	QUERY		=> 0,
	IQUERY		=> 1,
	STATUS		=> 2,
	NS_NOTIFY_OP	=> 4,
	NS_UPDATE_OP	=> 5,
);

my %_opcodeTxt = reverse %_opcode;

sub OpcodeTxt	{\%_opcodeTxt};

=item * $textval = ClassTxt->{numeric};

  Return the TEXT string for numeric code.

	C_IN	    => 1,
	C_CHAOS	 => 3,
	C_HS	    => 4,
	C_NONE	  => 254,
	C_ANY	   => 255,

=cut

my %_class = (
	C_IN		=> 1,
	C_CHAOS		=> 3,
	C_HS		=> 4,
	C_NONE		=> 254,
	C_ANY		=> 255,
);

my %_classTxt = reverse %_class;

sub ClassTxt	{\%_classTxt};
	
=item * $textval = TypeTxt->{numeric};

  Return the TEXT string for numeric code.

  T_A		=> 1,	# rfc1035.txt
  T_NS		=> 2,	# rfc1035.txt
  T_MD		=> 3,	# rfc1035.txt
  T_MF		=> 4,	# rfc1035.txt
  T_CNAME	=> 5,	# rfc1035.txt
  T_SOA		=> 6,	# rfc1035.txt
  T_MB		=> 7,	# rfc1035.txt
  T_MG		=> 8,	# rfc1035.txt
  T_MR		=> 9,	# rfc1035.txt
  T_NULL	=> 10,	# rfc1035.txt
  T_WKS		=> 11,	# rfc1035.txt
  T_PTR		=> 12,	# rfc1035.txt
  T_HINFO	=> 13,	# rfc1035.txt
  T_MINFO	=> 14,	# rfc1035.txt
  T_MX		=> 15,	# rfc1035.txt
  T_TXT		=> 16,	# rfc1035.txt
  T_RP		=> 17,	# rfc1183.txt
  T_AFSDB	=> 18,	# rfc1183.txt
  T_X25		=> 19,	# rfc1183.txt
  T_ISDN	=> 20,	# rfc1183.txt
  T_RT		=> 21,	# rfc1183.txt
  T_NSAP	=> 22,	# rfc1706.txt
  T_NSAP_PTR	=> 23,	# rfc1348.txt
  T_SIG		=> 24,	# rfc2535.txt
  T_KEY		=> 25,	# rfc2535.txt
  T_PX		=> 26,	# rfc2163.txt
  T_GPOS	=> 27,	# rfc1712.txt
  T_AAAA	=> 28,	# rfc1886.txt
  T_LOC		=> 29,	# rfc1876.txt
  T_NXT		=> 30,	# rfc2535.txt
  T_EID		=> 31,	# draft-ietf-nimrod-dns-02.txt
  T_NIMLOC	=> 32,	# draft-ietf-nimrod-dns-02.txt
  T_SRV		=> 33,	# rfc2052.txt
  T_ATMA	=> 34,	# af-saa-0069.000.txt
  T_NAPTR	=> 35,	# rfc2168.txt
  T_KX		=> 36,	# rfc2230.txt
  T_CERT	=> 37,	# rfc2538.txt
  T_A6		=> 38,	# rfc2874.txt
  T_DNAME	=> 39,	# rfc2672.txt
  T_SINK	=> 40,	# draft-ietf-dnsind-kitchen-sink-01.txt
  T_OPT		=> 41,	# rfc2671.txt
  T_APL		=> 42,	# rfc3123.txt
  T_DS		=> 43,	# draft-ietf-dnsext-delegation-signer-15.txt
  T_SSHFP	=> 44,	# rfc4255.txt
  T_IPSECKEY	=> 45,	# rfc4025.txt
  T_RRSIG	=> 46,	# rfc4034.txt
  T_NSEC	=> 47,	# rfc4034.txt
  T_DNSKEY	=> 48,	# rfc4034.txt
  T_DHCID	=> 49,	# rfc4701.txt
  T_NSEC3	=> 50,	# rfc5155.txt
  T_NSEC3PARAM	=> 51,	# rfc5155.txt
	# unassigned 52 - 54
  T_HIP		=> 55,	# rfc5205.txt
  T_NINFO	=> 56,	# unknown
  T_RKEY	=> 57,	# draft-reid-dnsext-rkey-00.txt
  T_ALINK	=> 58,	# draft-ietf-dnsop-dnssec-trust-history-02.txt
  T_CDS		=> 59,	# draft-barwood-dnsop-ds-publish-02.txt
	# unassigned 60 - 98
  T_UINFO	=> 100,	# reserved
  T_UID		=> 101,	# reserved
  T_GID		=> 102,	# reserved
  T_UNSPEC	=> 103,	# reserved
	# unassigned 104 - 248
  T_TKEY	=> 249,	# rfc2930.txt
  T_TSIG	=> 250,	# rfc2931.txt
  T_IXFR	=> 251,	# rfc1995.txt
  T_AXFR	=> 252,	# rfc1035.txt
  T_MAILB	=> 253,	# rfc973.txt
  T_MAILA	=> 254,	# rfc973.txt
  T_ANY		=> 255,	# rfc1886.txt

=cut

my %_type = (			# document in /extradocs
	T_A		=> 1,	# rfc1035.txt
	T_NS		=> 2,	# rfc1035.txt
	T_MD		=> 3,	# rfc1035.txt
	T_MF		=> 4,	# rfc1035.txt
	T_CNAME		=> 5,	# rfc1035.txt
	T_SOA		=> 6,	# rfc1035.txt
	T_MB		=> 7,	# rfc1035.txt
	T_MG		=> 8,	# rfc1035.txt
	T_MR		=> 9,	# rfc1035.txt
	T_NULL		=> 10,	# rfc1035.txt
	T_WKS		=> 11,	# rfc1035.txt
	T_PTR		=> 12,	# rfc1035.txt
	T_HINFO		=> 13,	# rfc1035.txt
	T_MINFO		=> 14,	# rfc1035.txt
	T_MX		=> 15,	# rfc1035.txt
	T_TXT		=> 16,	# rfc1035.txt
	T_RP		=> 17,	# rfc1183.txt
	T_AFSDB		=> 18,	# rfc1183.txt
	T_X25		=> 19,	# rfc1183.txt
	T_ISDN		=> 20,	# rfc1183.txt
	T_RT		=> 21,	# rfc1183.txt
	T_NSAP		=> 22,	# rfc1706.txt
	T_NSAP_PTR	=> 23,	# rfc1348.txt
	T_SIG		=> 24,	# rfc2535.txt
	T_KEY		=> 25,	# rfc2535.txt
	T_PX		=> 26,	# rfc2163.txt
	T_GPOS		=> 27,	# rfc1712.txt
	T_AAAA		=> 28,	# rfc1886.txt
	T_LOC		=> 29,	# rfc1876.txt
	T_NXT		=> 30,	# rfc2535.txt
	T_EID		=> 31,	# draft-ietf-nimrod-dns-02.txt
	T_NIMLOC	=> 32,	# draft-ietf-nimrod-dns-02.txt
	T_SRV		=> 33,	# rfc2052.txt
	T_ATMA		=> 34,	# af-saa-0069.000.txt
	T_NAPTR		=> 35,	# rfc2168.txt
	T_KX		=> 36,	# rfc2230.txt
	T_CERT		=> 37,	# rfc2538.txt
	T_A6		=> 38,	# rfc2874.txt
	T_DNAME		=> 39,	# rfc2672.txt
	T_SINK		=> 40,	# draft-ietf-dnsind-kitchen-sink-01.txt
	T_OPT		=> 41,	# rfc2671.txt
	T_APL		=> 42,	# rfc3123.txt
	T_DS		=> 43,	# draft-ietf-dnsext-delegation-signer-15.txt
	T_SSHFP		=> 44,	# rfc4255.txt
	T_IPSECKEY	=> 45,	# rfc4025.txt
	T_RRSIG		=> 46,	# rfc4034.txt
	T_NSEC		=> 47,	# rfc4034.txt
	T_DNSKEY	=> 48,	# rfc4034.txt
	T_DHCID		=> 49,	# rfc4701.txt
	T_NSEC3		=> 50,	# rfc5155.txt
	T_NSEC3PARAM	=> 51,	# rfc5155.txt
# unassigned 52 - 54
	T_HIP		=> 55,	# rfc5205.txt
	T_NINFO		=> 56,	# unknown
	T_RKEY		=> 57,	# draft-reid-dnsext-rkey-00.txt
	T_ALINK		=> 58,	# draft-ietf-dnsop-dnssec-trust-history-02.txt
	T_CDS		=> 59,	# draft-barwood-dnsop-ds-publish-02.txt
# unassigned 60 - 98
	T_UINFO		=> 100,	# reserved
	T_UID		=> 101,	# reserved
	T_GID		=> 102,	# reserved
	T_UNSPEC	=> 103,	# reserved
# unassigned 104 - 248
	T_TKEY		=> 249,	# rfc2930.txt
	T_TSIG		=> 250,	# rfc2931.txt
	T_IXFR		=> 251,	# rfc1995.txt
	T_AXFR		=> 252,	# rfc1886.txt
	T_MAILB		=> 253,	# rfc1886.txt
	T_MAILA		=> 254,	# rfc1886.txt
	T_ANY		=> 255,	# rfc1886.txt
);

my %_typeTxt = reverse %_type;

sub TypeTxt	{\%_typeTxt};

=item * (various constants)

  PACKETSZ        NS_PACKETSZ     512
  MAXDNAME        NS_MAXDNAME     1025
  MAXCDNAME       NS_MAXCDNAME    255 
  MAXLABEL        NS_MAXLABEL     63  
  HFIXEDSZ        NS_HFIXEDSZ     12  
  QFIXEDSZ        NS_QFIXEDSZ     4   
  RRFIXEDSZ       NS_RRFIXEDSZ    10  
  INT32SZ         NS_INT32SZ      4   
  INT16SZ         NS_INT16SZ      2   
  INT8SZ          NS_INT8SZ       1   
  INADDRSZ        NS_INADDRSZ     4   
  IN6ADDRSZ       NS_IN6ADDRSZ    16  
  INDIR_MASK      NS_CMPRSFLGS    0xc0
  NAMESERVER_PORT NS_DEFAULTPORT  53  

=back

=cut

my %_constants = (qw(
  PACKETSZ	  512	NS_PACKETSZ	512
  MAXDNAME	  1025	NS_MAXDNAME	1025
  MAXCDNAME	  255	NS_MAXCDNAME	255 
  MAXLABEL	  63	NS_MAXLABEL	63  
  HFIXEDSZ	  12	NS_HFIXEDSZ	12  
  QFIXEDSZ	  4	NS_QFIXEDSZ	4   
  RRFIXEDSZ	  10	NS_RRFIXEDSZ	10  
  INT32SZ	  4	NS_INT32SZ	4   
  INT16SZ	  2	NS_INT16SZ	2   
  INT8SZ	  1	NS_INT8SZ	1   
  INADDRSZ	  4	NS_INADDRSZ	4   
  IN6ADDRSZ	  16	NS_IN6ADDRSZ	16  
  INDIR_MASK ), 0xc0,qw(NS_CMPRSFLGS ),	0xc0, qw(
  NAMESERVER_PORT 53	NS_DEFAULTPORT	53  )
);

=head1 INSTALLATION

To install this module, type:

	perl Makfile.PL
	make
	make test
	make install

=cut

my %_allcodes = (%_rcode,%_opcode,%_type,%_class,%_query,%_constants);

sub _Code {\%_allcodes};

%EXPORT_TAGS = (
  header	=> [qw(
	QR AA TC RD RA MBZ Z AD CD
	RBitsTxt
	RcodeTxt
	OpcodeTxt),
	keys %_rcode,
	keys %_opcode,
	keys %_query,
  ],
  RRs	=> [qw(
	ClassTxt
	TypeTxt),
	keys %_class,
	keys %_type,
  ],

  constants => [
	keys %_constants
  ],
);

$EXPORT_TAGS{all} = [@{$EXPORT_TAGS{header}},@{$EXPORT_TAGS{RRs}},@{$EXPORT_TAGS{constants}}];

Exporter::export_ok_tags('all');

=head1 EXPORT_OK

  ------- for tag :header -------

RBitsTxt RcodeTxt OpcodeTxt

QR AA TC RD RA MBZ Z AD CD

BITS_QUERY
BITS_IQUERY
BITS_STATUS
BITS_NS_NOTIFY_OP
BITS_NS_UPDATE_OP

QUERY
IQUERY
STATUS
NS_NOTIFY_OP
NS_UPDATE_OP

NOERROR
FORMERR
SERVFAIL
NXDOMAIN
NOTIMP
REFUSED
YXDOMAIN
YXRRSET
NXRRSET
NOTAUTH
NOTZONE
BADSIG
BADKEY
BADTIME

BITS_OPCODE_MASK
RCODE_MASK

  ------- for tag :RRs -------

  $textval = ClassTxt->{numeric};  
  $textval = TypeTxt->{numeric};
  $code = (one of text below)

C_IN
C_CHAOS
C_HS
C_NONE
C_ANY

T_A
T_NS
T_MD
T_MF
T_CNAME
T_SOA
T_MB
T_MG
T_MR
T_NULL
T_WKS
T_PTR
T_HINFO
T_MINFO
T_MX
T_TXT
T_RP
T_AFSDB
T_X25
T_ISDN
T_RT
T_NSAP
T_NSAP_PTR
T_SIG
T_KEY
T_PX
T_GPOS
T_AAAA
T_LOC
T_NXT
T_EID
T_NIMLOC
T_SRV
T_ATMA
T_NAPTR
T_KX
T_CERT
T_A6
T_DNAME
T_SINK
T_OPT
T_APL
T_DS
T_SSHFP
T_IPSECKEY
T_RRSIG
T_NSEC
T_DNSKEY
T_DHCID
T_NSEC3
T_NSEC3PARAM
T_HIP
T_NINFO
T_RKEY
T_ALINK
T_CDS
T_UINFO
T_UID
T_GID
T_UNSPEC
T_TKEY
T_TSIG
T_IXFR
T_AXFR
T_MAILB
T_MAILA
T_ANY

  ------- for tag :constants -------

PACKETSZ NS_PACKETSZ MAXDNAME NS_MAXDNAME 
MAXCDNAME NS_MAXCDNAME MAXLABEL NS_MAXLABEL HFIXEDSZ NS_HFIXEDSZ   
QFIXEDSZ NS_QFIXEDSZ RRFIXEDSZ NS_RRFIXEDSZ INT32SZ NS_INT32SZ
INT16SZ NS_INT16SZ NS_INT8SZ INADDRSZ NS_INADDRSZ 
IN6ADDRSZ NS_IN6ADDRSZ INDIR_MASK NS_CMPRSFLGS  
NAMESERVER_PORT NS_DEFAULTPORT INT8SZ

=head1 EXPORT_TAGS

	:header
	:RRs
	:constants
	:all

=head1 AUTHOR

Michael Robinton, michael@bizsystems.com

=head1 COPYRIGHT

Copyright 2003 - 2014, Michael Robinton & BizSystems
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or 
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

=head1 SEE ALSO

perl(1), /usr/include/resolv.h /usr/include/arpa/nameser.h /usr/include/namser_compat.h

=cut

1;
