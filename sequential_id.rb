module SequentialId
  def initialize_sequence(start_at = 1)
    @next_id = start_at
  end

  def next_id
    id = @next_id
    @next_id += 1
    id
  end

  def seed_id(value)
    @next_id = value + 1
  end
end
