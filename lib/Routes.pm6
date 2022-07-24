use Cro::HTTP::Router;
use Cro::WebApp::Template;
use ComponentManager;
use App;

sub routes() is export {
    route {
        component-comm;

        add-component 'todos-app', App.new(:todos<bla ble bli>);

        get -> {
            template 'resources/index.crotmp', {}
        }

    }
}
