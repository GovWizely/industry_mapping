namespace :protege do
  desc 'Import Industries and Sectors from Protege'
  task :import, [:arg] => :environment do |_t, args|
    ProtegeImporter.new.import
  end
end
