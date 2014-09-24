require "sinatra"
require "sinatra/reloader" if development?
# START Alt way to require sinatra/reloader
# if development?
#   require "sinatra/reloader"
# end
# END Alt way
require "pg"

database = PG.connect({ dbname: "photo_gallery" })
# GALLERIES = {
#   "cats" => ["colonel_meow.jpg", "grumpy_cat.png"],
#   "dogs" => ["shibe.png"]
# }

# gem install sinatra-contrib <- to use sinatra/reloader development?
# Handle an HTTP GET request to '/'
get "/" do
  galleries = database.exec_params("SELECT name FROM galleries")
  @gallery_names = galleries.map do |gallery|
    gallery["name"]
  end
  # Alt way to do above: @gallery_names = galleries.map { |gallery|
  # gallery["name"] }
  puts @gallery_names.inspect
  erb :home
end

get "/gallery/:name" do
  @name = params[:name]
  @images = GALLERIES[@name]
  erb :gallery
end

get "/projects/:id" do
  @project_id = params["id"]
  # note: :id is also acceptable above. @project_id = params[:id]
  erb :project
end

