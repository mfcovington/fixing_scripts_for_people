use strict;
use warnings;
use File::Basename;

my @matched_files = `ls $ARGV[0]/*fq.bam`;
my $file_out;

for my $file_matched (@matched_files) {
        (my $prefix, my $path) = fileparse($file_matched, "_matched.fq.bam");
        my $file_unmatched_1 = $path . $prefix . "_1_unmatched.bam";
        my $file_unmatched_2 = $path . $prefix . "_2_unmatched.bam";
        my $file_out = $path . $prefix . ".merged.bam";
        `samtools merge $file_out $file_matched $file_unmatched_1 $file_unmatched_2`;
}

open OUT1, ">$file_out" or die "\n\nCannot open output $file_out\n";

close (OUT1)
