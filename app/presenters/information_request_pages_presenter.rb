class InformationRequestPagesPresenter < CzegovPublishingComponents::QuestionPagesPresenter

  def path_prefix
    'information_requests'
  end

  def pages
    p = [{
      path: 'question_pages/one',
      title: 'O kom informace požadujete?',
      questions: ['insured_person_type']
    }]
    p << {
      path: 'question_pages/two',
      title: individual? ? 'Základní údaje požadované osoby' : 'Základní údaje matky požadované osoby',
      questions: insured_person_questions
    }
    p << {
      path: 'question_pages/two_father',
      title: 'Základní údaje otce požadované osoby',
      questions: insured_person_questions('insured_people-[1]')
    } if both_parents?
    # p << {path: 'question_pages/three'}
    p
  end

  def insured_person_questions(prefix='insured_people-[0]')
    %w{firstname lastname birth_lastname}.map{|q| prefix+'-'+q }
  end

  def both_parents?
    model.insured_person_type == 'parents'
  end

  def individual?
    model.insured_person_type == 'individual'
  end

end
