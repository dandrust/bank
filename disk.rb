class Disk
  FILENAME = "data.txt"
  
  def initialize
    File.open(FILENAME, "a") {}
  end

  def load(buffer, log_id)
    file = File.open(FILENAME, "r")
    log_id = file.gets&.chomp
    file.each_line do |line|
      key, value = line.chomp.split(":")
      buffer[key] = value.to_i
    end
    file.close
  end

  def dump(buffer, log_id)
    File.open(FILENAME, "w") do |file|
      file.puts log_id
      buffer.each do |key, value|
        file.puts "#{key}:#{value}"
      end
    end
  end
end

