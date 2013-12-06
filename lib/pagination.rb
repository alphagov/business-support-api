require 'link_header'

module Pagination

  def paginate(results, page_param, page_size)
    page_number = Integer(page_param || 1)
    page_size = Integer(page_size || 50)

    start_index = (page_number - 1) * page_size

    if results.size > page_size
      page = results.to_a.slice(start_index, page_size)
    else
      page = results
    end
    PaginatedResultSet.new(page, page_number, page_size, results.size)
  rescue ArgumentError
    raise "Invalid page number: #{page_param.inspect}"
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
      whole_pages, part_page_size = total.divmod(page_size)
      whole_pages += 1 if part_page_size > 0
      whole_pages
    end

    def results
      @results ||= @scope.to_a
    end

    def links
      @links || [].freeze
    end

    def first_page?
      page_number == 1
    end

    def last_page?
      page_number == pages
    end

    # Populate the inter-page links on this result set.
    #
    # The `generate_link` block should take a page number and return a URL.
    def populate_page_links(&generate_link)
      @links = []

      unless last_page?
        links.push LinkHeader::Link.new(
          generate_link.call(page_number + 1),
          [["rel", "next"]]
        )
      end
      unless first_page?
        links.push LinkHeader::Link.new(
          generate_link.call(page_number - 1),
          [["rel", "previous"]]
        )
      end

      @links.freeze
    end
  end
end
