package Hook::AfterRuntime;
use strict;
use warnings;

use B::Hooks::Parser;
use base 'Exporter';

our $VERSION = '0.004';
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

sub after_runtime(&) {
    my ( $code ) = @_;
    my $id = get_id( $code );

    B::Hooks::Parser::inject(
        "; my \$__ENDRUN = Hook::AfterRuntime->new($id);"
    );
}

sub new {
    my $class = shift;
    my ($id) = @_;
    bless( \$id, $class );
}

sub DESTROY {
    my $self = shift;
    run( $$self );
}

1;

=head1 NAME

Hook::AfterRuntime - Run code at the end of the compiling scope's runtime.

=head1 DESCRIPTION

Useful for creating modules that need a behavior to be added when a module that
uses them completes it's runtime. Like L<B::Hooks::EndOfScope> except it
triggers for run-time instead of compile-time.

Example where it might be handy:

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Moose;

    ...

    # It would be nice not to need this....
    __PACKAGE__->make_immutable;

=head1 SYNOPSYS

MooseX/AutoImmute.pm

    package MooseX::AutoImmute;
    use strict;
    use warnings;
    use Hook::AfterRuntime;

    sub import {
        my $class = shift;
        my $caller = caller;
        eval "package $caller; use Moose; 1" || die $@;
        after_runtime { $caller->make_immutable }
    }

    1;

t/mytest.t

    #!/usr/bin/perl
    use strict;
    use warnings;
    use MooseX::AutoImmute;

    ....

    #EOF
    # Package is now immutable autamatically

=head1 SEE ALSO

=over 4

=item B::Hooks::EndOfScope

Does almost the same thing, except it is triggered after compile-time instead
of run-time.

=back

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
