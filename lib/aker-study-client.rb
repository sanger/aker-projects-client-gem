require "aker-study-client/version"
require "json_api_client"

module StudyClient

  class Base < JsonApiClient::Resource
    self.site = ENV['STUDY_URL']

    has_many :permissions
  end

  class Node < Base
    def cost_code
      attributes['cost-code']
    end

    def node_uuid
      attributes['node-uuid']
    end
  end

  class Collection < Base
    # This 'collection' is actually a link between a node and a set
    def set_id
      attributes['set-id']
    end
  end

  class Permission < Base
  end
end
