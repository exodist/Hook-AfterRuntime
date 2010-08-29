#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

our $TRIGGERED = 0;

BEGIN {
    package Test::A;
    use strict;
    use warnings;
    use Hook::AfterRuntime;

    sub import { after_runtime { $main::TRIGGERED++ }}

    $INC{ 'Test/A.pm' } = __FILE__;
}

{
    package Test::B;
    use strict;
    use warnings;

    use Test::More;
    use Test::A;

    ok( !$main::TRIGGERED, "Not triggered yet." );

    1;
}

ok( !$main::TRIGGERED, "triggered" );

done_testing;
