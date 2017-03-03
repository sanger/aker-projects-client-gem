require "spec_helper"

describe StudyClient do
  it "has a version number" do
    expect(StudyClient::VERSION).not_to be nil
  end

  it "has a cost_code" do
    expect(StudyClient::Node.new).to respond_to :cost_code
  end

  it "is connected to the json api" do
    url='http://localhost:9999/api/v1/'
    id="123"
    StudyClient::Base.site=url

    stub_request(:get, url+"nodes/"+id).
         with(headers: {'Accept'=>'application/vnd.api+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/vnd.api+json', 'User-Agent'=>'Faraday v0.11.0'}).
         to_return(status: 200, body: "", headers: {})
    stub_request(:get, url+'/nodes')
        .to_return(status: 200, body: {id: id}.to_json, headers: {})

    expect(StudyClient::Node.find(id)).not_to be nil
  end
end
