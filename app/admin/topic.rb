ActiveAdmin.register Topic do
  menu :priority => 100
  permit_params :name, :sector_id, :source_id

  index do
    column :name
    column :updated_at
    column :sector

    column :industry do |topic|
      topic.industry.try(:name)
    end

    actions
  end

  form do |f|
    f.inputs do
      input :industry, as: :industries
      input :sector
      input :source
    end
    actions
  end


end
