#!/usr/bin/env perl

#### #### #### #### #### #### #### ##
####  MONICA TAMARIZ Sept 2022  ####
####  Parameter estimation with Expert Bias and Congruent Bias
#### #### #### #### #### #### #### #
print "ExpertBias\tCongrBias\tPeerBias\tIncongrBias\tCountverid\n";

for(my $ExpertBias = 0; $ExpertBias <= 1; $ExpertBias += .01){  # test every value of source influence (PARAM)
  for(my $CongrBias = 0; $CongrBias <= 1; $CongrBias += .01){   # and every value of congruence influence (PARAM)
    $count = 0;   # undefine the number of veridical results with this parameter combination

    ####  Get the proportions of each variant for this param combination 
    $ExpertBias= sprintf("%.2f",  $ExpertBias);
    $CongrBias = sprintf("%.2f", $CongrBias);
    my $PeerBias = sprintf("%.2f",  (1-$ExpertBias));
    my $IncongrBias = sprintf("%.2f", (1-$CongrBias));

    $EC = sprintf("%.0f",   $ExpertBias * $CongrBias * 100);      # in or study, 27
    $EI = sprintf("%.0f",  $ExpertBias * $IncongrBias * 100);    # in our study, 14
    $PI = sprintf("%.0f",  $PeerBias * $IncongrBias * 100);     # in our study, 3
    $PC = sprintf("%.0f",  $PeerBias * $CongrBias * 100);      # in our study, 18
   
    for $t (0..1000){      # nr of simulation runs

      for $e (0..29){                        # 30 = number of participants in the Transmit to EXPERT condition in our study
	$choose = roulette($PI, $EC);
	push(@vars, $choose);                   ## @vars is the array containing the productions of the expert variant (1) and the peer variant (0) in this game, in the "transmit to EXPERT" condition
      }
      $outEC = sumarray(@vars);  ## number of times the EXPERT variant was produced in this simulation of the experiment, in the Transmit to Expert condition
      $outPI = 30 - $outEC;      ## number of times the PEER variant was produced in this simulation of the experiment, in the Transmit to Expert condition      
      undef @vars;

      for $p (0..31){                        # 32 = number of participants in the Transmit to PEER condition in our study
	$choose = roulette($PC, $EI);
	push(@vars2, $choose);                   ## @vars2 is the array containing the productions of the expert variant (1) and thepeer variant (0) in this game, in the "transmit to EXPERT" condition
	
      }
      $outEI = sumarray(@vars2);  ## number of times the EXPERT variant was produced in this simulation of the experiment, in the Transmit to Peer (incongruous) condition
      $outPC = 32 - $outEI;     ## number of times the PEER variant was produced in this simulation of the experiment, in the Transmit to Peer (congruous)  condition
      undef @vars2;

      if ($outEC eq 27){       # check if all values obtained in the simulation match the experimental values 
	if ($outEI eq 14){
	  if ($outPI eq 3){
	    if ($outPC eq 18){
	      $count++; 
	    }
	  }
	}
      }      
    }
    print "$ExpertBias\t$CongrBias\t$PeerBias\t$IncongrBias\t$count\n";
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
