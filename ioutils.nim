# import unsigned
#
const
  VGAWidth* = 80
  VGAHeight* = 25

type
  TEntry* = distinct uint16
  TPos* = tuple[x: int, y: int]

  PVIDMem* = ptr array[0..VGAWidth * VGAHeight, TEntry]

const
  virtual_offset* = 0xFFFF_FFFF_8000_0000
  vram* = cast[PVIDMem](virtual_offset + 0xb8000)

  base_color = 0x07

proc makeEntry*(c: char): TEntry =
  let
    c16 = uint16 ord(c)
    color16 = uint16 base_color
  return TEntry(c16 or (color16 shl 8))

proc writeChar*(vram: PVidMem, entry: TEntry, pos: TPos) =
  ## Writes a character at the specified ``pos``.

  let index = (80 * pos.y) + pos.x
  vram[index] = entry

proc screenClear*(vram: PVidMem) =
  for i in 0 ..< Vga_width:
    for j in 0 ..< Vga_height:
      writeChar(vram, makeEntry(' '), (i, j))

proc writeString*(vram: PVidMem, text: string, pos: TPos) =
  ## Writes a string at the specified ``pos`` with the specified ``color``.

  for i in 0 ..< text.len:
    vram.writeChar(makeEntry(text[i]), (pos.x+i, pos.y))
