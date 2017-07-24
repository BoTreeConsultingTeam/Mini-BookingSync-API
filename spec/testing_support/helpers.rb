module TestingSupport
  module Helpers
    def json_response
      case body = JSON.parse(response.body)
        when Hash
          body.with_indifferent_access
        when Array
          body
      end
    end

    def assert_not_found!
      expect(json_response).to eq({ "error" => "The resource you were looking for could not be found." })
      expect(response.status).to eq 404
    end

    def assert_unauthorized!
      expect(json_response).to eq({ "error" => "You are not authorized to perform that action." })
      expect(response.status).to eq 401
    end
  end
end