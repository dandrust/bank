# Demonstrates that in-memory data structure tracks state
# by inspecting `bank.peek` output
require_relative "bank"
bank = Bank.new
bank.peek
bank.open_account("Alice")
bank.peek
bank.deposit("Alice", 20)
bank.peek
bank.withdraw("Alice", 5)
bank.peek
