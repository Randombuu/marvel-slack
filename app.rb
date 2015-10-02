# encoding: utf-8
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

post "/" do
  begin
    puts "[LOG] #{params}"
    params[:text] = params[:text].sub(params[:trigger_word], "").strip
    unless params[:token] != ENV["OUTGOING_WEBHOOK_TOKEN"]
      response = { text: "Marvel Results:" }
      response[:attachments] = [ generate_attachment ]
      response[:username] = ENV["BOT_USERNAME"] unless ENV["BOT_USERNAME"].nil?
      response[:icon_emoji] = ENV["BOT_ICON"] unless ENV["BOT_ICON"].nil?
      response = response.to_json
    end
  end
  status 200
  body response
end

def generate_attachment
  user_query = params[:text]

  # Marvel logic
  client = Marvelite::API::Client.new( :public_key => ENV["MARVEL_PUBLIC_KEY"], :private_key => ENV["MARVEL_PRIVATE_KEY"])

  generalquery = client.characters(:nameStartsWith => "#{user_query}", :limit => 1)
  @resultscheck = generalquery[:data][:results][0]

if @resultscheck.nil?
  response = { title: "No results", text: "The Marvel API returns characters with names that begin with the specified string. Try a different spelling or abbreviation (ex: Ms. Marvel vs Miss Marvel) and try again." }
else
  @id = generalquery[:data][:results][0][:id]
  @name = generalquery[:data][:results][0][:name]
  @description = generalquery[:data][:results][0][:description]
  @url = generalquery[:data][:results][0][:urls][0][:url]
  @comics = generalquery[:data][:results][0][:comics][:available]
  @series = generalquery[:data][:results][0][:series][:available]
  @thumbnailpath = generalquery[:data][:results][0][:thumbnail][:path]
  @thumbnailext = generalquery[:data][:results][0][:thumbnail][:extension]
  @thumb_url = "#{@thumbnailpath}.#{@thumbnailext}"

  issuequery = client.comics(:characters => "#{@id}", :orderBy => '-focDate', :limit => 1)
  @issueresultscheck = issuequery[:data][:results][0]
if @issueresultscheck.nil?
  @latest = "No comic information for this character"
  @latesturl = "http://marvel.com/comics/"
else
  @latest = issuequery[:data][:results][0][:title]
  @latesturl = issuequery[:data][:results][0][:urls][0][:url]
end

  # response
  response = { title: "#{@name}", title_link: "#{@url}", text: "#{@description}", thumb_url: "#{@thumb_url}", fields: [ { title: "Comics", value: "#{@comics}", short: true }, { title: "Series", value: "#{@series}", short: true }, { title: "Most recent", value: "<#{@latesturl}|#{@latest}>", short: false } ] }
end

end
