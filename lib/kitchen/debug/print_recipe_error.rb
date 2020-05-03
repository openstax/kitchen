require 'rainbow'

module Kitchen
  module Debug

    CONTEXT_LINES = 2

    def self.print_recipe_error(error:, source_location:, document:)
      error_location = error.backtrace.detect do |entry|
        entry.start_with?(source_location)
      end

      error_filename, error_line_number = error_location.match(/(.*):(\d+):/)[1..2]
      error_line_number = error_line_number.to_i

      puts "The recipe has an error: " + Rainbow(error.message).bright +
           " at or near the following #{Rainbow('highlighted').red} line"
      puts "\n"
      puts "-----+ #{Rainbow(error_filename).bright} -----"

      line_numbers_before = (error_line_number-CONTEXT_LINES..error_line_number-1)
      line_numbers_after  = (error_line_number+1..error_line_number+CONTEXT_LINES)

      File.readlines(error_filename).each.with_index do |line, line_index|
        line_number = line_index + 1

        if line_numbers_before.include?(line_number) ||
           line_numbers_after.include?(line_number)
          print_file_line(line_number, line)
        end

        if line_number == error_line_number
          print_file_line(line_number, Rainbow(line.chomp).red)
        end
      end

      puts "\n"

      print_specific_help_line(error)

      current_node = document&.location&.raw

      if current_node
        puts "Encountered on line #{Rainbow(current_node.line).red} in the input document on element:"
        puts current_node.dup.tap{|node| node.inner_html="..." if node.inner_html != ""}.to_s
        puts "\n"
      end
    end

    protected

    def self.print_file_line(line_number, line)
      puts "#{"%5s" % line_number}| #{line}"
    end

    def self.print_specific_help_line(error)
      help_line = case error.message
      when /undefined method .each/
        "`each` needs to be called on a document or element object"
      when /undefined method .first/
        "`first` needs to be called on a document or element object"
      else
        nil
      end

      if !help_line.nil?
        puts help_line
        puts "\n"
      end
    end

  end
end
