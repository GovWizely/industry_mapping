class ImportGoogleDoc

  def initialize
    ensure_env_vars
    access_token = ENV['GOOGLE_ACCESS_TOKEN'] || fetch_access_token
    @session = GoogleDrive.login_with_oauth(access_token)
    @sheet_key = "0AmVFCQHMYJ2cdGJRLW1ubWtpU0JzOGZsZjk2b1k3OXc"
    @logger = Logger.new("#{Rails.root}/log/import_google_doc.log")
  end

  def call
    all = @session.spreadsheet_by_key(@sheet_key).worksheets
    formatted = all.find_all { |s| s.title =~ /^source: / }

    formatted.each do |worksheet|
      columns = worksheet.rows.first
      unless columns.include?('topic') && columns.include?('industry')
        @logger.warn("WORKSHEET [#{worksheet.title}] doesn't have 'topic' and 'industry' columns. Skipping.")
        next
      end

      source = Source.find_or_create_by(name: worksheet.title.sub(/^source: /, '')) do |source|
        @logger.info("SOURCE    [#{source.name}] created -------------------")
      end

      worksheet.list.each do |listrow|
        unless listrow['topic'] && listrow['industry']
          @logger.warn("ROW       [#{listrow.to_s}] doesn't have 'topic' and 'industry' entries. Skipping.")
          next
        end

        industry = Industry.find_or_create_by(name: listrow['industry'])
        sector = Sector.find_or_create_by(
                  name: listrow['sector'] || listrow['industry'],
                  industry_id: industry.id)
        Topic.find_or_create_by(name: listrow['topic'], sector_id: industry.id, source_id: source.id) do |topic|
          @logger.info("TOPIC     [#{topic.name}] created.")
        end
      end
      @logger.info("SOURCE    [#{source.name}] import complete -----------")
    end
  end

  private

  def ensure_env_vars
    unless ENV['GOOGLE_ACCESS_TOKEN'] || (ENV['GOOGLE_CLIENT_ID'] && ENV['GOOGLE_CLIENT_SECRET'])
      fail 'Gimme GOOGLE_ACCESS_TOKEN, or GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET'
    end
  end

  def fetch_access_token

    client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = ENV['GOOGLE_CLIENT_ID']
    auth.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    auth.scope = "https://www.googleapis.com/auth/drive " +
                 "https://spreadsheets.google.com/feeds/"
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

    print "1. Open this page:\n%s\n\n" % auth.authorization_uri
    print "2. Enter the authorization code shown in the page: "
    auth.code = $stdin.gets.chomp
    auth.fetch_access_token!

    access_token = auth.access_token
    puts "Access token #{access_token} was issued. You can skip this "  \
         "authorization step by directly passing the access token via " \
         "the GOOGLE_ACCESS_TOKEN environment variable."
    access_token
  end

end
