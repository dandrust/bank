module Persistence
  class Buffered
    def initialize(disk, threshold: 5)
      @disk = disk
      @threshold = threshold
      @write_count = 0
    end

    def persist(buffer)
      @write_count += 1
      
      if @write_count >= @threshold
        @disk.dump(buffer)
        @write_count = 0
      end
    end
  end
end