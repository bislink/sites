#!/usr/bin/env perl

use strict;

my $FILE = './container_name';

my $line;

if (-f "$FILE" ) {
    if ( open( my $file, "<", "$FILE" ) ) {
        $line = <$file>;
    } else {
        $line = 'unable to open file';
    }
} else {
    $line = 'FileNameError';
}

chomp $line;
print $line;