ActiveAdmin.register Track do
  menu false

  member_action :stream do
    resource.increment(:local_play_count)
    stream_file resource.full_path
  end

  controller do
    def show
      response = {
          :id => resource.id,
          :title => resource.title,
          :artist => (resource.artist.name rescue resource.release.artists.map(&:name).to_sentence),
          :stream_uri => stream_track_path(resource)
      }
      render :json => response
    end
  end

end
