use UUID;
use JSON::Fast;
use Cro::WebApp::Template;
use ComponentManager;
unit role Component;

has Str() $.id = UUID.new;
has IO()  $.template = "resources/{ self.^name.lc }.crotmp";

has Str() %!ids;
has %!suppliers is SetHash;

method FALLBACK(Str $name where .starts-with: "id-for-" ) { %!ids{ $name } //= UUID.new }

method Str { $.render }
method TWEAK(|) { ComponentManager.instance.add: self }

method render {
  my $*COMPONENT-RENDERING = True;
  %!suppliers{ $*SUPPLIER } = True;
  qq:to/EOT/;
  <div id="component-{ $!id }">
    { render-template $.template, self }
  </div>
  EOT
}

method redraw {
  for %!suppliers.keys {
    .emit: %(
      :$.id,
      :html($.render)
    )
  }
}

multi trait_mod:<is>(Method $m, Bool :$template-usable where { .so }) is export {
  trait_mod:<is>($m, :template-usable[])
}

multi trait_mod:<is>(Method $m, :@template-usable) is export {
  $m.wrap: my method (|c) {
    with $*COMPONENT-RENDERING {
      qq|let positionals = [ { @template-usable.join: ", " } ]; window.ws.send(JSON.stringify(\{ "id": "$.id", "method": "{ $m.name }", positionals }))|
    } else {
      nextsame
    }
  }
}
