import ioutils
{.push stack_trace: off, profiler:off.}

proc rawoutput(s: string) =
  writeString("Error: ", (0, 24))
  writeString(s, (7, 24))

proc panic(s: string) =
  rawoutput(s)

{.pop.}
