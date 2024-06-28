# Demonstrates that simple operations generate log entries
require_relative "bank"
File.write(Disk::FILENAME, "")
File.write(Log::FILENAME, "")
bank = Bank.new
bank.open_account("Alice")
bank.open_account("Bob")
bank.deposit("Alice", 20)
bank.deposit("Bob", 5)
bank.transfer("Alice", "Bob", 5)
puts File.read(Log::FILENAME)
