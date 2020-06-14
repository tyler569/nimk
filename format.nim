proc shift_buffer(buffer: var openArray[uint8]) =
  for i in countdown(buffer.len - 2, 0):
    buffer[i+1] = buffer[i]

proc to_char(i: int): uint8 =
  return uint8 (ord('0') + i)


proc format*(buffer: var openArray[uint8], number: int) =
  var
    num = number
    digits = 0

  buffer[0] = ord '0'
  buffer[1] = 0

  while num > 0 and digits < buffer.len:
    if digits > 0:
      shift_buffer(buffer)

    let digit = ord(num mod 10)
    num = num div 10
    buffer[0] = to_char(digit)
    digits += 1


proc format(buffer: var openArray[uint8], s: string) =
  discard

proc format(buffer: var openArray[uint8], u: uint) =
  discard
