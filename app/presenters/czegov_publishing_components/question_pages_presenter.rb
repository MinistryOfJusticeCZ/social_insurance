module CzegovPublishingComponents
  class QuestionPagesPresenter

    attr_accessor :model, :page_number

    def initialize(model)
      @model = model
      @page_number = 1
    end

    def current_page
      pages[page_number]
    end

    def page_path
      path = current_page[:path]
      if path.respond_to?(:call)
        path.call(model)
      elsif path.is_a?(Symbol)
        self.call(path)
      else
        path
      end
    end

    def pages
      @pages ||= []
    end

  end
end
