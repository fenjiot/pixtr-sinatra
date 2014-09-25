require "sinatra"
require "sinatra/reloader" if development?
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

get "/galleries/new" do
  erb :new_gallery
end

post "/galleries" do
  new_gallery_name = params[:gallery][:name]
  Gallery.create(name: new_gallery_name)

  redirect to ("/")
end

get "/galleries/:id/edit" do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = Image.where(gallery_id: id)
  erb :edit_gallery
end

patch "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(id)
  gallery.update(name: params[:gallery][:name], description: params[:gallery][:description])
  redirect(to("/galleries/#{id}"))
end

delete "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(id)
  gallery.destroy
  redirect to "/"
end

get "/galleries/:id" do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = Image.where(gallery_id: id)
  erb :galleries
end

