class Recovery
  def initialize(log, buffer)
    @log = log
    @buffer = buffer
    
    @has_open_transaction = false
    @last_transaction_start = nil
  end

  def recover
    log_file = File.open(Log::FILENAME, "r")

    analyze(log_file)
    undo(@buffer, log_file) if @has_open_transaction

    log_file.close
  end

  def analyze(log_file)
    log_file.each_line.with_index do |entry, idx|
      case entry.chomp
      when "trx_start"
        @last_transation_start = idx
        @has_open_transaction = true
      when "trx_commit", "trx_rollback"
        @has_open_transaction = false
      end
    end
  end

  def undo(buffer, log_file)
    log_file.rewind
    
    buffer.recover do |buf|
      log_file.each_line.with_index do |entry, idx|
        next if idx <= @last_transation_start

        operation, payload = entry.split("|")
        case operation
        when "create"
          buf.delete(payload)
        when "update"
          account_name, old_value, new_value = payload.split(",")
          buf[account_name] = old_value.to_i
        end
      end
    end

    @log.transaction_rollback
  end
end
