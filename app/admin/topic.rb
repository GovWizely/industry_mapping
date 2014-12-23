ActiveAdmin.register Topic do
  menu :priority => 100
  permit_params :name, :sector_id
  index do
    column :name
    column :updated_at
    column :sector
    actions
  end
end
