module Persistence
  class Immediate
    def initialize(disk)
      @disk = disk
    end

    def persist(buffer)
      @disk.dump(buffer)
    end
  end
end