require_relative "../bank"
require_relative "../benchmark"
File.write(Log::FILENAME, "")
File.write(Disk::FILENAME, "Alice:0")
bank = Bank.new
bm = Benchmark.new("Total runtime")
5_000.times do
  bm.track do
    bank.deposit("Alice", 40)
  end
end
puts bm.report
puts "==="
bank.benchmark_report