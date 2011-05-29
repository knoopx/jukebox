module ActiveAdmin
  module Views

    class ReleasePanel < ActiveAdmin::Component
      builder_method :release_panel

      def build(release, attributes = {})
        super(attributes)
        add_class "panel release"
        @title = h3(auto_link(release.name))
      end
    end
  end
end