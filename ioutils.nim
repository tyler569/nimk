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

proc writeChar*(entry: TEntry, pos: TPos) =
  ## Writes a character at the specified ``pos``.

  let index = (80 * pos.y) + pos.x
  vram[index] = entry

proc screenClear*() =
  for i in 0 ..< Vga_width:
    for j in 0 ..< Vga_height:
      writeChar(makeEntry(' '), (i, j))

proc writeString*(text: string, pos: TPos) =
  ## Writes a string at the specified ``pos`` with the specified ``color``.

  for i in 0 ..< text.len:
    writeChar(makeEntry(text[i]), (pos.x+i, pos.y))

proc write_array*[N](text: array[N, char], pos: TPos) =
  for i in 0 ..< text.len:
    writeChar(makeEntry(text[i]), (pos.x+i, pos.y))

proc shift_buffer(buffer: var array[0..15, char]) =
  for i in countdown(15, 0):
    buffer[i+1] = buffer[i]

proc to_char(i: int): char =
  return char (ord('0') + i)

proc write_int*(number: int, pos: TPos) =
  var
    buffer: array[0..15, char]
    num = number
    digits = 0

  buffer[0] = '0'

  while num > 0:
    if digits > 0: shift_buffer(buffer)

    let digit = ord(num mod 10)
    num = num div 10
    buffer[0] = to_char digit
    digits += 1

  if digits == 0: digits = 1
  
  write_array(buffer, pos)
