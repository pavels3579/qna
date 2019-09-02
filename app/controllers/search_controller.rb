class SearchController < ApplicationController

  skip_authorization_check

  def index
    @results = Services::Search.new.perform(params[:scope], params[:search])
    return head :bad_request unless @result
  end
end
