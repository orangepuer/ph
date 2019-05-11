require 'rails_helper'

RSpec.describe 'Services::Search' do
  Services::Search::SEARCH_TYPES.each_value do |search_type|
    it "calls #{search_type}.search" do
      expect(search_type).to receive(:search).with('search query')
      Services::Search.search_result("#{search_type}", 'search query')
    end
  end
end