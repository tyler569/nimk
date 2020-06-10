import macros
import ioutils
import ngstring

iterator odd_numbers[N](a: array[N, int]): int =
  for x in a:
    if x mod 2 == 1:
      yield x


proc kernel_main() {.exportc.} =
  screenClear();
  writeString("Nim", (25, 9))
  writeString("Expressive. Efficient. Elegant.", (25, 10))

  let c: ng_string = ng "Hello World"

  var g = 0
  let b = 15
  for odd in odd_numbers([1, 2, 3, 4, 5, 6, 7, 1337]):
    write_int(odd, (30, b + g))
    write_string("num: ", (20, b + g))
    g += 1

  writeString("This (should) error out", (80, 24))


proc panic(message: string) =
  writeString("Panic: ", (0, 24))
  writeString(message, (7, 24))

  while true:
    discard


proc stack_chk_fail() {.exportc: "__stack_chk_fail".} =
  panic("Stack check fail")
