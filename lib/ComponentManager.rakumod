use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use Cro::WebApp::Template;
unit class ComponentManager;

method new { !!! }
method instance {
  $PROCESS::COMPONENT-LOCK //= Lock.new;
  $ //= self.bless
}

has %.components;

method add($component where { .^can: "id" }) {
  %!components{ $component.id } = $component;
}

method find(Str $id) {
  %!components{ $id }
}

method clean-components-from($supplier) {
  for %!components.kv -> Str $id, $component where { .^can: "remove-supplier" } {
    my $empty = $component.remove-supplier: $supplier;
    %!components{ $id }:delete if $empty
  }
}

sub add-component(Str $name, |c) is export {
  template-part $name, { c }
}

sub component-comm(&block) is export {
  my Supplier $supplier .= new;
  my ComponentManager $manager .= instance;
  $PROCESS::COMPONENT-LOCK.protect: {
    $PROCESS::SUPPLIER = $supplier;
    template-part "prepare-components", { \() }
    block
  }
  get -> "cmd" {
    web-socket :json, -> $incoming, $close {
      supply {
        whenever $close {
          $manager.clean-components-from: $supplier;
        }
        whenever $supplier -> |c {
          emit |c
        }
        whenever $incoming -> $message {
          whenever $message.body -> (:$id, :$method, :@positionals) {
            my $component = $manager.find: $id;
            my Supplier $*SUPPLIER := $supplier;
            $component."$method"(|@positionals)
          }
        }
      }
    }
  }
}
