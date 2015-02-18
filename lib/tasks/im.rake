namespace :im do
  desc 'Import data "the Google doc"'
  task import_google_doc: :environment do
    ImportGoogleDoc.new.call
  end
end
