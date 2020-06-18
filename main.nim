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
  # let test_string: String = $$ "Hello World"

  pic_init()

  uart.init()
  uart.write("Hello World\r\n")
  uart.write(123456)
  uart.write("\r\n")

  #for e in getStackTraceEntries():
  #  uart.write_string_string(e.filename)

  for odd in odd_numbers([1, 2, 3, 4, 5, 6, 7, 1337]):
    uart.write("odd number: ")
    uart.write(odd)
    uart.write("\r\n")

  uart.write("Enabling IRQs\r\n")
  enable_irqs()
  uart.write("Enabled IRQs\r\n")

  unmask_irq 4
  loop:
    halt()


proc panic(message: string) =
  disable_irqs()
  uart.write("Main panic:\r\n");
  # uart.write_string(message)
  loop:
    halt()


proc stack_chk_fail() {.exportc: "__stack_chk_fail".} =
  panic("Stack check fail")


proc c_interrupt_shim(frame: ptr Interrupt_Frame) {.exportc.} =
  uart.write("Interrupt recieved\r\n")
  uart.write(cast[int](frame.interrupt_number))

  if frame.interrupt_number > 32:
    send_eoi(frame.interrupt_number)
  return
