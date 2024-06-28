class Log
  FILENAME = "log.txt"

  def initialize
    File.open(FILENAME, "a") {}
  end

  def create(account_name)
    log do
      "create|#{account_name}"
    end
  end

  def update(account_name, old_value, new_value)
    log do
      "update|#{account_name}, #{old_value}, #{new_value}"
    end
  end

  def transaction_start
    log { "trx_start" }
  end

  def transaction_commit
    log { "trx_commit" }
  end

  private

  def log
    File.open(FILENAME, "a") do |file|
      file.puts yield
    end
  end
end
