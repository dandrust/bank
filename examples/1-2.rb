# Demonstrates that persisted state is loaded 
# in memory on initialization by writing a `data.txt`
# file and observing it reflected in `data.peek` output
require_relative "bank"
File.write(Disk::FILENAME, "Alice:20\nBob:10\n")
bank = Bank.new
bank.peek