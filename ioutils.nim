# import unsigned
const
  VGAWidth* = 80
  VGAHeight* = 25
type
  TEntry* = distinct uint16
  TPos* = tuple[x: int, y: int]

  PVIDMem* = ptr array[0..VGAWidth * VGAHeight, TEntry]


const
  base_color = 0x07

proc makeEntry*(c: char): TEntry =
  let c16 = ord(c).uint16
  let color16 = base_color.uint16
  return (c16 or (color16 shl 8)).TEntry

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
