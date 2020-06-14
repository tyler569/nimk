# import macros
import format
import ioutils
import ngstring
import serial
import x86

iterator odd_numbers(a: openArray[int]): int =
  for x in a:
    if x mod 2 == 1:
      yield x

template loop(body: untyped): untyped =
  while true:
    body


proc kernel_main(a, b: uint) {.exportc.} =
  screen_clear();
  write_string("Nim", (0, 2))
  write_string("Expressive. Efficient. Elegant.", (0, 4))

  # let test_string: String = $$ "Hello World"

  pic_init()

  uart.init()
  uart.write_string("Hello World\r\n");

  #for e in getStackTraceEntries():
  #  uart.write_string(e.filename)

  var g = 0
  let b = 8
  for odd in odd_numbers([1, 2, 3, 4, 5, 6, 7, 1337]):
    write_int(odd, (5, b + g))
    write_string("num: ", (0, b + g))
    g += 1

  uart.write_string("Enabling IRQs\r\n");
  enable_irqs()
  uart.write_string("Enabled IRQs\r\n");

  unmask_irq 4
  loop:
    halt()


proc panic(message: string) =
  disable_irqs()
  # uart.write_string("Main panic\r\n");
  write_string("Panic: ", (0, 24))
  write_string(message, (7, 24))
  loop:
    halt()


proc stack_chk_fail() {.exportc: "__stack_chk_fail".} =
  panic("Stack check fail")


proc c_interrupt_shim(frame: ptr Interrupt_Frame) {.exportc.} =
  uart.write_string("Interrupt recieved\r\n")
  if frame.interrupt_number > 32:
    send_eoi(frame.interrupt_number)
  return
