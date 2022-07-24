use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;
unit class ComponentManager;

method new { !!! }
method instance { $ //= self.bless }

has %.components;

method add($component where { .^can: "id" }) {
  %!components{ $component.id } = $component;
}

method find(Str $id) {
  %!components{ $id }
}

sub add-component(Str $name, $component) is export {
  template-part $name, { \($component) }
}

sub component-comm is export {
  my ComponentManager $manager .= instance;
  template-part "prepare-components", { \() }
  get -> "cmd" {
      web-socket :json, -> $incoming, $close {
          supply {
               whenever $incoming -> $message {
                  whenever $message.body -> (:$id, :$method, :@positionals) {
                      my $component = $manager.find: $id;
                      $component."$method"(|@positionals)
                  }
               }
          }
      }
  }
}
