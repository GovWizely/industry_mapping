ActiveAdmin.register Topic, as: 'FailedLookup' do
  menu label: proc { "Failed Lookups [#{ Topic.where(sector: nil).count }]" }, priority: 1337

  actions :index

  index do
    column :name
    column :updated_at
    actions defaults: false do |topic|
      link_to 'Fix', edit_admin_topic_path(topic)
    end
  end

  controller do
    def scoped_collection
      Topic.where(sector: nil)
    end
  end
end
