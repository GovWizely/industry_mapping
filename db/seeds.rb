require 'csv'

CSV.foreach("#{Rails.root}/lib/data/industry_taxonomy.csv", :headers => :first_row) do |row|
  industry_str, industry_sector_str, emenu_industry_code_str, emenu_industry_str = row[0], row[1], row[2], row[3]
  industry = Industry.find_or_create_by!(name: industry_str.strip)
  sector = industry.sectors.find_or_create_by!(name: industry_sector_str.strip)
  sector.emenus.find_or_create_by!(name: emenu_industry_str.strip)
end