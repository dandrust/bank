# Demonstrates that in-memory data structure is flushed
# to disk
require_relative "bank"
File.write(Disk::FILENAME, "")
bank = Bank.new
bank.peek
puts File.read(Disk::FILENAME)
bank.open_account("Alice")
bank.peek
puts File.read(Disk::FILENAME)
bank.deposit("Alice", 20)
bank.peek
puts File.read(Disk::FILENAME)
bank.withdraw("Alice", 5)
bank.peek
puts File.read(Disk::FILENAME)
