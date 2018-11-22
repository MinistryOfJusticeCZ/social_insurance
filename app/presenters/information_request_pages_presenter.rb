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
      title:  if individual?
                'Základní údaje požadované osoby'
              elsif father?
                'Základní údaje otce požadované osoby'
              else
                'Základní údaje matky požadované osoby'
              end
      questions: insured_person_questions
    }
    p << {
      path: 'question_pages/two_father',
      title: 'Základní údaje otce požadované osoby',
      questions: insured_person_questions('insured_people-[1]')
    } if both_parents?
    p << {
      path: 'question_pages/three',
      title: 'Jaké informace žádáte?',
      questions: ['request_employments']
    }
    p << {
      path: 'question_pages/four',
      title: 'Jaký je důvod vaší žádosti?',
      questions: ['request_legitimacy_reason']
    }
    p
  end

  def insured_person_questions(prefix='insured_people-[0]')
    %w{firstname lastname birth_lastname birth_date birth_number birth_place}.map do |q|
      {name: prefix+'-'+q, label: I18n.t('model_attributes.insured_person.'+q)}
    end
  end

  def both_parents?
    model.insured_person_type == 'parents'
  end

  def individual?
    model.insured_person_type == 'individual'
  end

  def mother?
    model.insured_person_type == 'mother'
  end

  def father?
    model.insured_person_type == 'father'
  end

end
