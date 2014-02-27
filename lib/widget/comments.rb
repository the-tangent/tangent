module Widget
  class Comments
    def initialize(env)
      @env = env
    end

    def environment
      case @env
      when "production"
        "thetangent"
      when "development"
        "thetangent-dev"
      when "test"
        "thetangent-test"
      else
        ""
      end
    end
  end
end
