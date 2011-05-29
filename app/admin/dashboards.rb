ActiveAdmin::Dashboards.build do
  section "Recenlty added releases" do
    ul do
      Release.recent(20).map do |resource|
        li do
          span link_to(resource.name, release_path(resource))
          small time_ago_in_words(resource.created_at)
        end
      end
    end
  end

  section "Recenlty added artists" do
    ul do
      Artist.recent(20).map do |resource|
        li do
          span link_to(resource.name, artist_path(resource))
          small time_ago_in_words(resource.created_at)
        end
      end
    end
  end

  section "Top Genres" do
    ul do
      Genre.top(20).map do |resource|
        li link_to("#{resource.name} (#{resource.artists_count})", genre_artists_path(resource))
      end
    end
  end
end