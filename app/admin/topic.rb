ActiveAdmin.register Topic do
  menu priority: 100
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
      input :sector,
            as:         :select,
            input_html: {
              'data-option-dependent' => true,
              'data-option-url'       => '/industries/:industry/sectors',
              'data-option-observed'  => 'industry',
            },
            collection: (resource.industry ? resource.industry.sectors.collect { |sector| [sector.name, sector.id] } : [])
      input :source
    end
    actions
  end
end
