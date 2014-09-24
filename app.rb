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
  galleries = database.exec_params("SELECT id, name FROM galleries")
  @gallery_ids_names = galleries.map { |gallery| gallery }
  erb :home
end

get "/gallery/:id" do
  id = params[:id]
  # Getting name from database
  query_name = "SELECT name FROM galleries WHERE id = $1"
  name_result = database.exec_params(query_name, [id])
  @name = name_result.first["name"]

  # Getting image urls from database 
  query_images = "SELECT url FROM images WHERE gallery_id = $1"

  images_result = database.exec_params(query_images, [id])
  @images = images_result.map { |image| image["url"] }
  puts images_result.inspect
  puts @images.inspect
  erb :gallery
end

# get "/projects/:id" do
#   @project_id = params["id"]
#   # note: :id is also acceptable above. @project_id = params[:id]
#   erb :project
#end

