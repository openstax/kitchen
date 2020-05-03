module Kitchen
  class Recipe

    attr_reader :document
    attr_reader :source_location

    ALLOWED_BLOCK_KEYWORD_ARGUMENTS = [:doc]

    def document=(document)
      @document =
        case document
        when Kitchen::Document
          document
        when Nokogiri::XML::Document
          Kitchen::Document.new(nokogiri_document: document)
        end
    end

    # Make a new Recipe
    #
    # @yieldparam doc [Document] an object representing an XML document, must be
    #   named `doc:`
    #
    def initialize(&block)
      @source_location = block.source_location[0]
      @block = block

      begin
        @block_keyword_arguments = @block.parameters.map do |parameter|
          type = parameter[0]
          argument = parameter[1]

          if !ALLOWED_BLOCK_KEYWORD_ARGUMENTS.include?(argument)
            raise RecipeError, "`#{argument}` is not an allowed argument"
          end

          if :opt == type
            raise RecipeError, "The `#{argument}` argument should be a keyword argument " \
                               "with a colon at the end, i.e. `#{argument}:`"
          end

          argument
        end
      rescue RecipeError => ee
        print_recipe_error_and_exit(ee)
      end
    end

    def node!
      node || raise("The recipe's node has not been set")
    end

    def bake
      begin
        # Only yield the arguments that are asked for by the block
        args = {
          doc: document
        }.slice(*@block_keyword_arguments)

        @block.to_proc.call(*[args])
      rescue RecipeError => ee
        print_recipe_error_and_exit(ee)
      rescue ArgumentError => ee
        if if_any_stack_file_matches_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue NoMethodError => ee
        if if_any_stack_file_matches_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue NameError => ee
        if if_stack_starts_with_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue ElementNotFoundError => ee
        print_recipe_error_and_exit(ee)
      rescue Nokogiri::CSS::SyntaxError => ee
        print_recipe_error_and_exit(ee)
      end
    end

    protected

    def if_stack_starts_with_source_location?(error)
      error.backtrace.first.start_with?(source_location)
    end

    def if_any_stack_file_matches_source_location?(error)
      error.backtrace.any? {|entry| entry.start_with?(@source_location)}
    end

    def print_recipe_error_and_exit(error)
      Kitchen::Debug.print_recipe_error(error: error,
                                        source_location: source_location,
                                        document: document)
      exit(1)
    end

  end
end
