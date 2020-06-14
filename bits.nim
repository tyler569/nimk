
proc set_bit*[T: SomeInteger](v: var T, place: int) =
  v = v or T(1 shl place)

proc clear_bit*[T: SomeInteger](v: var T, place: int) =
  v = v and not T(1 shl place)
