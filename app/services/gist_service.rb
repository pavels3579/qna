class GistService
  def initialize(gist_link, client: default_client)
    @gist_id = gist_link.split('/').last
    @client = client
  end

  def content
    gist_files.each_with_object([]) do |file, output|
      output << {file_name: fetch_file_name(file), file_content: fetch_file_content(file)}
    end
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end

  def gist_files
    gist_hash.keys
  end

  def fetch_file_name(file)
    gist_hash[file].to_hash[:filename]
  end

  def fetch_file_content(file)
    gist_hash[file].to_hash[:content]
  end

  def gist_hash
    @client.gist(@gist_id).attrs[:files].attrs.to_hash
  end
end
