require_relative "buffer"
require_relative "disk"
require_relative "log"
require_relative "persistence"
require_relative "transaction_manager"
require_relative "recovery"

class Bank
  def initialize
    @disk = Disk.new
    @buffer = Buffer.new(@disk, Persistence::Immediate)
    @log = Log.new
    @trx = TransactionManager.new(@log)

    Recovery.new(@log, @buffer).recover
  end

  def open_account(account_name)
    @log.create(account_name)
    @buffer.create(account_name)
  end

  def inquire(account_name)
    @buffer.read(account_name)
  end

  def deposit(account_name, amount)
    balance = inquire(account_name)
    new_balance = balance + amount
    @log.update(account_name, balance, new_balance)
    @buffer.update(account_name, new_balance)
  end

  def withdraw(account_name, amount)
    balance = inquire(account_name)
    new_balance = balance - amount
    @log.update(account_name, balance, new_balance)
    @buffer.update(account_name, new_balance)
  end

  def transfer(src_account_name, dest_account_name, amount)
    @trx.transaction do
      deposit(src_account_name, amount)
      withdraw(dest_account_name, -amount)
    end
  end

  def peek
    @buffer.peek
  end
end
