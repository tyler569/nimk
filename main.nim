import ioutils

const virtual_offset = 0xFFFF_FFFF_8000_0000

proc kernel_main() {.exportc.} =
  var vram = cast[PVIDMem](0xB8000 + virtual_offset)
  screenClear(vram);

  writeString(vram, "Nim", (25, 9))
  writeString(vram, "Expressive. Efficient. Elegant.", (25, 10))

