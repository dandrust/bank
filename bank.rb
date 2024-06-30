require_relative "benchmark"
require_relative "buffer"
require_relative "disk"
require_relative "log"
require_relative "persistence"
require_relative "recovery"
require_relative "transaction_manager"

class Bank
  def initialize
    @disk = Disk.new
    @buffer = Buffer.new(@disk, Persistence::Buffered)
    @log = Log.new
    @trx = TransactionManager.new(@log)

    Recovery.new(@log, @buffer, @trx).recover
  end

  def open_account(account_name, trx_id: nil)
    log_id = @log.create(account_name, trx_id:)
    @buffer.create(log_id, account_name)
  end

  def inquire(account_name)
    @buffer.read(account_name)
  end

  def deposit(account_name, amount, trx_id: nil)
    balance = inquire(account_name)
    new_balance = balance + amount
    log_id = @log.update(account_name, balance, new_balance, trx_id:)
    @buffer.update(log_id, account_name, new_balance)
  end

  def withdraw(account_name, amount, trx_id: nil)
    balance = inquire(account_name)
    new_balance = balance - amount
    log_id = @log.update(account_name, balance, new_balance, trx_id:)
    @buffer.update(log_id, account_name, new_balance)
  end

  def transfer(src_account_name, dest_account_name, amount)
    @trx.transaction do |trx_id|
      deposit(dest_account_name, amount, trx_id:)
      withdraw(src_account_name, amount, trx_id:)
    end
  end

  def peek
    @buffer.peek
  end
end
