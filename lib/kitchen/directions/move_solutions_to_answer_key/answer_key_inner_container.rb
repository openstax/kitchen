# frozen_string_literal: true

module Kitchen::Directions::AnswerKeyInnerContainer
  def self.v1(chapter:, metadata_source:, append_to:, solutions_plural: true)
    V1.new.bake(
      chapter: chapter,
      metadata_source: metadata_source,
      append_to: append_to,
      solutions_plural: solutions_plural
    )
  end

  class V1
    renderable

    def bake(chapter:, metadata_source:, append_to:, solutions_plural:)
      @solutions_or_solution = solutions_plural ? 'solutions' : 'solution'
      @uuid_key = "#{@solutions_or_solution}#{chapter.count_in(:book)}"
      @metadata = metadata_source.children_to_keep.copy
      @composite_element = 'composite-page'
      @title = "#{I18n.t(:chapter)} #{chapter.count_in(:book)}"
      @main_title_tag = 'h2'

      append_to.append(
        child: render(file: '../book_answer_key_container/eob_answer_key_outer_container.xhtml.erb')
      ).first("div[data-uuid-key='.#{@uuid_key}']")

      # append_to.first("div[data-uuid-key='.#{@uuid_key}']")

      # return append_to.first("div[data-uuid-key='.#{@uuid_key}']") if strategy_options.empty?

      # DefaultStrategy.new(strategy_options).bake(
      #   chapter: chapter, append_to: append_to.first("div[data-uuid-key='.#{@uuid_key}']")
      # )
    end
  end
end
