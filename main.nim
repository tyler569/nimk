import macros
import ioutils
import ngstring
import serial

iterator odd_numbers[N](a: array[N, int]): int =
  for x in a:
    if x mod 2 == 1:
      yield x


proc kernel_main() {.exportc.} =
  screen_clear();
  write_string("Nim", (0, 2))
  write_string("Expressive. Efficient. Elegant.", (0, 4))

  let c: ng_string = ng "Hello World"

  uart.init
  uart.write_string("Hello World\r\n");

  var g = 0
  let b = 8
  for odd in odd_numbers([1, 2, 3, 4, 5, 6, 7, 1337]):
    write_int(odd, (5, b + g))
    write_string("num: ", (0, b + g))
    g += 1

  write_string("This (should) error out", (80, 24))


proc panic(message: string) =
  write_string("Panic: ", (0, 24))
  write_string(message, (7, 24))

  while true:
    discard


proc stack_chk_fail() {.exportc: "__stack_chk_fail".} =
  panic("Stack check fail")
