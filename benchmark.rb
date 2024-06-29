class Benchmark
  attr_reader :label

  def initialize(label)
    @label = label
    @cumulative_time = 0
    @iterations = 0
  end

  def track
    @iterations += 1
    t_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    t_end = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @cumulative_time += t_end - t_start
  end

  def usec(sec)
    sec * 1_000_000
  end

  def report
    "#{@label}:\t#{@cumulative_time.round(4)} seconds (#{usec(@cumulative_time).round(0)} usec) over #{@iterations} iterations (#{usec(@cumulative_time / @iterations).round(1)} usec/iteration)"
  end
end