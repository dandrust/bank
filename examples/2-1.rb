# Demonstrates that simple operations generate log entries
require_relative "bank"
File.write(Disk::FILENAME, "")
File.write(Log::FILENAME, "")
bank = Bank.new
bank.open_account("Alice")
bank.deposit("Alice", 20)
bank.withdraw("Alice", 5)
puts File.read(Log::FILENAME)
