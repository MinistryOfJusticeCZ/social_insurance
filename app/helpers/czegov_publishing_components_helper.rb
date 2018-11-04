module CzegovPublishingComponentsHelper

  def question_pages_page_path(pages, page_number=self.page_number)
    new_polymorphic_path(pages.model, page_number: page_number)
  end

end
