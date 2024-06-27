require_relative "buffer"
require_relative "disk"
require_relative "persistence"

class Bank
  def initialize
    @disk = Disk.new
    @buffer = Buffer.new(@disk, Persistence::Immediate)
  end

  def open_account(account_name)
    @buffer.create(account_name)
  end

  def inquire(account_name)
    @buffer.read(account_name)
  end

  def deposit(account_name, amount)
    balance = inquire(account_name)
    @buffer.update(account_name, balance + amount)
  end

  def withdraw(account_name, amount)
    balance = inquire(account_name)
    @buffer.update(account_name, balance - amount)
  end

  def transfer(src_account_name, dest_account_name, amount)
    deposit(src_account_name, amount)
    return # simulate failure
    withdraw(dest_account_name, -amount)
  end

  def peek
    @buffer.peek
  end
end
