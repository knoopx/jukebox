ActiveAdmin.register Artist do
  config.sort_order = 'name_asc'
  belongs_to :genre, :optional => true

  filter :name
  filter :tags

  controller do
    has_scope :genres_id_in, :type => :array
    has_scope :genres_id_not_in, :type => :array

    def end_of_association_chain
      super.includes(:tracks)
    end
  end

  show :title => :name do |resource|
    panel "Summary" do
      simple_format(resource.summary)
    end

    resource.releases.each do |release|
      release_panel(release) do
        div :class => "artwork" do
          para link_to image_tag((release.image_url.blank? ? "cd_case.png" : release.image_url), :witdh => 100, :height => 100), release
          link_to("Stream", "javascript:AudioPlayer.playTracks([#{release.tracks.map(&:id).join(", ")}])", :class => "button")
        end

        div :class => "tracks" do
          ol do
            release.tracks.map do |track|
              li do
                if release.various_artists? and track.artist
                  link_to track.artist.name, artist_path(track.artist)
                  "-"
                end
                link_to track.title, "javascript:AudioPlayer.playTrack(#{track.id})", :id => dom_id(track), :class => "track"
              end
            end
          end
        end
      end
    end

    panel "Similar Artists" do
      div :class => "grid" do
        resource.similar.map do |artist|
          div :class => "artist" do
            div(:class => "image") { image_tag(artist.image_url) }
            div(:class => "name") { link_to(artist.name, artist_path(artist)) }
          end
        end
      end
    end
  end

  index do
    column :name, :sortable => :name do |resource|
      span link_to resource.name, artist_path(resource)
      small time_ago_in_words resource.updated_at
    end

    column :tags do |resource|
      raw resource.genres.take(10).map { |g| link_to g.name, genre_artists_path(g) }.to_sentence
    end

    column :play_count, :sortable => :play_count do |resource|
      number_to_percentage(resource.play_count.to_f / resource.class.maximum(:play_count).to_f * 100.0)
    end

    column :listeners, :sortable => :listeners do |resource|
      number_to_percentage(resource.listeners.to_f / resource.class.maximum(:listeners).to_f * 100.0)
    end

    column :stream do |resource|
      link_to "Stream", "javascript:AudioPlayer.playTracks([#{resource.tracks.map(&:id).join(", ")}])", :class => "button"
    end
  end

# ajax

  member_action :random_track do
    track = resource.tracks.sample || resource.releases.map(&:tracks).flatten.sample
    respond_to do |format|
      format.json do
        render :json => {
            :id => track.id,
            :artist => (track.artist.name rescue " Unknown "),
            :title => track.title,
            :stream_uri => stream_track_path(track)
        }
      end
    end
  end

  # metadata

  action_item :only => :show do
    link_to(icon(:reload) + " Update metadata ", update_metadata_artist_path(resource))
  end

  member_action :update_metadata do
    resource.update_metadata
    redirect_to resource
  end

  # sidebars

  sidebar :details, :only => :show do
    attributes_table_for(resource) do
      row :listeners
      row :play_count
      row :lastfm_url
      row(:stream) { link_to "Stream", "javascript:AudioPlayer.playTracks([#{resource.tracks.map(&:id).join(", ")}])", :class => "button" }
    end

    image_tag(resource.image_url) unless resource.image_url.blank?
  end

  sidebar :tags, :only => :show do
    ul do
      resource.genres.map do |genre|
        li link_to genre.name, genre_artists_path(genre)
      end
    end
  end
end
