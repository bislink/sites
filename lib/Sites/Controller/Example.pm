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

  my $dig_span;
  if ( $dig eq '203.161.44.214') { $dig_span = qq{<span class="ns30-ip">$dig</span>}; }
  else { $dig_span = $dig; }

  my $dash_dot = $SITE;
  $dash_dot =~ s!\-!dash!g;
  $dash_dot =~ s!\.!dot!g;

  if ( $year =~ /\d+/ and $month =~ /\d+/ and $day =~ /\d+/ and $hour =~ /\d+/ and $minute =~ /\d+/ and $second =~ /\d+/ ) {
    $date{"$dash_dot"} = qq{DateTime->new(year => $year, month => $month, day => $day, hour => $hour, minute => $minute, second => $second ); };
  }
  
  #$date{"$SITE-DUR"} = $date{"$SITE"}->subtract_datetime($now);

  #my $days = $date{"$SITE-DUR"}->days;

  # final out put 
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
