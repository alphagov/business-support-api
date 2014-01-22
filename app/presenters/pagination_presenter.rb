class PaginationPresenter

  attr_reader :results, :link_helper

  def initialize(results, link_helper)
    @results = results
    @link_helper = link_helper
  end

  def as_json(options={})
    {
      :_response_info => {
        :status => "ok",
        :links => link_helper.links,
      },
      :total => results.total,
      :start_index => results.start_index,
      :page_size => results.results.size,
      :current_page => results.page_number,
      :pages => results.pages,
      :results => results.results
    }
  end
end
