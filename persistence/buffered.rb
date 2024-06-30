module Persistence
  class Buffered
    def initialize(disk, threshold: 5)
      @disk = disk
      @threshold = threshold
      @write_count = 0
    end

    def persist(buffer, log_id)
      @write_count += 1
      
      if @write_count >= @threshold
        @disk.dump(buffer, log_id)
        @write_count = 0
      end
    end

    def force(buffer, log_id)
      @disk.dump(buffer, log_id)
      @write_count = 0
    end
  end
end