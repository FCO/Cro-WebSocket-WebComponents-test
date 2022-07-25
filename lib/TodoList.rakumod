use Component;
use Todo;
unit class TodoList does Component;

has Todo @.todos;

method add(Str $descr) {
  LEAVE $.redraw;
  @!todos.push: Todo.new: :$descr, :parent(self)
}

method delete-todo(Str $id) {
  LEAVE $.redraw;
  @!todos .= grep: { .id ne $id };
}

