module ApplicationHelper
  def play_count(resource)
    resource.play_count / resource.class.max(:play_count) * 100
  end
end
