class Base < Sinatra::Base
  enable :method_override, :logging
  set :public_folder, 'public'

  include Pharrell::Injectable
end
