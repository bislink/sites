package Sites::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use DateTime;
use DateTime::Duration;

my $now = DateTime->now();

# This action will render a template
sub welcome ($self) {

# Open Site File. Not added into git. 

#
my $error = '';
#
my $SITES_FILE = $self->config->{dir}->{main} . "/sites.txt";
my $IP_FILE_01 = $self->config->{dir}->{main} . "/data/ip/01.txt";
#
my @SITES;

my $FILE; 
if ( open($FILE, "<", "$SITES_FILE" ) ) {
  while (my $site = <$FILE>) {
    chomp $site;
    push(@SITES, "$site");
  }
} else {
  $error = "sites file not found";
  push(@SITES, "biz-land.com");
}
close $FILE;

my $IP_FILE; my $IP_01;
if ( open($IP_FILE, "<", "$IP_FILE_01" ) ) {
  $IP_01 = <$IP_FILE>;
  chomp $IP_01;
} else {
  $error = "IP_FILE not found ($IP_FILE, $IP_01)";
}
close $IP_FILE;

# datetime
my %date;

my $out = qq{<table class="table table-striped table-responsive table-hover table-border">}; 

my $serial = '0';
foreach my $SITE (sort @SITES) {
  $serial++ if $SITE;
  # dig 
  my $dig = `dig +short $SITE`;
  chomp $dig;
  # expiry
  my $expiry = `whois $SITE | grep 'Registry Expiry Date' `;
  chomp $expiry ;
  $expiry =~ s!Registry Expiry Date\:!!;
  my ($ymd, $time) = split(/T/, $expiry);
  my ($year, $month, $day) = split(/\-/, $ymd);
  $year =~ s!^\s+$!!g;
  $month =~ s!^\s+$!!g;
  $day =~ s!^\s+$!!g;
  #
  my ($hour, $minute, $second ) = split(/\:/, $time);
  $second =~ s!Z$!!;

  # remove 0 at the beginning 
  $month =~ s!^0!!;
  $day =~ s!^0!!;
  $hour =~ s!^0!!;
  $minute =~ s!^0!!;
  $second =~ s!^0!!;

  my $dig_span;
  if ( $dig eq "$IP_01") { $dig_span = qq{<span class="ns30-ip">$dig</span>}; }
  else { $dig_span = $dig; }

  my $dash_dot = $SITE;
  $dash_dot =~ s!\-!dash!g;
  $dash_dot =~ s!\.!dot!g;

  if ( $year =~ /\d+/ and $month =~ /\d+/ and $day =~ /\d+/ and $hour =~ /\d+/ and $minute =~ /\d+/ and $second =~ /\d+/ ) {
    #$date{"$dash_dot"} = DateTime->new(year => $year, month => $month, day => $day, hour => $hour, minute => $minute );
  }
  
  #$date{"$dash_dot-duration"} = $date{"$dash_dot"}->subtract_datetime($now);

  #my $days = $date{"$SITE-DUR"}->days;

  # final output 
  $out .= qq{
    <tr> 
      <td>$serial</td> 
      <td><a href="//$SITE" title="$dash_dot">$SITE</a></td> 
      <td>$dig_span</td> 
      <td>$year</td> 
      <td>$month</td>
      <td>$day</td>
      <td>$hour</td>
      <td>$minute</td>
      <td>$second</td>
      <td>$date{"$dash_dot"}</td>
    </tr> 
  }; 
}

$out .= qq{</table>};

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Sites!', out => $out, error => qq{$error} );
}

1;
