ActiveAdmin.register Genre do
  config.sort_order = 'name_asc'
  filter :name
  show :title => :name

  index do
    column :name do |resource|
      link_to resource.name, genre_artists_path(resource)
    end
  end
end
