require "kitchen/version"

require "nokogiri"
require "active_support/all"

module Kitchen
end

require "kitchen/errors"
require "kitchen/ancestor"
require "kitchen/element_enumerator"
require "kitchen/element_enumerator_factory"
require "kitchen/page_element_enumerator"
require "kitchen/term_element_enumerator"
require "kitchen/chapter_element_enumerator"
require "kitchen/book_element_enumerator"
require "kitchen/figure_element_enumerator"
require "kitchen/table_element_enumerator"
require "kitchen/example_element_enumerator"
require "kitchen/document"
require "kitchen/element"
require "kitchen/debug/print_recipe_error"
require "kitchen/generators/container"
require "kitchen/recipe"
require "kitchen/book_recipe"
require "kitchen/oven"
require "kitchen/clipboard"
require "kitchen/pantry"
require "kitchen/counter"
require "kitchen/book_document"
require "kitchen/book_element"
require "kitchen/chapter_element"
require "kitchen/example_element"
require "kitchen/page_element"
require "kitchen/term_element"
require "kitchen/figure_element"
require "kitchen/table_element"
require "kitchen/note_element"
require "kitchen/note_element_enumerator"
require "kitchen/directions/reformat_introduction"
require "kitchen/directions/move_title_text_into_span"
require "kitchen/directions/process_figure"
require "kitchen/directions/process_notes"
require "kitchen/directions/process_numbered_table"
require "kitchen/directions/process_unnumbered_tables"
require "kitchen/directions/bake_appendix"
require "kitchen/directions/bake_example"
require "kitchen/directions/bake_math_in_paragraph"
require "kitchen/directions/bake_chapter_glossary"
require "kitchen/directions/bake_chapter_summary"
require "kitchen/directions/bake_chapter_exercises"
require "kitchen/directions/bake_chapter_key_equations"
require "kitchen/directions/bake_exercises"
require "kitchen/directions/bake_index"
require "kitchen/directions/bake_toc"
require "kitchen/patches"


I18n.load_path << Dir[File.expand_path(__dir__ + "/locales") + "/*.yml"]
