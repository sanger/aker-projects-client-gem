require "study_client/version"
require "json_api_client"

module StudyClient

    class Base < JsonApiClient::Resource
        self.site = ENV['STUDY_URL']
    end

    class Node < Base
        def cost_code
            attributes['cost-code']
        end
    end

    class Collection < Node
        # This is not really a collection. It is a node with a set-id.
        def set_id
            attributes['set-id']
        end
    end
end
