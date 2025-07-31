#!/usr/bin/perl
#
#
my $f_in = shift;
open(F,"$f_in");
while(<F>){
    chomp;
    my @ar_tmp = split(/\t/,$_);
    my $comb = $ar_tmp[4];
    my $odd = 0;
    my $even = 0;
    foreach $curnum (split(/,/,$comb)){
        if ($curnum % 2) { 
            $odd = 1;
        }else{$even = 1;}
        last if $odd && $even;
    }

    my $type = $odd && $even? "ALL"
            :$odd ? "DEL"
            :"DUP";
    my $freq = $ar_tmp[3]/(($#ar_tmp-4)/2);
    $freq = sprintf "%.5f", $freq;
    print $ar_tmp[0]."\t".$ar_tmp[1]."\t".$ar_tmp[2]."\t".$type."\t".$freq."\n";
}
close(F);
