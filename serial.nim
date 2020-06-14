import bits
import x86

const
  uart* = Port 0x3f8

  UART_DATA = 0
  UART_INTERRUPT_ENABLE = 1

  UART_BAUD_LOW = 0
  UART_BAUD_HIGH = 1
  UART_FIFO_CTRL = 2
  UART_LINE_CTRL = 3
  UART_MODEM_CTRL = 4
  UART_LINE_STATUS = 5
  UART_MODEM_STATUS = 6


proc is_transmit_empty(port: Port): bool =
  return (inb(port + UART_LINE_STATUS) and 0x20) != 0

proc is_data_available(port: Port): bool =
  return (inb(port + UART_LINE_STATUS) and 0x01) != 0

proc wait_for_transmit_empty(port: Port) =
  while not is_transmit_empty(port):
    discard

proc wait_for_data_available(port: Port) =
  while not is_data_available(port):
    discard

proc write_byte*(port: Port, b: uint8) =
  wait_for_transmit_empty(port)
  outb(port + UART_DATA, b)

proc write_slice*(port: Port, slice: openArray[uint8]) =
  for c in slice:
    write_byte(port, c)

proc write_string*(port: Port, str: string) =
  for c in str:
    write_byte(port, uint8(c))

proc read_byte*(port: Port): uint8 =
  wait_for_data_available(port)
  return inb(port + UART_DATA)

proc enable_interrupt*(port: Port) =
  outb(port + UART_INTERRUPT_ENABLE, 9)

proc init*(port: Port) =
  outb(port + UART_BAUD_HIGH, 0x00);
  outb(port + UART_LINE_CTRL, 0x80);
  outb(port + UART_BAUD_LOW , 0x03);
  outb(port + UART_BAUD_HIGH, 0x00);
  outb(port + UART_LINE_CTRL, 0x03);
  outb(port + UART_FIFO_CTRL, 0xC7);
  outb(port + UART_MODEM_CTRL, 0x0B);

