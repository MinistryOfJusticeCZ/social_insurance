module CzegovPublishingComponents
  class QuestionPagesPresenter

    attr_accessor :model, :page_number, :options, :confirmed

    def initialize(model, **options)
      @model = model
      @page_number = options[:page_number] ? options[:page_number].to_i : 1
      @confirmed = !!options[:confirmed]
      @options = options
    end

    def path_prefix
      options[:path_prefix]
    end

    def answer(question)
      ans = model
      question.split('-').each do |meth|
        if meth.starts_with?('[')
          ans = ans[meth[1..-2].to_i]
        else
          ans = ans.send(meth)
        end
      end
      ans
    end

    def to_partial_path
      if pages.size < page_number
        'czegov_publishing_components/patterns/check_answers'
      else
        'czegov_publishing_components/patterns/question_pages'
      end
    end

    def page(page_number)
      pages[page_number - 1]
    end

    def current_page
      page(page_number)
    end

    def page_partial_path(page_number=self.page_number)
      path = page(page_number)[:path]
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

    def last_page?
      page_number >= pages.size
    end

    def confirmed?
      @confirmed
    end

    def current_valid?
      true
    end

    def next_page!
      @page_number += 1
    end

    def pages
      @pages ||= []
    end

  end
end
