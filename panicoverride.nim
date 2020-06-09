import ioutils
{.push stack_trace: off, profiler:off.}

proc rawoutput(s: string) =
  writeString(vram, "Error: ", (0, 24))
  writeString(vram, s, (7, 24))

proc panic(s: string) =
  rawoutput(s)

# proc stack_chk_fail() {.exportc: "__stack_chk_fail".} =
#   panic("Stack check fail")

{.pop.}
