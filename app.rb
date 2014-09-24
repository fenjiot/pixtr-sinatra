require "sinatra"
require "sinatra/reloader" if development?
# START Alt way to require sinatra/reloader
# if development?
#   require "sinatra/reloader"
# end
# END Alt way

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "photo_gallery"
)

# galleries table
class Gallery < ActiveRecord::Base
end

# images table
class Image < ActiveRecord::Base
end

get "/" do
  @galleries = Gallery.all
  erb :home
end

get "/gallery/:id" do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = Image.where(gallery_id: id)
  erb :gallery
end

