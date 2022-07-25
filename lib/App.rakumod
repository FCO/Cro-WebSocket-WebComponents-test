use Component;
use TodoList;
unit class App does Component;

has TodoList $.todo-list .= new;

method add(Str $descr) is template-usable['this.parentNode.querySelector(".inputDescription").value', ] {
  LEAVE $.redraw;
  $.todo-list.add: $descr
}
