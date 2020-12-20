module Kitchen
  # An object that yields a +Document+ for modification (those modifications are
  # the "recipe")
  #
  class Recipe

    # The document the recipe makes available for modification
    # @return [Document]
    attr_reader :document

    # The file location of the recipe
    # @return [String]
    attr_reader :source_location

    # Sets the document so the recipe can yield it for modification
    #
    # @param document [Document] the document to modify
    #
    def document=(document)
      @document =
        case document
        when Kitchen::Document
          document
        else
          raise "Unsupported document type `#{document.class}`"
        end
    end

    # Make a new Recipe
    #
    # @yield A block for defining the steps of the recipe
    # @yieldparam doc [Document] an object representing an XML document
    #
    def initialize(&block)
      @source_location = block.source_location[0]
      @block = block
    end

    # Executes the block given to +Recipe.new+ on the document.  Aka, does the baking.
    #
    def bake
      begin
        @block.to_proc.call(document)
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

    # Print the given recipe error and do a process exit
    #
    # @param error [RecipeError] the error
    #
    def print_recipe_error_and_exit(error)
      Kitchen::Debug.print_recipe_error(error: error,
                                        source_location: source_location,
                                        document: document)
      exit(1)
    end

  end
end
