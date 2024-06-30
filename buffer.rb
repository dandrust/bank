class Buffer
  attr_reader :latest_log_id

  def initialize(disk, persistence_strategy)
    @data = {}
    @latest_log_id = 0
    disk.load(@data, @latest_log_id)
    @persistence = persistence_strategy.new(disk)
  end

  def create(log_id, key)
    @latest_log_id = log_id

    modify do
      @data[key] ||= 0
    end
  end

  def read(key)
    @data[key]
  end

  def update(log_id, key, value)
    @latest_log_id = log_id

    modify do
      @data[key] = value if @data[key]
    end
  end
  
  def delete(log_id, key)
    raise NotImplementedError
  end

  def peek
    @data
  end

  def recover
    @latest_log_id = yield @data
    @persistence.force(@data, @latest_log_id)
  end

  private

  def modify
    yield if block_given?
    @persistence.persist(@data, @latest_log_id)
  end
end
