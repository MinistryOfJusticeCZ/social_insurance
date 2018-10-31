class InformationRequestPagesPresenter < CzegovPublishingComponents::QuestionPagesPresenter

  def pages
    p = [{path: 'question_pages/one'}]
    p << {path: 'question_pages/two'}
    p << {path: 'question_pages/two_father'} if both_parents?
    p
  end

  def both_parents?
    true
  end

end
