require 'iconv'

ActiveAdmin.register Release do
  config.sort_order = 'name_asc'

  filter :name
  filter :title
  filter :year

  # favorite

  scope :favorited
  action_item :only => :show do
    if resource.favorited?
      link_to(icon(:heart_stroke) + "Unmark as favovite", toggle_favorite_release_path(resource))
    else
      link_to(icon(:heart_fill) + "Mark as favovite", toggle_favorite_release_path(resource))
    end
  end

  member_action :toggle_favorite do
    resource.update_attribute :favorited, !resource.favorited
    redirect_to resource
  end

  # metadata

  action_item :only => :show do
    link_to(icon(:reload) + "Update metadata", update_metadata_release_path(resource))
  end

  member_action :update_metadata do
    resource.update_metadata
    redirect_to resource
  end

  # ajax

  member_action :random_track do
    track = resource.tracks.sample
    respond_to do |format|
      format.json do
        render :json => {
            :id => track.id,
            :artist => (track.artist.name rescue resource.artists.map(&:name).to_sentence),
            :title => track.title,
            :stream_uri => stream_track_path(track)
        }
      end
    end
  end

  # actions

  form do |f|
    f.inputs :path
    f.buttons
  end

  show :title => :name do
    panel "Description", :id => :description do
      pre do
        Iconv.new('UTF-8', 'IBM437').conv(File.open(resource.description_file, "rb").read)
      end
    end
  end

  index do
    column :name, :sortable => :name do |resource|
      link_to resource.name, release_path(resource)
    end

    column :play_count, :sortable => :play_count

    column :created_at, :sortable => :created_at do |resource|
      time_ago_in_words resource.created_at
    end
  end

  sidebar :playback, :only => :show do
    ol do
      resource.tracks.map do |track|
        li do
          if resource.various_artists? and track.artist
            link_to track.artist.name, artist_path(track.artist)
            "-"
          end
          link_to track.title, "javascript:AudioPlayer.playTrack(#{{
              :id => track.id,
              :artist => (track.artist.name rescue release.artists.map(&:name).to_sentence),
              :title => track.title,
              :stream_uri => stream_track_path(track)
          }.to_json})"
        end
      end
    end
  end

  sidebar :artists, :only => :show do
    div :class => " grid " do
      resource.artists.map do |artist|
        div :class => " artist " do
          div(:class => " image ") { image_tag(artist.image_url) }
          div(:class => " name ") { link_to(artist.name, artist_path(artist)) }
        end
      end
    end
  end

  sidebar :genres, :only => :show do
    ul do
      resource.artists.map(&:genres).flatten.uniq.map do |genre|
        li link_to genre.name, genre_artists_path(genre)
      end
    end
  end
end
