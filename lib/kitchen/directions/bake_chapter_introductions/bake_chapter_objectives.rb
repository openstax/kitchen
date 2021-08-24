# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, chapter_objectives_strategy:)
      chapter_objectives_html = ''

      case chapter_objectives_strategy
      when :default
        # trash existing title
        chapter.notes('$.chapter-objectives').titles.first&.trash
        Kitchen::Directions::BakeAutotitledNotes.v1(
          book: chapter,
          classes: %w[chapter-objectives],
          bake_subtitle: false
        )
      when :none
        return
      else
        raise 'No such strategy'
      end

      chapter_objectives_html
    end
  end
end
