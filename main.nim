import macros
import ioutils
import ngstring

# proc nimMulInt*(a, b: int): int {.exportc.} = discard

iterator odd_numbers[N](a: array[N, int]): int =
  for x in a:
    if x mod 2 == 1:
      yield x

proc kernel_main() {.exportc.} =
  screenClear(vram);
  writeString(vram, "Nim", (25, 9))
  writeString(vram, "Expressive. Efficient. Elegant.", (25, 10))

  let c: ng_string = ng "Hello World"

  var g = 0
  let b = 12
  for odd in odd_numbers([1, 2, 3, 4, 5, 6, 7]):
    write_int(vram, odd, (30, b + g))
    write_string(vram, "num: ", (20, b + g))
    g += 1

  writeString(vram, "This (should) error out", (80, 24))


