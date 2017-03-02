require "study_client/version"
require "json_api_client"

module StudyClient
    class Base < JsonApiClient::Resource
        self.site = ENV['STUDY_URL']
    end

    class Node < Base
        def cost_code
            self.send('cost-code')
        end
    end
end
