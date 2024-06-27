class Buffer
  def initialize(disk, persistence_strategy)
    @data = {}
    disk.load(@data)
    @persistence = persistence_strategy.new(disk)
  end

  def create(key)
    modify do
      @data[key] ||= 0
    end
  end

  def read(key)
    @data[key]
  end

  def update(key, value)
    modify do
      @data[key] = value if @data[key]
    end
  end
  
  def delete(key)
    raise NotImplementedError
  end

  def peek
    @data
  end

  private

  def modify
    yield if block_given?
    @persistence.persist(@data)
  end
end
