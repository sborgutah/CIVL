#!/usr/bin/perl
use strict;
use warnings;

my $line_d = "";
my $filename = "filelist.txt";
open(READ,$filename) or die "cannot open $filename";
while (my $file = <READ>) {
    
    #_ Printing time
    chomp($file);
    my ($name,$log) = split("_log",$file);
    print"$name,";
    chdir "Default_CIVL/";
    open(DE,$file) or die "cannot open $file in DE";
    while (my $line = <DE>) {
        if ($line =~ /time \(s\)/) {
            my ($part1,$part2) = split(/: /,$line);
            chomp($part2);
            print "$part2,";
        }
    }
    close(DE);
    chdir "../Context_Bound/";
    open(CB,$file) or die "cannot open $file in CB";
    while (my $line = <CB>) {
        if ($line =~ /time \(s\)/) {
            my ($part1,$part2) = split(/: /,$line);
            chomp($part2);
            print "$part2,";
        }
    }
    close(CB);
    chdir "../.";


    #_ Printing state
    chdir "Default_CIVL/";
    open(DE,$file) or die "cannot open $file in DE";
    while (my $line = <DE>) {
        if ($line =~ /states    /) {
            my ($part1,$part2) = split(/: /,$line);
            chomp($part2);
            print "$part2,";
        }
    }
    close(DE);
    chdir "../Context_Bound/";
    open(CB,$file) or die "cannot open $file in CB";
    while (my $line = <CB>) {
        if ($line =~ /states    /) {
            my ($part1,$part2) = split(/: /,$line);
            chomp($part2);
            print "$part2,";
        }
    }
    close(CB);
    chdir "../.";


    #_ Printing Property Holds (yes/no)
    chdir "Default_CIVL/";
    my $new_bound = 0;
    my $new_bound_found = 0;
    open(DE,$file) or die "cannot open $file in DE";
    while (my $line = <DE>) {
        if ($line =~ /New_Bound/) {
            $new_bound_found = 1;
            my ($part1,$part2) = split("= ",$line);
            chomp($part2);
            $new_bound = $part2;
        }
        if ($line_d =~ /=== Result ===/) {
            if ($line =~ /properties hold/) {
               print "Yes,";
            }
            elsif ($line =~ /MAY NOT/) {
                print "Violation Found";
                if ($new_bound_found == 1) {
                    print "(Bound = $new_bound),";
                }
                else {
                    print "(Bound = 0),";
                }
            }
            else {
                print "Erroneous Log,";
            }
        }
        $line_d = $line;
    }
    close(DE);
    
    $new_bound = 0;
    $new_bound_found = 0;
    chdir "../Context_Bound/";
    open(CB,$file) or die "cannot open $file in CB";
    while (my $line = <CB>) {
        if ($line =~ /New_Bound/) {
            $new_bound_found = 1;
            my ($part1,$part2) = split("= ",$line);
            chomp($part2);
            $new_bound = $part2;
        }

        if ($line_d =~ /=== Result ===/) {
            if ($line =~ /properties hold/) {
               print "Yes\n";
            }
            elsif ($line =~ /MAY NOT/) {
                print "Violation Found";
                if ($new_bound_found) {
                    print "(Bound = $new_bound)\n";
                }
                else {
                    print "(Bound = 0)\n";
                }
            }
            else {
                print "Erroneous Log\n";
            }
        }
        $line_d = $line;
    }
    close(CB);
    chdir "../.";

}
print "\n";
close(READ);       

