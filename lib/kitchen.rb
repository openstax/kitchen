require "kitchen/version"

require "nokogiri"
require "active_support/all"

module Kitchen
end

def file_glob(relative_folder_and_extension)
  Dir[File.expand_path(__dir__ + "/" + relative_folder_and_extension)]
end

def require_all(relative_folder, file_matcher="*.rb")
  file_glob(relative_folder + "/#{file_matcher}").each{|f| require f}
end

require_all("kitchen/mixins")

require "kitchen/utils"
require "kitchen/errors"
require "kitchen/ancestor"
require "kitchen/search_history"
require "kitchen/document"
require "kitchen/book_document"
require "kitchen/debug/print_recipe_error"
require "kitchen/recipe"
require "kitchen/book_recipe"
require "kitchen/oven"
require "kitchen/clipboard"
require "kitchen/pantry"
require "kitchen/counter"
require "kitchen/patches"

require "kitchen/element_enumerator_base"
require "kitchen/element_enumerator_factory"
require_all("kitchen", "*enumerator.rb")

require "kitchen/element_base"
require_all("kitchen", "*element.rb")

require_all("kitchen/directions")

I18n.load_path << file_glob("/locales/*.yml")
