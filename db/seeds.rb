require 'csv'

default_source = Source.find_or_create_by(name: 'default')

CSV.foreach("#{Rails.root}/lib/data/industry_taxonomy.csv", :headers => :first_row) do |row|
  industry_str, industry_sector_str, topic_industry_code_str, topic_industry_str = row[0], row[1], row[2], row[3]
  industry = Industry.find_or_create_by!(name: industry_str.strip)
  sector = industry.sectors.find_or_create_by!(name: industry_sector_str.strip)
  sector.topics.find_or_create_by(name: topic_industry_str.strip) do |t|
    t.source = default_source
  end
end