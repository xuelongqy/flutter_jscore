import 'dart:ffi';

/// JSContextGroupRef A group that associates JavaScript contexts with one another. Contexts in the same group may share and exchange JavaScript objects.
class JSContextGroup {
  /// C pointer
  final Pointer pointer;

  JSContextGroup(this.pointer);
}