class Disk
  FILENAME = "data.txt"
  
  def initialize
    File.open(FILENAME, "a") {}
  end

  def load(buffer)
    file = File.open(FILENAME, "r")
    file.each_line do |line|
      key, value = line.chomp.split(":")
      buffer[key] = value.to_i
    end
    file.close
  end

  def dump(buffer)
    File.open(FILENAME, "w") do |file|
      buffer.each do |key, value|
        file.puts "#{key}:#{value}"
      end
    end
  end
end

