use Component;
unit class Todo does Component;

has Str       $.descr;
has Bool      $.done = False;
has Component $.parent is required;

method toggle is template-usable {
  LEAVE $.redraw;
  $!done = not $!done
}

method delete is template-usable {
  $!parent.delete-todo: $!id
}
