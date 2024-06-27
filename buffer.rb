class Buffer
  def initialize
    @data = {}
  end

  def create(key)
    @data[key] ||= 0
  end

  def read(key)
    @data[key]
  end

  def update(key, value)
    @data[key] = value if @data[key]
  end
  
  def delete(key)
    raise NotImplementedError
  end

  def peek
    @data
  end
end
