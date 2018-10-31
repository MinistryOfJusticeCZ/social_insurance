module CzegovPublishingComponents
  class QuestionPagesPresenter

    attr_accessor :model, :page_number, :options

    def initialize(model, **options)
      @model = model
      @page_number = 1
      @options = options
    end

    def path_prefix
      options[:path_prefix]
    end

    def current_page
      pages[page_number - 1]
    end

    def page_path
      path = current_page[:path]
      path = if path.respond_to?(:call)
              path.call(model)
            elsif path.is_a?(Symbol)
              self.call(path)
            else
              path
            end
      path_prefix ? "#{path_prefix}/#{path}" : path
    end

    def page_title
      current_page[:title]
    end

    def pages
      @pages ||= []
    end

  end
end
