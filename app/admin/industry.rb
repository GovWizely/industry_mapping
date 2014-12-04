ActiveAdmin.register Industry do
  permit_params :name

  index do
    column :name
    column :updated_at
    column :sectors do |industry|
      links = industry.sectors.collect do |sector|
        link_to sector.name, admin_sector_path(sector)
      end
      links.join(', ').html_safe
    end
    actions
  end

  controller do
    def scoped_collection
      Industry.includes(:sectors)
    end
  end

  show do |industry|
    attributes_table do
      row :id
      row :name
      row :updated_at
      row :created_at
    end
    panel "Sectors" do
      table_for industry.sectors do
        column "sector name" do |sector|
          link_to sector.name, admin_sector_path(sector)
        end
      end
    end
    active_admin_comments
  end
end
