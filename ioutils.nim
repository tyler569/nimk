import format

const
  vga_width* = 80
  vga_height* = 25


type
  VGA_Entry* = distinct uint16
  Pos* = tuple[x: int, y: int]

  Video_Mem* = ptr array[0..vga_width * vga_height, VGAEntry]


const
  virtual_offset* = 0xFFFF_FFFF_8000_0000
  vram* = cast[Video_Mem](virtual_offset + 0xb8000)

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


proc write_array*[N](text: array[N, uint8], pos: Pos) =
  for i in 0 ..< text.len:
    var c = cast[char](text[i])
    write_char(make_entry(c), (pos.x+i, pos.y))


proc write_int*(number: int, pos: Pos) =
  var buffer: array[0..15, uint8]
  format(buffer, number)
  write_array(buffer, pos)
