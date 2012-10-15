#!/usr/bin/env perl
# remove_duplicate_reads_up.pl
# (original script: from Ravi Kumar's script remove_duplicate_reads.pl)
# Modified by Upendra kumar, Maloof Lab 101411
# Revised/Fixed by Mike Covington
# created: 2012-05-31
#
# Description: Removes all duplicate reads and keeps only one. Does not remove the reads based on quality and keeps only the first read out of all the duplicate reads.
#
use strict;
use warnings;
use autodie;
use Digest::SHA qw (sha1);
use Data::Dumper;

die "USAGE:remove_duplicate_reads.pl <fastq file(s)>\n" unless (@ARGV >= 1);
my @fastq_files = @ARGV;

foreach my $file_name (@fastq_files) {
	open (FILE_IN, $file_name);
	my $out_file_name = "$file_name.nodup.fq";
	open (FILE_OUT, ">$out_file_name");
    my %seen = ();
    my %seen_sha = ();
    my $seen_count = 0;
    my $seen_count_sha = 0;
	my $read_count = 0;
	while(<FILE_IN>){ 
		my $hdr = ($_);
		chomp $hdr;
		my $seq = <FILE_IN>;
		chomp $seq;
		my $qhdr = <FILE_IN>;
		chomp $qhdr;
		my $qval = <FILE_IN>;
		chomp $qval;
		my $readcomb = $hdr."\t".$seq."\t".$qhdr."\t".$qval;
		#chomp $readcomb;
		#print "$readcomb\n";
		$read_count++;
        $seen{$seq}++;
        $seen_sha{sha1($seq)}++;
        if ($seen{$seq} > 1) {
            print $seq, "\n" if $seen_count == 1;
            print sha1($seq), "\n" if $seen_count == 1;
            $seen_count++;  
            next;
        }
        if ($seen_sha{sha1($seq)} > 1) {
            $seen_count_sha++;
            print 1;
            next;
        }
		#next if $seen{$seq} > 1;
		#$seen_count++;	
		my ($readhead,$readseq,$qualhead,$qualseq) = split(/\t/,$readcomb,4);
		print FILE_OUT "$readhead\n$readseq\n$qualhead\n$qualseq\n";     
	}
    open my $dump,     ">", "dump";
    open my $dump_sha, ">", "dump_sha";
    print $dump Dumper(%seen);
    print $dump_sha Dumper(%seen_sha);
    close $dump;
    close $dump_sha;
	print "\tDuplicate read summary:\n";
    print "\t$file_name: \t$seen_count out of $read_count reads\n";
    print "\t$file_name: \t$seen_count_sha out of $read_count reads\n";
	print "\t\t(Writing w/o duplicates to $out_file_name)\n";
	close (FILE_IN);
	close (FILE_OUT);

}