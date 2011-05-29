ActiveAdmin.register Source do
  index do
    column :path do |resource|
      code resource.path
    end
    default_actions
  end
end
