class InformationRequestPagesPresenter < CzegovPublishingComponents::QuestionPagesPresenter

  def path_prefix
    'information_requests'
  end

  def pages
    p = [{path: 'question_pages/one', title: 'O kom informace požadujete?'}]
    p << {path: 'question_pages/two', title: individual? ? 'Základní údaje požadované osoby' : 'Základní údaje matky požadované osoby'}
    p << {path: 'question_pages/two_father'} if both_parents?
    p
  end

  def both_parents?
    model.insured_person_type == 'parents-both'
  end

  def individual?
    model.insured_person_type == 'individual'
  end

end
