ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc { I18n.t("active_admin.dashboard") }

  content :title => proc { I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Industries" do
          link_to Industry.count, admin_industries_path
        end
      end

      column do
        panel "Sectors" do
          link_to Sector.count, admin_sectors_path
        end
      end

      column do
        panel "Emenus" do
          link_to Emenu.count, admin_emenus_path
        end
      end

    end
  end # content
end
