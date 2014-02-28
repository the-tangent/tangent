module Persistence
  class Model
    def initialize(hash = {})
      @hash = hash
    end

    def set(key, value)
      @hash[key] = value
      self
    end

    def method_missing(meth, *args, &block)
      @hash.send(:[], meth)
    end
  end
end
