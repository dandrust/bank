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
end

