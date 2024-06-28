class TransactionManager
  def initialize(log)
    @log = log
  end

  def transaction
    return unless block_given?

    @log.transaction_start
    yield
    @log.transaction_commit
  end
end