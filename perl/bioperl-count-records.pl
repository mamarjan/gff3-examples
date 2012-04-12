#!/usr/bin/env perl


use Bio::GFF3::LowLevel::Parser;

my $p = Bio::GFF3::LowLevel::Parser->new( "$ARGV[0]" );

$counter = 0;
 
while( my $i = $p->next_item ) {
 
    if( exists $i->{seq_id} ) {
        $counter = $counter + 1;
        ## $i is a feature in the same format as returned by
        ## Bio::GFF3::LowLevel::gff3_parse_feature.  do something with
        ## it
    }
    elsif( $i->{directive} ) {
        if( $i->{directive} eq 'FASTA' ) {
            my $fasta_filehandle = $i->{filehandle};
            ## parse the FASTA in the filehandle with BioPerl or
            ## however you want.  or ignore it.
        }
        elsif( $i->{directive} eq 'gff-version' ) {
          #print "it says it is GFF version $i->{value}\n";
        }
        elsif( $i->{directive} eq 'sequence-region' ) {
          #    print( "found a sequence-region, sequence $i->{seq_id},",
          #         " from $i->{start} to $i->{end}\n"
          #       );
        }
    }
    elsif( $i->{comment} ) {
        ## this is a comment in your GFF3 file, in case you want to do
        ## something with it.
        #print "that comment said: '$i->{comment}'\n";
    }
    else {
      #die 'this should never happen!';
    }
 
}

print "There are $counter records in the file.\n"

