#!/usr/bin/env perl
# PODNAME: resque-worker
# # ABSTRACT: Executable to run your resque workers

use strict;
use Resque;
use Getopt::Long::Descriptive;

my $opt = getopt();
$_->require for @{$opt->module||[]};

my $w = Resque->new( redis => $opt->redis )->worker;
$w->$_($opt->$_) for qw/ interval verbose cant_fork/;
$w->add_queue(@{$opt->queue});
$w->work;

sub getopt {
    my ($opt, $usage) = describe_options(
        "$0 \%o",
        [ 'redis|r=s@',   "Redis server (default: 127.0.0.1:6379)", { default => '127.0.0.1:6379' } ],
        [ 'queue|q=s@',   "Queue name/s (required)", { required => 1 } ],
        [],
        [ 'interval|i=f', "Polling interval in floating seconds for this resque worker (Default 5 seconds)", { default => 5 } ],
        [],
        [ 'module|M=s@',  "Modules to load before forking occurs" ],
        [ 'cant_fork|f',  "Don't let resque fork" ],
        [],
        [ 'verbose|v',    "set resque worker to be verbose" ],
        [ 'help',         "print usage message and exit" ],
    );

    print($usage->text), exit if $opt->help;
    return $opt;
}

=head1 SYNOPSIS

Listen to jobs on multiple queues:

    resque-worker -q important -q less_important

See --help option to know all it's options:

    reque-worker --help

=cut
