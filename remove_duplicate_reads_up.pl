#!/usr/bin/perl
# Modified by Upendra kumar, Maloof Lab 101411
#(original script: from Ravi Kumar's script remove_duplicate_reads.pl)

#Description: Removes all duplicate reads and keeps only one. Does not remove the reads based on quality and keeps only the first read out of all the duplicate reads.

use strict; use warnings;

die "USAGE:remove_duplicate_reads.pl <fastq file(s)>\n" unless (@ARGV >= 1);
my @fastq_files = @ARGV;

foreach my $file_name (@fastq_files) {
	open (FILE_IN, $file_name);
	my $out_file_name = "$file_name.nodup.fq";
	open (FILE_OUT, ">$out_file_name");
	my %seen = ();
	my $seen_count = 0;
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
		if ($seen{$seq} > 1) {
			$seen_count++;	
			next;
		}
		#next if $seen{$seq} > 1;
		#$seen_count++;	
		my ($readhead,$readseq,$qualhead,$qualseq) = split(/\t/,$readcomb,4);
		print FILE_OUT "$readhead\n$readseq\n$qualhead\n$qualseq\n";     
	}
	print "\tDuplicate read summary:\n";
	print "\t$file_name: \t$seen_count out of $read_count reads\n";
	print "\t\t(Writing w/o duplicates to $out_file_name)\n";
	close (FILE_IN);
	close (FILE_OUT);

}
#print "finished processing file.";
#my $file = shift;