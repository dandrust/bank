require_relative "buffer"

class Bank
  def initialize
    @buffer = Buffer.new
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

  def transfer
    raise NotImplementedError
  end

  def peek
    @buffer.peek
  end
end
