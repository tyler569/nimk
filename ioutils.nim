const
  vga_width* = 80
  vga_height* = 25


type
  VGAEntry* = distinct uint16
  Pos* = tuple[x: int, y: int]

  VideoMem* = ptr array[0..vga_width * vga_height, VGAEntry]


const
  virtual_offset* = 0xFFFF_FFFF_8000_0000
  vram* = cast[VideoMem](virtual_offset + 0xb8000)

  base_color = 0x07


proc make_entry*(c: char): VGAEntry =
  let
    c16 = uint16 ord(c)
    color16 = uint16 base_color
  return VGAEntry(c16 or (color16 shl 8))


proc write_char*(entry: VGAEntry, pos: Pos) =
  ## Writes a character at the specified ``pos``.

  let index = (80 * pos.y) + pos.x
  vram[index] = entry


proc screen_clear*() =
  for i in 0 ..< vga_width:
    for j in 0 ..< vga_height:
      write_char(make_entry(' '), (i, j))


proc write_string*(text: string, pos: Pos) =
  ## Writes a string at the specified ``pos`` with the specified ``color``.

  for i in 0 ..< text.len:
    write_char(make_entry(text[i]), (pos.x+i, pos.y))


proc write_array*[N](text: array[N, char], pos: Pos) =
  for i in 0 ..< text.len:
    write_char(make_entry(text[i]), (pos.x+i, pos.y))


proc shift_buffer(buffer: var array[0..15, char]) =
  for i in countdown(15, 0):
    buffer[i+1] = buffer[i]


proc to_char(i: int): char =
  return char (ord('0') + i)


proc write_int*(number: int, pos: Pos) =
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
