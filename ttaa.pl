#!/usr/bin/perl
use strict;

my %g_xml = ();
my %g_e   = ();
my %g_rx  = ();
my %g_a   = ();


#*******************************************************************************
sub getOptions() {
  $g_a{'test'}   = 0;
  $g_a{'prtOff'} = 0;
  # $g_a{'prt'} = 0;
}

#*******************************************************************************
sub initializeRegex() {
  my $C = '[\x00-\xff]';

  my $rxHead = qr / <\?xml \s /x;

  $g_rx{'cXmlAA'} = qr/
                        $rxHead
                          ($C*?)
                        (?= $rxHead | \Z)
                      /x;
  $g_rx{'c2KeyVal'} = qr/ <string \s name="([^"]+)">([^<]*) /xm;
  $g_rx{'cLon'}     = qr/ ; \s* (-? \d{7,9}) \) /x;
  $g_rx{'cLat'}     = qr/ \( (-? \d{6,8}) \s* ; /x;
}

#*******************************************************************************
sub printHeader() {
  print "Remark\tLongitude\tLatitude\tLabel\tLocktype";
  print "\tOffset" if $g_a{'prtOff'};
  print"\n";
}

#*******************************************************************************
sub getData(\$) { my ($rBytes) = @_;
  while ($$rByte =~ /$g_rx{'c2KeyVal'}/g) {
    $g_xml{$1} = $2;
  }
}

#*******************************************************************************
sub printEntry() {
  print "$g_e{'rem'}\t$g_e{'lon'}\t$g_e{'lat'}\t$g_e{'lbl'}\t$g_e{'lct'}";
  print "\t$g_e{'off'}" if $g_a{'prtOff'};
  print"\n";

  # Flush entry.
  %g_e = ();
}

#*******************************************************************************
sub collectAndPrintEntries2() { my ($rBytes) = @_;
  my $tmp = '';

  # Loop through sorted keys and assemble an entry to print.
  foreach my $key (sort keys %g_xml) {
    $tmp = $g_xml{$key} if $key =~ //i;
    printEntry() if defined $g_e{'rem'};
    $g_e{'rem'} = $tmp;

    $tmp = $g_xml{$key} if $key =~ /UserPos/i;
    printEntry() if defined $g_e{'lon'};
    ($g_e{'lon'}) = $tmp =~ $g_rx{'cLon'};
    ($g_e{'lat'}) = $tmp =~ $g_rx{'cLat'};

    $tmp = $g_xml{$key} if $key =~ /UserName/i;
    printEntry() if defined $g_e{'lbl'};
    $g_e{'lbl'} = $tmp;

    $tmp = $g_xml{$key} if $key =~ /LockType/i;
    printEntry() if defined $g_e{'lct'};
    $g_e{'lct'} = $tmp;
  }
}

#*******************************************************************************
sub collectAndPrintEntries1() { my ($rBytes) = @_;
  my $tmp = '';
  my @g_entry = ();

  # Loop through sorted keys and assemble an entry to print.
  foreach my $key (sort keys %g_xml) {
    push(@g_entry, $g_xml{$key}); # ???
  }
}


#*******************************************************************************
sub main() {
  my $data  = '';
  my $bytes = '';

  getOptions();
  initializeRegex();

  $/ = undef;
  while ($data = <>) {
    while ($data =~ /$g_rx{'cXmlAA'}/g) {
      $bytes = $1
      getData($bytes);
      collectAndPrintEntries2();
    }
  }
}


main();
__END__