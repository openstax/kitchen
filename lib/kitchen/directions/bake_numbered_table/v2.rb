# frozen_string_literal: true

module Kitchen::Directions::BakeNumberedTable
  class V2
    def bake(table:, number:)
      # The differences include:
      # Adding a space to the end of the os-table class (to match original)
      # Makes sure there's a caption span in every caption-container, whether there's a caption or no
      # adds a possibility of a os-title span if one can be found within the caption
      # adds the text from the os-title span
      table.wrap(%(<div class="os-table ">))

      table_label = "#{I18n.t(:table_label)} #{number}"
      table.document.pantry(name: :link_text).store table_label, label: table.id

      if table.top_titled?
        table.parent.add_class('os-top-titled-container')
        table.prepend(sibling:
          <<~HTML
            <div class="os-table-title">#{table.title}</div>
          HTML
        )
        table.title_row.trash
      end

      table.parent.add_class('os-column-header-container') if table.column_header?

      # TODO: Why is F critical values (continued) tacked on to the end?
      # space after os-table?
      new_summary = "#{table_label} "
      new_caption_text = ''
      caption_title = ''

      if (title = table.first("span[data-type='title']")&.cut)
        new_summary += "#{title.text} "
        caption_title = <<~HTML
          \n<span class="os-title" data-type="title">#{title.children}</span>
        HTML
      end

      if (caption = table.caption&.cut)
        new_summary += caption.text
        new_caption_text = caption.children
      end

      table[:summary] = new_summary

      return if table.unnumbered?

      table.append(sibling:
        <<~HTML
          <div class="os-caption-container">
            <span class="os-title-label">#{I18n.t(:table_label)} </span>
            <span class="os-number">#{number}</span>
            <span class="os-divider"> </span> #{caption_title}
            <span class="os-divider"> </span>
            <span class="os-caption">#{new_caption_text}</span>
          </div>
        HTML
      )
    end
  end
end
