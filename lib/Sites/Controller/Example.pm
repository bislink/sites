package Sites::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

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
}
close $FILE;

my $out = qq{<table class="table table-striped table-responsive table-hover">}; 

my $serial = '0';
foreach my $SITE (sort @SITES) {
  $serial++ if $SITE;
  # dig 
  my $dig = `dig +short $SITE`;
  # expiry
  my $expiry = `whois $SITE | grep 'Registry Expiry Date' `;
  chomp $expiry ;
  $expiry =~ s!Registry Expiry Date\:!!;
  # final out put 
  $out .= qq{<tr> <td>$serial</td> <td>$SITE</td> <td>$dig</td> <td>$expiry</td> </tr> }; 
}

$out .= qq{</table>};

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Sites!', out => $out, error => qq{$error} );
}

1;
