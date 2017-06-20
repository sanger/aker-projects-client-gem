require "spec_helper"

describe StudyClient do
  let(:content_type) { 'application/vnd.api+json' }
  let(:request_headers) { { 'Accept' => content_type, 'Content-Type'=> content_type } }
  let(:response_headers) { { 'Content-Type'=> content_type } }
  let(:url) { 'http://localhost:9999/api/v1/' }

  before do
    StudyClient::Base.site = url
  end

  describe '#VERSION' do
    it { expect(StudyClient::VERSION).not_to be_nil }
  end

  describe StudyClient::Node do
    describe '#find' do
      before do
        @id = "123"
        @name = "Bernard the node"
        @uuid = "0cfc5efd-6af3-4709-8ae3-0b322a5bbe9c"
        @costcode = 'S1234'

        stub_node(@id, @name, @costcode, @uuid)

        @rs = StudyClient::Node.find(@id)
        @node = @rs&.first
      end

      it 'finds one node' do
        expect(@rs).not_to be_nil
        expect(@rs.length).to eq(1)
      end

      it 'gives a node with the correct fields' do
        expect(@node).not_to be_nil
        expect(@node.id).to eq(@id)
        expect(@node.name).to eq(@name)
        expect(@node.node_uuid).to eq(@uuid)
        expect(@node.cost_code).to eq(@costcode)
      end
    end

    describe '#all' do
      before do
        @data = [
          node_data("1", "Alpha", nil, "0cfc5efd-6af3-4709-8ae3-0b322a5bbe9c"),
          node_data("2", "Beta", "S1234", "eca39b72-26bb-4530-b54c-9e331e2c6726"),
        ]
        stub_request(:get, url+'nodes').
          to_return(status: 200, body: { data: @data }.to_json, headers: response_headers)
      end
      it 'returns all nodes' do
        rs = StudyClient::Node.all
        expect(rs.length).to eq(@data.length)
        @data.zip(rs).each do |d, node|
          expect(node.id).to eq(d[:id])
          expect(node.name).to eq(d[:attributes][:name])
        end
      end
    end
  end

  describe StudyClient::Collection do
    describe '#all' do
      before do
        @setids = ['36981217-c9ca-4ed0-8b16-216881f45dc0', '91274116-df50-4d85-8250-653ec4a53fd0']
        data = @setids.each_with_index.map { |setid, i| collection_data(i.to_s, setid) }
        stub_request(:get, url+'collections').
          to_return(status: 200, body: { data: data }.to_json, headers: response_headers)
      end
      it 'returns the collections' do
        rs = StudyClient::Collection.all
        expect(rs.length).to eq(@setids.length)
        expect(rs.map { |c| c.set_id }).to eq(@setids)
      end
    end
  end

private

  def stub_node(id, name, cost_code, uuid)
    nodedata = node_data(id, name, cost_code, uuid)
    stub_request(:get, nodedata[:links][:self]).
      to_return(status: 200, body: { data: nodedata }.to_json, headers: response_headers)
  end

  def node_path(id)
    url+'nodes/'+id
  end

  def collection_path(id)
    url+'collections/'+id
  end

  def node_data(id, name, cost_code, uuid)
    {
      id: id,
      type: "nodes",
      links: { self: node_path(id) },
      attributes: {
        name: name,
        'cost-code' => cost_code,
        'node-uuid' => uuid,
      },
    }
  end

  def collection_data(id, setid)
    {
      id: id,
      type: "collections",
      links: { self: collection_path(id) },
      attributes: {
        'set-id' => setid,
      }
    }
  end

end
