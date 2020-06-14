import ioutils
import x86

{.push stack_trace: off, profiler:off.}

proc raw_output(s: string) =
  write_string("Error: ", (0, 24))
  write_string(s, (7, 24))
  for i in 0..<s.len:
    outb(debugcon, uint8 s[i]) # debugcon
  outb(debugcon, ord '\r')
  outb(debugcon, ord '\n')

proc panic(s: string) =
  raw_output(s)
  while true:
    discard

{.pop.}
