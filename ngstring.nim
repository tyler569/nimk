
type
  String* = object
    length*: int
    data*: ptr char

proc `$$`*(s: string): String =
  return String(length: s.len, data: unsafe_addr s[0])
