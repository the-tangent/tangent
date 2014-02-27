class Manifesto < Base
  helpers Sinatra::Nedry

  get "/" do
    redirect to("/manifesto")
  end

  get "/manifesto" do
    erb :manifesto, :layout => nil
  end
end
