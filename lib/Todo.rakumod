use Component;
unit class Todo does Component;

has Str  $.descr;
has Bool $.done = False;

method COERCE(Str $descr) { self.new: :$descr }

method toggle is template-usable {
  $!done = not $!done;
  $.redraw
}
