#!/usr/bin/perl
use strict;
use warnings;


# --- INITIALISATION & INPUTS
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# --- Location
my $workdir  = `pwd`;
my $home = `echo \$HOME`;
chomp($home);
my $jorekdir = $home."/jorek";
my $jorekexe = "jorek_model303";
my $jorek2vtk= "jorek2vtk";

# --- Target values for optimisation and input parameters for scan
my $target_current = 4.6; # [MA]
my @rho_width_scan      = (0.08, 0.02);
my @rho_position_scan   = (0.96, 0.99);
my @T_width_scan        = (0.0577426, 0.02);
my @T_position_scan     = (0.947335, 0.985);
my @boot_amplitude_scan = (-0.35,-0.4);
my @boot_width_scan     = (0.07,0.03);
my @boot_position_scan  = (0.92,0.98);
 

# --- Arguments
my $n_arg = $#ARGV + 1;
if ($n_arg != 2)
{
  print "expecting two arguments: input and output files...\n";
  exit(0);
}
my @my_args = ();
foreach my $a(@ARGV)
{
  push @my_args, $a;
}

my @split_tmp = ();
my $command = "";


#my $LD_LIBRARY_PATH = $ENV{"LD_LIBRARY_PATH"};
#my @LD_PATHS = split(":",$LD_LIBRARY_PATH);
#my $new_path = $LD_PATHS[1];
#foreach my $i (2 .. $#LD_PATHS)
#{
#  $new_path = $new_path.":".$LD_PATHS[$i];
#}
#$ENV{"LD_LIBRARY_PATH"} = $new_path;

# --- PREPROCESSING
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# --- Normal Preprocessing
#my $command = "dprepro ".$my_args[0]." injt60sa.template injt60sa.in";
#`$command`;

# --- Tweaked Preprocessing
# --- Get dakota sample values
$command = "dprepro ".$my_args[0]." get_dakota_input.template get_dakota_input";
`$command`;
my $dakota_values_tmp = `cat get_dakota_input`;
my @dakota_values = split(/\s+/,$dakota_values_tmp);
my $scan_or_equi = 'equi';
open(FILE,"injt60sa.template");
if (grep{/CHANGE_RHO4/} <FILE>) {$scan_or_equi = 'scan';}
close FILE;
# --- Inf we are doing the gradient scan
if ($scan_or_equi eq 'scan')
{
  my $average_for_boot = ($dakota_values[0] + $dakota_values[1]) / 2.0;
  push @dakota_values, $average_for_boot;
  # --- Produce a scan of pedestal width and positions based on these values
  my $rho_width  = $rho_width_scan[0]  + $dakota_values[0] * ($rho_width_scan[1]  - $rho_width_scan[0]);
  my $T_width    = $T_width_scan[0]    + $dakota_values[1] * ($T_width_scan[1]    - $T_width_scan[0]);
  my $boot_width = $boot_width_scan[0] + $dakota_values[2] * ($boot_width_scan[1] - $boot_width_scan[0]);
  my $rho_position   = $rho_position_scan[0]  + $dakota_values[0] * ($rho_position_scan[1]  - $rho_position_scan[0]);
  my $T_position     = $T_position_scan[0]    + $dakota_values[1] * ($T_position_scan[1]    - $T_position_scan[0]);
  my $boot_position  = $boot_position_scan[0] + $dakota_values[2] * ($boot_position_scan[1] - $boot_position_scan[0]);
  my $boot_amplitude = $boot_amplitude_scan[0] + $dakota_values[2] * ($boot_amplitude_scan[1] - $boot_amplitude_scan[0]);
  # --- Produce the input file
  `cp injt60sa.template injt60sa.in`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_RHO4 -new $rho_width";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_RHO5 -new $rho_position";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_T4 -new $T_width";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_T5 -new $T_position";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_FF6 -new $boot_amplitude";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_FF7 -new $boot_position";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string CHANGE_FF8 -new $boot_width";
  `$command`;
# --- Inf we are doing the equilibrium optimisation
}else
{
  # --- Produce a scan of pedestal width and positions based on these values
  my $FF_coef1 = $dakota_values[0];
  my $FF_coef2 = -1.0 - $FF_coef1 - 0.2;
  my $FF_coef6 = $dakota_values[1];
  # --- Produce the input file
  `cp injt60sa.template injt60sa.in`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string \'FF_coef\\(1\\) =\' -new \'FF_coef(1) = $FF_coef1 !\'";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string \'FF_coef\\(2\\) =\' -new \'FF_coef(2) = $FF_coef2 !\'";
  `$command`;
  $command = "/usr/local/bin/my_change_file.perl -file injt60sa.in -string \'FF_coef\\(6\\) =\' -new \'FF_coef(6) = $FF_coef6 !\'";
  `$command`;
}


# --- EXECUTION
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# --- Execute Jorek code
my $exec = "/jorek_working_dir/jorek/".$jorekexe;
$command = $exec." < injt60sa.in > jorek_output.txt 2> tmp.out";
`$command`;
my $jorek_output = `cat jorek_output.txt`;

# --- Execute Jorek post-proc
$exec = "/jorek_working_dir/jorek/".$jorek2vtk;
$command = $exec." < injt60sa.in > jorek_postproc.txt 2> tmp.out";
`$command`;
my $jorek_postproc = `cat jorek_postproc.txt`;
 


# --- POSTPROCESSING
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

@split_tmp = split("current          :",$jorek_output);
@split_tmp = split("\n",$split_tmp[1]);
@split_tmp = split("MA",$split_tmp[0]);
#my $current = abs($split_tmp[0] - $target_current);
my $current = abs($split_tmp[0]);

@split_tmp = split("bootstrap analysis, max of j and jb:",$jorek_postproc);
@split_tmp = split("\n",$split_tmp[1]);
@split_tmp = split(/\s+/,$split_tmp[0]);
my $j_edge = abs($split_tmp[1]);
my $j_boot = abs($split_tmp[2]);

my $combined = ($current-$target_current)**2/$target_current**2 + ($j_edge-1.2*$j_boot)**2/(1.2*$j_boot)**2;

my $output = sprintf("%21s%17.15e f", "", $combined);
$command = "echo \"".$output."\" > ".$my_args[1];
`$command`;





# --- Reset Dakota lib path
#$ENV{"LD_LIBRARY_PATH"} = $LD_LIBRARY_PATH;
