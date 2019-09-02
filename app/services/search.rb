class Services::Search
  ALLOWED_SCOPES = %w[thinking_sphinx user comment question answer].freeze

  def perform(scope, query)
    return unless ALLOWED_SCOPES.include?(scope)

    scope.classify.constantize.search(Riddle.escape(query))
  end
end
