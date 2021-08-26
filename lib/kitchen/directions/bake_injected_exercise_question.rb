# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExerciseQuestion
  def self.v1(question:, number:, only_number_solution: false)
    V1.new.bake(question: question, number: number, only_number_solution: only_number_solution)
  end

  class V1
    def bake(question:, number:, only_number_solution:)
      # TODO: store label in pantry

      # Synthesize multiple choice solution
      if question.answers
        case question.answers[:type]
        when 'a'
          alphabet = *('a'..'z')
        else
          raise('Unsupported list type for multiple choice options')
        end
        letter_answers = question.correct_answer_letters(alphabet)
        letter_answer = letter_answers.empty? ? nil : letter_answers.join(', ')
      end
      if letter_answer
        question.append(child:
          <<~HTML
            <div data-type="question-solution">#{letter_answer}</div>
          HTML
        )
      end

      # Bake question
      unless only_number_solution
        problem_number = "<span class='os-number'>#{number}</span>"
        if question.solution
          problem_number = "<a class='os-number' href='#solution-ref'>#{number}</a>" # TODO: link to solution ID
        end
      end

      question_stimulus = question.stimulus&.cut
      question_stem = question.stem.cut
      question_answers = question.answers&.cut
      question.prepend(child:
        <<~HTML
          #{problem_number unless only_number_solution}
          #{"<span class='os-divider'>. </span>" unless only_number_solution}
          <div class="os-problem-container">
            #{question_stimulus&.paste}
            #{question_stem.paste}
            #{question_answers&.paste}
          </div>
        HTML
      )

      # Bake solution
      solution = question.solution
      return unless solution

      question.add_class('os-hasSolution')
      solution.replace_children(with:   # TODO: link to exercise/question ID
        <<~HTML
          <a class='os-number' href='#exercise-ref'>#{number}</a>
          <span class='os-divider'>. </span>
          <div class="os-solution-container">#{solution.children}</div>
        HTML
      )
    end
  end
end
