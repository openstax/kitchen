# frozen_string_literal: true

module Kitchen::Directions::BakeChapterIntroductions
  class BakeChapterObjectives
    def bake(chapter:, strategy:)
      case strategy
      when :default
        chapter_objectives_note = chapter.notes('$.chapter-objectives').first

        # trash existing title
        chapter_objectives_note.titles.first&.trash
        Kitchen::Directions::BakeAutotitledNotes.v1(
          book: chapter,
          classes: %w[chapter-objectives],
          bake_subtitle: false
        )

        chapter_objectives_note.cut.paste
      when :none
        ''
      else
        raise 'No such strategy'
      end
    end
  end
end
