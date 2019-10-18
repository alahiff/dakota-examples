#!/usr/bin/perl
use strict;
use warnings;
use Cwd;


# --- INITIALISATION & INPUTS
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# --- Target values for optimisation and input parameters for scan
my $target_current = 4.6; # [MA]
my @rho_width_scan      = (0.08, 0.02);
my @rho_position_scan   = (0.96, 0.99);
my @T_width_scan        = (0.0577426, 0.02);
my @T_position_scan     = (0.947335, 0.985);
my @boot_amplitude_scan = (-0.35,-0.4);
my @boot_width_scan     = (0.07,0.03);
my @boot_position_scan  = (0.92,0.98);
 
my $command = "";

# --- Arguments
my $n_arg = $#ARGV + 1;
if ($n_arg != 3)
{
   print "expecting three arguments: the two parameters and the input template...\n";
   exit(0);
}

# --- PREPROCESSING
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

# --- Tweaked Preprocessing
# --- Get dakota sample values
my @dakota_values = ($ARGV[0], $ARGV[1]);
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
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_RHO4 -new $rho_width";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_RHO5 -new $rho_position";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_T4 -new $T_width";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_T5 -new $T_position";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_FF6 -new $boot_amplitude";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_FF7 -new $boot_position";
`$command`;
$command = "my_change_file.perl -file $ARGV[2] -string CHANGE_FF8 -new $boot_width";
`$command`;
