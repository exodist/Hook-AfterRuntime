#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use vars qw/$TRIGGERED/;
use lib '.', './t';

BEGIN { print "A\n" }
use TestB;
BEGIN { print "B\n" }

ok( $main::TRIGGERED, "triggered" );

done_testing();
