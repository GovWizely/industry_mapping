require 'csv'

CSV.foreach("#{Rails.root}/lib/data/industry_taxonomy.csv", :headers => :first_row) do |row|
  industry_name, sector_name, topic_name, source_name = row[0], row[1], row[2], row[3]

  industry = Industry.find_or_create_by!(name: industry_name)
  source = Source.find_or_create_by!(name: source_name)

  sector = industry.sectors.find_or_create_by!(name: sector_name)
  sector.topics.find_or_create_by!(name: topic_name, source: source)
end

