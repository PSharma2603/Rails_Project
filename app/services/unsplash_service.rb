# app/services/unsplash_service.rb
class UnsplashService
    include HTTParty
    base_uri "https://api.unsplash.com"
  
    def initialize
      @access_key = "2I-utjV34D-qHvUh1KXVy9LAaRKjZJLbIfZb2kt9gJk"
    end
  
    def fetch_image_url(query)
      response = self.class.get("/search/photos", query: {
        client_id: @access_key,
        query: query,
        per_page: 1
      })
  
      if response.success? && response["results"].any?
        response["results"][0]["urls"]["regular"]
      else
        nil
      end
    end
  end
  