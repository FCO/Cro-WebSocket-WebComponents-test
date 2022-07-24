use Component;
use Todo;
unit class App does Component;

has Todo() @.todos;

method add(Str $str) is template-usable['this.parentNode.querySelector(".inputDescription").value', ] {
  @!todos.push: $str;
  $.redraw
}