# frozen_string_literal: true

class SuggestionService
  include HTTParty

  base_uri "#{ENV.fetch("REVERSE_SERVICE")}"

  headers 'Content-Type': "application/json"

  attr_accessor :reverse_response

  def reverse(lat:, lon:)
    path = "/api/v1/reverse"
    self.class.get(
      path,
      query: { lat:, lon: },
    ).parsed_response
  end
end
