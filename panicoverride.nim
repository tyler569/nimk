import ioutils
{.push stack_trace: off, profiler:off.}

proc rawoutput(s: string) =
  var vram = cast[PVIDMem](0xB8000)
  writeString(vram, "Error: ", (0, 24))
  writeString(vram, s, (7, 24))

proc panic(s: string) =
  rawoutput(s)

{.pop.}
