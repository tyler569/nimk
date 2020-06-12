
type
  Port* = distinct uint16

proc outb*(p: Port, b: uint8) {.importc.}
proc outw*(p: Port, b: uint16) {.importc.}
proc outl*(p: Port, b: uint32) {.importc.}

proc inb*(p: Port): uint8 {.importc.}
proc inw*(p: Port): uint16 {.importc.}
proc inl*(p: Port): uint32 {.importc.}

