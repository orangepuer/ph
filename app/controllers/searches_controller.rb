class SearchesController < ApplicationController
  def show
    search_result if params[:search_query] && params[:search_query].length > 0
  end

  private

  def search_result
    @search_result = Services::Search.search_result(params[:search_type], params[:search_query])
  end
end