require_relative "sequential_id"

class Log
  include SequentialId

  FILENAME = "log.txt"
  def initialize
    File.open(FILENAME, "a") {}
    initialize_sequence
  end

  def create(account_name, trx_id: nil)
    log do |id|
      hdr = "#{id},create"
      hdr += ",#{trx_id}" if trx_id
      
      "#{hdr}|#{account_name}"
    end
  end

  def update(account_name, old_value, new_value, trx_id: nil)
    log do |id|
      hdr = "#{id},update"
      hdr += ",#{trx_id}" if trx_id

      "#{hdr}|#{account_name},#{old_value},#{new_value}"
    end
  end

  def transaction_start(trx_id)
    log do |id|
      "#{id},trx_start,#{trx_id}"
    end
  end

  def transaction_commit(trx_id)
    log do |id|
      "#{id},trx_commit,#{trx_id}"
    end
  end

  def transaction_rollback(trx_id)
    log do |id|
      "#{id},trx_rollback,#{trx_id}"
    end
  end

  private

  def log
    id = next_id
    File.open(FILENAME, "a") do |file|
      file.puts yield(id)
    end
    id
  end
end
