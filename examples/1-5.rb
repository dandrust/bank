# Demonstrates that compound operations are 
# not atomic
require_relative "bank"
File.write(Disk::FILENAME, "")
bank = Bank.new
bank.open_account("Alice")
bank.open_account("Bob")
bank.deposit("Alice", 20)
bank.deposit("Bob", 5)
bank.transfer("Alice", "Bob", 5)
puts File.read(Disk::FILENAME)
