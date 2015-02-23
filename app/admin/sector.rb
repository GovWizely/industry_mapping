ActiveAdmin.register Sector do
  permit_params :name, :industry_id
  index do
    column :name
    column :updated_at
    column :industry
    column :topics do |sector|
      links = sector.topics.collect do |topic|
        link_to topic.name, admin_topic_path(topic)
      end
      links.join(', ').html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Sector.includes(:topics)
    end
  end

  show do |sector|
    attributes_table do
      row :id
      row :industry
      row :name
      row :updated_at
      row :created_at
    end
    panel "Topics" do
      table_for sector.topics do
        column "topic name" do |topic|
          link_to topic.name, admin_topic_path(topic)
        end
      end
    end
  end


end
