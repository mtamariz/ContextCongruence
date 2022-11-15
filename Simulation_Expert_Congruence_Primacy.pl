#!/usr/bin/env perl

#### #### #### #### #### #### #### ##
####  MONICA TAMARIZ Sept 2022  ####
####  Parameter estimation for Congruence Study
####  Three parameters:
####     ExpertBias, preference for Expert (E) over Peer (P))
####     Congruence Bias: preference for variant produced in the same context as it was learned Congruent (C) or Incongruent (I)
####     Primacy or Recency effects
####       usage: Simulation_Expert_Congruence_Primacy.pl N    (N= number of times the simulation will be run, e.g. 1000 or 5000)
#### #### #### #### #### #### #### #

$REPE = shift @ARGV;

open(OUT, ">>OutputBootstrap_Primacy")	or die "Can't open > output.txt: $!";

print OUT "Repetitions\tExpertBias\tCongrBias\tPrimacyBias\tPeerBias\tIncongrBias\tRecencyBias\tCountApprox\tCountVerid\n";

for(my $ExpertBias = .4; $ExpertBias <= 1; $ExpertBias += .05){  # test every value of Expert/Peer influence (PARAM)
  for(my $CongrBias = .4; $CongrBias <= 1; $CongrBias += .05){   # and every value of congruence influence (PARAM)
    for(my $PrimacyBias = .6; $PrimacyBias <= .66; $PrimacyBias += .025){  # test every value of primacy/recency effect (PARAM)
      $count = 0;   # undefine the number of veridical results with this parameter combination
      
      ####  Get the param values in a printable form
      $ExpertBias= sprintf("%.2f",  $ExpertBias);
      $CongrBias = sprintf("%.2f", $CongrBias);
      $PrimacyBias= sprintf("%.3f",  $PrimacyBias);
      my $PeerBias = sprintf("%.2f",  (1-$ExpertBias));
      my $IncongrBias = sprintf("%.2f", (1-$CongrBias));
      my $RecencyBias = sprintf("%.3f", (1-$PrimacyBias));
      
      ####  Apply the param values to each condition combination
      $E1C = sprintf("%.0f",   $ExpertBias * $CongrBias * $PrimacyBias * 100);   # transmitted Expert->Novice in congrouous ctxt, w/primacy bias. Verid = 12
      $E1I = sprintf("%.0f",  $ExpertBias * $IncongrBias * $PrimacyBias * 100);  # transmitteed Expert->Novice in incongrouous ctxt, w/primacy bias. Verid = 6
      $P1I = sprintf("%.0f",  $PeerBias * $IncongrBias * $PrimacyBias * 100);    # transmitteed Peer->Peer in incongrours ctxt w/primacy bias. Verid = 2
      $P1C = sprintf("%.0f",  $PeerBias * $CongrBias * $PrimacyBias * 100);      # transmitteed Peer->Peer in congrours ctxt w/primacy bias. Verid = 10   
      $E2C = sprintf("%.0f",   $ExpertBias * $CongrBias * (1-$PrimacyBias) * 100);   # transmitted Expert->Novice in congrouous ctxt, w/recency bias. Verid = 15
      $E2I = sprintf("%.0f",  $ExpertBias * $IncongrBias * (1-$PrimacyBias) * 100);  # transmitteed Expert->Novice in incongrouous ctxt, w/recency bias. Verid = 8
      $P2I = sprintf("%.0f",  $PeerBias * $IncongrBias * (1-$PrimacyBias) * 100);    # transmitteed Peer->Peer in incongrours ctxt w/recency bias. Verid = 1
      $P2C = sprintf("%.0f",  $PeerBias * $CongrBias * (1-$PrimacyBias) * 100);      # transmitteed Peer->Peer in congrours ctxt w/recency bias. Verid = 8   
      ##print "Biases applied: EB=$ExpertBias\tCB=$CongrBias\t1B=$PrimacyBias\t\tPB=$PeerBias\tIB=$IncongrBias\t2B=$RecencyBias\n";
      ##print "Prop expected with these bias values: E1C=$E1C\tE1I=$E1I\tP1I=$P1I\tP1C= $P1C\t\tE2C=$E2C\tE2I=$E2I\tP2I=$P2I\tP2C=$P2C\n";
      undef $newstore;
      for $t (0..$REPE){
	
	#print "\n$EC, $PI, $EI, $PC\t";
	#print "roulette($EC,$PI)\troulette($EI,$PC)";
	
	######################################
	## 1. Simulate the Transmit to EXPERT condition (in our study we had 30 partic in this condition)
	for $e (0..29){                        # 30 = number of participants in the Transmit to EXPERT condition
	  #print "\tparticipant E: $e\n";
	  $choose = roulette( $E1C, $P1I, $E2C, $P2I);
	  push(@vars, $choose);
	}
	#print "\tA1: @vars\t";
	$outE1C = countelem(0,@vars);  ## nr times EXPERT variant was produced in this simulation in the Transmit to Expert condition (congr), and Expert was seen First
	$outP1I =countelem(1,@vars);      ## nr times PEER variant was produced in this simulation in the Transmit to Expert condition (incongr), and Expert was seen First
	$outE2C = countelem(2,@vars);  ## nr times EXPERT variant was produced in this simulation in the Transmit to Expert condition (congr), and Expert was seen First
	$outP2I = countelem(3,@vars);      ## nr times PEER variant was produced in this simulation in the Transmit to Expert condition (incongr), and Expert was seen First
	undef @vars;
	#print "\n\toutcounts1 - $outE1C,$outP1I,$outE2C,$outP2I\t";
	
	######################################
	## 2. Simulate the Transmit to PEER condition (in our study we had 32 partic in this condition)
	for $p (0..31){                        # 32 = number of participants in the Transmit to PEER condition
	  #print "\nparticipant P: $p\n";
	  $choose = roulette( $P1C, $E1I, $P2C, $E2I);
	  push(@vars2, $choose);
	}
	#print "\tA2: @vars2\t";
	#print "\n$t\tOUTEC:$outEC\tOUTPI:$outPI\t";
	
	$outP1C = countelem("0",@vars2);  ## nr times PEER variant was produced in this simulation in the Transmit to Peer condition (congr), and Expert was seen Second
	$outE1I = countelem("1",@vars2);      ## nr times EXPERT variant was produced in this simulation in the Transmit to Peer condition (incongr), and Expert was seen Second
	$outP2C = countelem("2",@vars2);  ## nr times PEER variant was produced in this simulation in the Transmit to Peer condition (congr), and Expert was seen Second
	$outE2I = countelem("3",@vars2);      ## nr times EXPERT variant was produced in this simulation in the Transmit to Peer condition (incongr), and Expert was seen Second
	undef @vars2;
	#print "\toutcounts2 - $outP1C,$outE1I,$outP2C,$outE2I\n";
	
	######################################
	## 3. Check if the results of this simulation are the same as in our study
	# VERIDICAL VALUES
	$vE1C  = 12;
	$vE1I = 6;
	$vP1I = 2;
	$vP1C = 10;
        $vE2C = 15;
	$vE2I = 8;
	$vP2I = 1;
	$vP2C = 8; 
	
	#Margin:
	$margin = 1;
	
	#Upper limits
	$vE1C_u  = $vE1C + $margin;
	$vE1I_u  = $vE1I + $margin;
	$vP1I_u  = $vP1I + $margin;
	$vP1C_u  = $vP1C + $margin;
        $vE2C_u = $vE2C + $margin;
	$vE2I_u  = $vE2I + $margin;
	$vP2I_u  = $vP2I + $margin;
	$vP2C_u  = $vP2C + $margin;
	
	# Lower limits
	$vE1C_l = $vE1C - $margin;
	$vE1I_l  = $vE1I - $margin;
	$vP1I_l  = $vP1I - $margin;
	$vP1C_l  = $vP1C - $margin;
        $vE2C_l = $vE2C - $margin;
	$vE2I_l  = $vE2I - $margin;
	$vP2I_l  = $vP2I - $margin;
	$vP2C_l  = $vP2C - $margin;
	
#	print "$t\t$outE1C-$outE1I-$outP1I-$outP1C-$outE2C-$outE2I-$outP2I-$outP2C\n";
	$out1 = 0; 

	if ($outE1C >= $vE1C_l and $outE1C <= $vE1C_u) {
	  $out1++;
#	  print " 1 YES ($vE1C_u < $outE1C < $vE1C_l) \t\t$out1 \n";
	}
	if ($outE1I >= $vE1I_l and $outE1I <= $vE1I_u) {
	  $out1++;
#	  print " 2 YES ($vE1I_u < $outE1I < $vE1I_l) \t\t$out1 \n";
	}	
	if ($outP1I >= $vP1I_l and $outP1I <= $vP1I_u) {
	  $out1++;
#	  print " 3 YES ($vP1I_u < $outP1I < $vP1I_l) \t\t$out1 \n";
	}
	if ($outP1C >= $vP1C_l and $outP1C <= $vP1C_u) {
	  $out1++;
#	  print " 4 YES ($vP1C_u < $outP1C < $vP1C_l) \t\t$out1 \n";
	}
	if ($outE2C >= $vE2C_l and $outE2C <= $vE2C_u)  {
	  $out1++;
#	  print " 5 YES ($vE2C_u < $outE2C < $vE2C_l) \t\t$out1 \n";
	}
	if ($outE2I >= $vE2I_l and $outE2I <= $vE2I_u) {
	  $out1++;
#	  print " 6 YES ($vE2I_u < $outE2I < $vE2I_l) \t\t$out1 \n";
	}
	if ($outP2I >= $vP2I_l and $outP2I <= $vP2I_u) {
	  $out1++;
#	  print " 7 YES ($vP2I_u < $outP2I < $vP2I_l) \t\t$out1 \n";
	}
	if ($outP2C >= $vP2C_l and $outP2C <= $vP2C_u) {
	  $out1++;
#	  print " 8 YES ($vP2C_u < $outP2C < $vP2C_l) \t\t$out1 \n";
	}
	if($out1 eq 8){
	  $count++;
#	  print " \t\t\t\t\tYES $count \n";
	}

	#print "ExpBias =\t$ExpertBias\tCongrBias =\t$CongrBias\tPeerbias =\t$PeerBias\tIncongrBias =\t$IncongrBias\tcountverid =\t$count";
	#print "\t$ExpertBias\t$CongrBias\t$PrimacyBias\t$PeerBias\t$IncongrBias\t$RecencyBias\t$out1\t$out2\t$count\n";
	$out2 = $newstore + $out1;	
	$newstore = $out2;
      }
	print OUT "$REPE\t$ExpertBias\t$CongrBias\t$PrimacyBias\t$PeerBias\t$IncongrBias\t$RecencyBias\t$out2\t$count\n";
    }
  }
}



  ########################  SUBROUTINES

