module Persistence  
  class Model
    def initialize(hash = {})
      @hash = hash
    end
  
    def method_missing(meth, *args, &block)
      if meth == :[]
        @hash.send(:[], *args)
      else
        @hash.send(:[], meth)
      end
    end
  end
end