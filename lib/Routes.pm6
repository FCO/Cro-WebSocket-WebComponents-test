use Cro::HTTP::Router;
use Cro::WebApp::Template;
use ComponentManager;
use App;
use TodoList;

sub routes() is export {
    route {
        component-comm {
            add-component 'todos-app', App, TodoList.new;

            get -> {
                template 'resources/index.crotmp', {}
            }
        }
    }
}
