module Pagination

  def paginate(results, page_number, page_size)
    page_size = sane_page_size(page_size)
    page_count = Pagination.page_count(results.size, page_size)
    page_number = sane_page_number(page_count, page_number)

    start_index = (page_number - 1) * page_size

    if results.size > page_size
      page = results.to_a.slice(start_index, page_size)
    else
      page = results
    end
    PaginatedResultSet.new(page, page_number, page_size, results.size)
  end

  def sane_page_number(page_count, page_number_param)
    page_number = page_number_param.to_i
    page_number = 1 if page_number < 1
    page_number = page_count if page_number > page_count
    page_number
  end

  def sane_page_size(page_size_param)
    page_size = page_size_param.to_i
    page_size = 50 if page_size < 1
    page_size
  end

  def self.page_count(total, page_size)
    whole_pages, part_page_size = total.divmod(page_size)
    whole_pages += 1 if part_page_size > 0
    whole_pages
  end

  class PaginatedResultSet

    attr_reader :page_number, :page_size, :total

    def initialize(scope, page_number, page_size, total)
      @scope = scope
      @page_number = page_number
      @page_size = page_size
      @total = total
    end

    def start_index
      (page_size * (page_number - 1)) + 1
    end

    def pages
      Pagination.page_count(total, page_size)
    end

    def results
      @results ||= @scope.to_a
    end

    def first_page?
      page_number == 1
    end

    def last_page?
      page_number == pages
    end
  end
end
