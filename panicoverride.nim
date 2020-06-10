import ioutils
{.push stack_trace: off, profiler:off.}

proc raw_output(s: string) =
  write_string("Error: ", (0, 24))
  write_string(s, (7, 24))

proc panic(s: string) =
  raw_output(s)

{.pop.}
