class Recovery
  def initialize(log, buffer, trx)
    @log = log
    @buffer = buffer
    @trx = trx
    
    @last_transaction_id = nil
    @latest_persisted_log_id = 0
    @latest_logged_id = 0

    @transactions = {}
  end

  def recover
    log_file = File.open(Log::FILENAME, "r")

    analyze(log_file)
    @log.seed_id(@latest_logged_id)
    @trx.seed_id(@transactions.keys.max) unless @transactions.empty?

    replay(@buffer, log_file) if missing_updates?(@buffer)
    undo(@buffer, log_file) if @transactions[@last_transaction_id] == :started

    log_file.close
  end

  def analyze(log_file)
    log_file.each_line do |entry|
      next if entry.chomp.empty?

      id, operation, trx_id, payload = parse(entry)

      @latest_logged_id = id

      case operation
      when "trx_start"
        @last_transaction_id = trx_id
        @transactions[trx_id] = :started
      when "trx_commit"
        @transactions[trx_id] = :committed
      when "trx_rollback"
        @transactions[trx_id] = :rolled_back
      end
    end
  end

  def replay(buffer, log_file)
    puts "sanity"
    log_file.rewind

    buffer.recover do |buf|
      log_file.each_line do |entry|
        next if entry.chomp.empty?

        id, operation, trx_id, payload = parse(entry)
        
        next if id <= @latest_persisted_log_id
        next if @transactions[trx_id] == :rolled_back

        case operation
        when "create"
          buf[payload] ||= 0
        when "update"
          account_name, old_value, new_value = payload.split(",")
          buf[account_name] = new_value.to_i
        end
      end

      @latest_logged_id
    end
  end

  def undo(buffer, log_file)
    log_file.rewind
    
    buffer.recover do |buf|
      log_file.each_line do |entry|
        next if entry.chomp.empty?

        id, operation, trx_id, payload = parse(entry)

        next unless trx_id == @last_transaction_id

        case operation
        when "create"
          buf.delete(payload)
        when "update"
          account_name, old_value, new_value = payload.split(",")
          buf[account_name] = old_value.to_i
        end
      end
      @log.transaction_rollback(@last_transaction_id)
    end
  end

  def missing_updates?(buffer)
    @latest_logged_id > buffer.latest_log_id
  end

  def parse(entry)
    hdr, payload = entry.chomp.split("|")
    id, operation, trx_id = hdr.split(",")
    
    id = id.to_i
    trx_id = trx_id.to_i if trx_id

    [id, operation, trx_id, payload]
  end
end
