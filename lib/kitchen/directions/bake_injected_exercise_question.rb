# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseQuestion
  def self.v1(question:, number:)
    V1.new.bake(question: question, number: number)
  end

  class V1
    def bake(question:, number:)
      # TODO: store label in pantry

      # Synthesize multiple choice solution
      question_answers = question.first('ol[data-type="question-answers"]')&.cut
      if question_answers
        letter_answer = map_correctness_to_letter_answer(answers: question_answers)
      end
      if letter_answer
        question.append(child:
          <<~HTML
            <div data-type="question-solution">#{letter_answer}</div>
          HTML
        )
      end

      # Bake question
      problem_number = "<span class='os-number'>#{number}</span>"
      if question.search('div[data-type="question-solution"]')&.first
        question.add_class('os-hasSolution')
        problem_number = "<a class='os-number' href='#solution-ref'>#{number}</a>" # TODO: link to solution ID
      end

      question_stimulus = question.first('div[data-type="question-stimulus"]')&.cut
      question_stem = question.first('div[data-type="question-stem"]').cut
      question.prepend(child:
        <<~HTML
          #{problem_number}
          <span class='os-divider'>. </span>
          <div class="os-problem-container">
            #{question_stimulus&.paste}
            #{question_stem.paste}
            #{question_answers&.paste}
          </div>
        HTML
      )

      # Bake solution
      solution = question&.first('div[data-type="question-solution"]')
      return unless solution

      solution.replace_children(with:   # TODO: link to exercise/question ID
        <<~HTML
          <a class='os-number' href='#exercise-ref'>#{number}</a>
          <span class='os-divider'>. </span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end

    def map_correctness_to_letter_answer(answers:)
      letter_answer = ''
      alphabet = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
      answers.search('li[data-type="question-answer"]').each_with_index do |answer, index|
        correctness = answer[:'data-correctness'].to_i
        if correctness == 1
          letter_answer += letter_answer.empty? ? alphabet[index] : ", #{alphabet[index]}"
        end
      end
      letter_answer.empty? ? nil : letter_answer
    end
  end
end
