import ioutils

proc kernel_main() {.exportc.} =
  screenClear(vram);
  writeString(vram, "Nim", (25, 9))
  writeString(vram, "Expressive. Efficient. Elegant.", (25, 10))

  writeString(vram, "This (should) error out", (80, 24))

