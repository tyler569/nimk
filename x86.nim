import bits

type
  Port* = distinct uint16

  Interrupt_Frame* = object
    ds*, r15*, r14*, r13*, r12*, r11*, r10*, r9*, r8*: uint64
    bp*, di*, si*, dx*, bx*, cx*, ax*: uint64
    interrupt_number*, error_code*: uint64
    ip*, cs*, flags*, sp*, ss*: uint64

const
  debugcon* = Port 0xE9

  PRIMARY_PIC_COMMAND = Port 0x20
  PRIMARY_PIC_DATA    = Port 0x21
  CHILD_PIC_COMMAND = Port 0xA0
  CHILD_PIC_DATA    = Port 0xA1

  END_OF_INTERRUPT = 0x20


proc `+`*(p: Port, i: int): Port =
  Port(int(p) + i)

proc outb*(p: Port, b: uint8) {.importc.}
proc outw*(p: Port, b: uint16) {.importc.}
proc outl*(p: Port, b: uint32) {.importc.}

proc inb*(p: Port): uint8 {.importc.}
proc inw*(p: Port): uint16 {.importc.}
proc inl*(p: Port): uint32 {.importc.}

proc enable_irqs*() =
  {.emit: "asm volatile (\"sti\");".}

proc disable_irqs*() =
  {.emit: "asm volatile (\"cli\");".}

proc pause*() =
  {.emit: "asm volatile (\"pause\");".}

proc halt*() =
  {.emit: "asm volatile (\"hlt\");".}


proc send_eoi*(irq: int | uint64) =
  if irq >= 8:
    outb(CHILD_PIC_COMMAND, END_OF_INTERRUPT)
  outb(PRIMARY_PIC_COMMAND, END_OF_INTERRUPT)


proc unmask_irq*(irq: int) =
  if irq > 8:
    var mask = inb(CHILD_PIC_DATA)
    clear_bit(mask, irq - 8)
    outb(CHILD_PIC_DATA, mask)
  else:
    var mask = inb(PRIMARY_PIC_DATA)
    clear_bit(mask, irq)
    outb(PRIMARY_PIC_DATA, mask)


proc mask_irq*(irq: int) =
  if irq > 8:
    var mask = inb(CHILD_PIC_DATA)
    set_bit(mask, irq - 8)
    outb(CHILD_PIC_DATA, mask)
  else:
    var mask = inb(PRIMARY_PIC_DATA)
    set_bit(mask, irq)
    outb(PRIMARY_PIC_DATA, mask)


proc pic_init* =
  outb(PRIMARY_PIC_COMMAND, 0x11) # Reprogram
  outb(PRIMARY_PIC_DATA, 0x20)    # interrupt 0x20
  outb(PRIMARY_PIC_DATA, 0x04)    # child PIC one line 2
  outb(PRIMARY_PIC_DATA, 0x01)    # 8086 mode
  outb(PRIMARY_PIC_DATA, 0xFF)    # mask all interrupts
  outb(CHILD_PIC_COMMAND, 0x11) # Reprogram
  outb(CHILD_PIC_DATA, 0x28)    # interrupt 0x28
  outb(CHILD_PIC_DATA, 0x02)    # ?
  outb(CHILD_PIC_DATA, 0x01)    # 8086 mode
  outb(CHILD_PIC_DATA, 0xFF)    # mask all interrupts

  unmask_irq(2) # cascade irq
