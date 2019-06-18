module ApplicationHelper
  require_relative '../../app/services/gist_service'

  def gist?(link)
    link.include?('gist.github.com')
  end
end