sub noise{
  my $a = shift;
  @noise = (-3,-2,-2,-1,-1,-1,0,0,0,0,0,0,1,1,1,2,2,3);
  my $add = random_integ($#noise+1);
  $rett = $a + $noise[$add];
  return $rett;
}

sub random_integ {
	$nn = shift;
	$n = rand ($nn+1);
	($aa, $bb) = split /\./, $n;
	return $aa;
}


sub sumarray {                  # INPUT: array; returns sum of elements
        @inn = @_;
        $store = 0;
        for $i(0..$#inn){
                $su = $store + $inn[$i];
                $store = $su;
        }
        return $su;  
}

sub roulette{   #input = an array of integers representing the probability of a variant e.g. (1,4) means that the second mumber (1) is 4 times more likely to be drawn than the first one (0); output: a variant chosen according to its probability || the index of the input array corresponding to the variant chosen
  my @array = @_;
  $rrrr = sumarray(@array) - 1;
  $rrrrr = random_integ($rrrr);
  my $a = 0;
  my $accum = 0;
  for $a(0..$#array) { 
    $accum = $accum + $array[$a];
    if($rrrrr < $accum){
  #    return $array[$a];     # return the variant
      return $a;              # return the index
    }
  }			 
}


sub print_array{
  my @array = @_;
  for $a(0..$#{@array}){
    for $b(0..$#{$array[$a]}){   
      if ($array[$a][$b] =~ /\w/){
	print   "($a,$b)$array[$a][$b]\t";
      }
    }
    print "\n";
  }
}
  
  
sub countelem{    # input: a value and then an array; counts the nr of times the element is in the array
  $sum = 0;
  my $elem = shift;
  my @array = @_;
  for $index(0..$#array){
    if ($array[$index] eq $elem){
       $sum++;
    }
  }
  return $sum;  
}


sub prob {			# input: array of raw cooccurrence counts. Returns list turned into probability distribution
	@inp = @_;
	@ne = ();
	$suma = sumarray(@_);
	for $i(0..$#inp){
		if ($inp[$i] == 0){
			$ne[$i] = 0;
		}
		else {
			$ne[$i] = sprintf("%.2f",$inp[$i]/$suma);
		}
	}
	return @ne;
}
