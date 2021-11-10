# frozen_string_literal: true

module Kitchen::Directions::BakeInjectedExercise
  def self.v1(exercise:)
    V1.new.bake(exercise: exercise)
  end

  class V1
    def bake(exercise:)
      context = exercise.exercise_context

      return unless context

      # link replacement is done by BakeLinkPlaceholders
      link = context.first('a').cut
      context.replace_children(with: "#{I18n.t(:context_lead_text)}#{link.paste}")
      figure_context = context&.cut
      question = exercise.exercise_question
      question.append(child:
        <<~HTML
          #{figure_context}
        HTML
      )
    end
  end
end
