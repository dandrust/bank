module Persistence
  class Immediate
    def initialize(disk)
      @disk = disk
    end

    def persist(buffer, log_id)
      @disk.dump(buffer, log_id)
    end

    def force(buffer, log_id)
      persist(buffer, log_id)
    end
  end
end