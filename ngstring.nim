
type
  ng_string* = object
    length: int
    data: ptr char

proc `ng`*(s: string): ng_string =
  return ng_string(length: s.len, data: unsafe_addr s[0])
