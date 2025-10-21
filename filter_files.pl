#!/usr/bin/perl
use strict;
use warnings;

# Read from STDIN or file arguments
while (my $line = <>) {
    chomp $line;
    
    # Skip empty lines
    next if $line =~ /^\s*$/;
    
    # Check if the line does NOT end with .usdz or .png (case insensitive)
    if ($line !~ /\.(usdz|png)$/i) {
        print "$line\n";
    }
}
