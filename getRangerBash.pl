#!/usr/bin/perl
use strict;


#*******************************************************************************
# UID          PID    PPID  C STIME TTY          TIME CMD
# jens        1077    1048  0 17:27 pts/0    00:00:00 bash
# jens       20630    1077  0 18:28 pts/0    00:00:01 /usr/bin/python /usr/bin/ranger
# jens       20660   20630  0 18:28 pts/0    00:00:00 /bin/bash
# jens       21339   20660  0 18:43 pts/0    00:00:00 perl /home/jens/bin_my/getRangerBash.pl

my $str    = '[\x21-\xff]';
my $strSpc = '[\x20-\xff]';

my $rx  = qr/
              ($str+)
              \s+
              (\d+)
              \s+
              (\d+)
              \s+
              ($str+)
              \s+
              ($str+)
              \s+
              ($str+)
              \s+
              ($str+)
              \s+
              ($strSpc+)
            /x;


#*******************************************************************************
sub main() {
  my $ps   = `ps -f`;
  my @pid  = ();
  my @ppid = ();
  my @cmd  = ();
  my $cmd  = '';

  while ($ps =~ /$rx/g) {
    push(@pid,  $2);
    push(@ppid, $3);
    push(@cmd,  $8);
  }

  for (my $b = 0; $b < @pid; ++$b) {
    next if $cmd[$b] !~ /bash/;
    for (my $r = 0; $r < @pid; ++$r) {
      next if $pid[$b] != $ppid[$r];
      next if $cmd[$r] !~ /ranger/;
      $cmd = $cmd[$r];
      $cmd =~ s/^.+(ranger)/$1/;
      print "bash running: [$cmd]\n";
    }
  }
}


main()
__END__
