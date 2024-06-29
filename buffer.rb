require_relative "benchmark"

class Buffer
  attr_reader :buffer_bm, :disk_bm

  def initialize(disk, persistence_strategy)
    @data = {}
    disk.load(@data)
    @persistence = persistence_strategy.new(disk)

    @buffer_bm = Benchmark.new("Buffer writes")
    @disk_bm = Benchmark.new("Disk writes")
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

  def recover
    modify do
      yield @data
    end
  end

  private

  def modify
    @buffer_bm.track do
      yield if block_given?
    end

    @disk_bm.track do
      @persistence.persist(@data)
    end
  end
end
