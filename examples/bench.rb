require_relative "../bank"
require_relative "../benchmark"
File.write(Log::FILENAME, "")
File.write(Disk::FILENAME, "")
bank = Bank.new
bank.open_account("Alice")
bm = Benchmark.new("Total runtime")
5_000.times do
  bm.track do
    bank.deposit("Alice", 40)
  end
end
bank.open_account("Bob")
bank.transfer("Alice", "Bob", 20)
puts bm.report
puts "==="
# bank.benchmark_report