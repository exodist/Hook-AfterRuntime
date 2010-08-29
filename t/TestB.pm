package TestB;
use strict;
use warnings;

use Test::More;

BEGIN { print "AA\n" }
use TestA;
BEGIN { print "BB\n" }

ok( !$main::TRIGGERED, "Not triggered yet." );

1;
