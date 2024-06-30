require_relative "sequential_id"

class TransactionManager
  include SequentialId

  def initialize(log)
    @log = log
    initialize_sequence
  end

  def transaction
    return unless block_given?

    id = next_id

    @log.transaction_start(id)
    yield(id)
    @log.transaction_commit(id)
  end
end