package Hook::AfterRuntime;
use strict;
use warnings;

use B::Hooks::EndOfScope;
use B::Hooks::Parser;
use base 'Exporter';

our $VERSION = '0.002';
our @EXPORT = qw/after_runtime/;
our @IDS;

sub get_id {
    my $code = shift;
    push @IDS => $code;
    return $#IDS;
}

sub run {
    my $id = shift;
    $IDS[$id]->();
}

sub after_runtime(&$) {
    my ( $code, $caller ) = @_;
    my $id = get_id( $code );

    B::Hooks::Parser::inject( ';'
        . "use B::Hooks::EndOfScope; "
        . "on_scope_end { "
        . "Hook::AfterRuntime::run($id)"
        . " };"
    );
}

1;

=head1 NAME

Hook::AfterRuntime - Run code at the end of the compiling scope's runtime.

=head1 DESCRIPTION

Useful for creating modules that need a behavior to be added when a module that
uses them completes it's runtime.

Example where it might be handy:

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Test::More;

    ...

    # It would be nice not to need this....
    done_testing();

=head1 SYNOPSYS

Test/More/AutoDone.pm

    package Test::More::AutoDone;
    use strict;
    use warnings;
    use Hook::AfterRuntime;
    use Test::More;

    sub import {
        my $caller = caller;
        eval "package $caller; use Test::More; 1" || die $@;
        after_runtime { done_testing() }
    }

    1;

t/mytest.t

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Test::More::AutoDone;

    ok( 1, "1 is true last I checked" );

    #EOF

=head1 SEE ALSO

This module uses B::Hooks::EndOfScope, which does almost the same thing, except
it is triggered after compile-time instead of run-time.

=head1 FENNEC PROJECT

This module is part of the Fennec project. See L<Fennec> for more details.
Fennec is a project to develop an extendable and powerful testing framework.
Together the tools that make up the Fennec framework provide a potent testing
environment.

The tools provided by Fennec are also useful on their own. Sometimes a tool
created for Fennec is useful outside the greator framework. Such tools are
turned into their own projects. This is one such project.

=over 2

=item L<Fennec> - The core framework

The primary Fennec project that ties them all together.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Hook-AfterRuntime is free software; Standard perl licence.

Hook-AfterRuntime is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
