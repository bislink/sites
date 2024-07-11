package Sites::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

my @SITES=('a1z.us', 'biz-land.com', 'bizzland.com', 'bislinks.com', 'a2z.red', 'books66.com', 'biblewhat.com', 
'bizzland.in', 'bizland.uk', 'bizland.asia', 'preachword.com', 'books66.com', 'mroshni.com', 'msneha.com', 
'sumu.uk', 'sumu.in', 'sirsumu.com', 'sumu.name', 'sumu.dev', 'biz-land.in');

my $out = qq{<table class="table table-striped table-responsive table-hover">}; 

my $serial = '0';
foreach my $SITE (sort @SITES) {
  $serial++ if $SITE;
  my $dig = `dig +short $SITE`;
  $out .= qq{<tr> <td>$serial</td> <td>$SITE</td> <td>$dig</td> </tr> }; 
}

$out .= qq{</table>};

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Sites!', out => $out);
}

1;
