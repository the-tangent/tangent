module System
  class Clock
    def now
      Time.new.utc
    end
  end
end