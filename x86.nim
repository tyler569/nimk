
type
  Port* = distinct uint16

  IrqFrame* = object
    registers: uint64


proc `+`*(p: Port, i: int): Port =
  Port(int(p) + i)

proc outb*(p: Port, b: uint8) {.importc.}
proc outw*(p: Port, b: uint16) {.importc.}
proc outl*(p: Port, b: uint32) {.importc.}

proc inb*(p: Port): uint8 {.importc.}
proc inw*(p: Port): uint16 {.importc.}
proc inl*(p: Port): uint32 {.importc.}

proc c_interrupt_shim(frame: ptr IrqFrame) {.exportc.} =
  return
