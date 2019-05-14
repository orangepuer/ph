require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    Services::Search::SEARCH_TYPES.each_value do |search_type|
      it "calls Services::Search.search_result for #{search_type}" do
        expect(Services::Search).to receive(:search_result).with("#{search_type}", 'search query')
        get :show, params: { search_type: search_type, search_query: 'search query' }
      end
    end

    it 'render template show' do
      get :show
      expect(response).to render_template :show
    end
  end
end