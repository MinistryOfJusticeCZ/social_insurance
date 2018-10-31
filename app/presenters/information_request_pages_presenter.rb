class InformationRequestPagesPresenter < CzegovPublishingComponents::QuestionPagesPresenter

  def path_prefix
    'information_requests'
  end

  def pages
    p = [{path: 'question_pages/one', title: 'O kom informace požadujete?'}]
    p << {path: 'question_pages/two'}
    p << {path: 'question_pages/two_father'} if both_parents?
    p
  end

  def both_parents?
    true
  end

end
