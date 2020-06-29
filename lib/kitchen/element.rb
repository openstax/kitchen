require 'forwardable'
require 'securerandom'

module Kitchen
  class Element
    extend Forwardable
    include Mixins::BlockErrorIf

    attr_reader :document
    attr_reader :short_type

    def self.short_type
      :element
    end

    # @!method name
    #   Get the element name (the tag)
    # @!method name=
    #   Set the element name (the tag)
    # @!method []
    #   Get an element attribute
    # @!method []=
    #   Set an element attribute
    # @!method add_class
    #   Add a class to the element
    # @!method remove_class
    #   Remove a class from the element
    def_delegators :@node, :name=, :name, :[], :[]=, :add_class, :remove_class,
                           :text, :wrap, :children, :to_html, :remove_attribute,
                           :classes

    def initialize(node:, document:, short_type: nil)
      raise "node cannot be nil" if node.nil?
      @node = node
      @document =
        case document
        when Kitchen::Document
          document
        when Nokogiri::XML::Document
          Kitchen::Document.new(nokogiri_document: document)
        else
          raise(ArgumentError, "`document` is not a known document type")
        end

      @ancestors = HashWithIndifferentAccess.new
      @short_type = short_type || "unnamed_type_#{SecureRandom.hex(4)}"
      @counts_in = HashWithIndifferentAccess.new
      @css_or_xpath_that_has_been_counted = {}
      @is_a_clone = false
    end

    def has_class?(klass)
      (self[:class] || "").include?(klass)
    end

    def id
      self[:id]
    end

    def id=(value)
      self[:id] = value
    end

    def ancestor(type)
      @ancestors[type.to_sym]&.element || raise("No ancestor of type '#{type}'")
    end

    def ancestors
      @ancestors
    end

    def add_ancestors(*args)
      args.each do |arg|
        case arg
        when Hash
          add_ancestors(*arg.values)
        when Ancestor
          add_ancestor(arg)
        when Element, Document
          add_ancestor(Ancestor.new(arg))
        else
          raise "Unsupported ancestor type `#{arg.class}`"
        end
      end
    end

    def add_ancestor(ancestor)
      # TODO freak out if already have an ancestor of this type
      @ancestors[ancestor.type] = ancestor
    end

    def count_as_descendant
      @ancestors.each_pair do |type, ancestor|
        @counts_in[type] = ancestor.increment_descendant_count(short_type)
      end
    end

    def count_in(ancestor_type)
      @counts_in[ancestor_type] || raise("No ancestor of type '#{ancestor_type}'")
    end

    def remember_that_sub_elements_are_already_counted(css_or_xpath:, count:)
      @css_or_xpath_that_has_been_counted[css_or_xpath] = count
    end

    def have_sub_elements_already_been_counted?(css_or_xpath)
      number_of_sub_elements_already_counted(css_or_xpath) != 0
    end

    def number_of_sub_elements_already_counted(css_or_xpath)
      @css_or_xpath_that_has_been_counted[css_or_xpath] || 0
    end

    def search(*selector_or_xpath_args)
      # TODO error if block given?
      ElementEnumeratorFactory.within(
        new_enumerator_class: ElementEnumerator,
        element: self,
        css_or_xpath: nil,
        default_css_or_xpath: selector_or_xpath_args,
      )
    end

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @return [Element, nil] the matched XML element or nil if no match found
    #
    def first(*selector_or_xpath_args)
      search(*selector_or_xpath_args).first.tap do |element|
        yield(element) if block_given?
      end
    end

    # TODO first and first! should record ancestry (make this a spec)

    # # Yields and returns the first child element that matches the provided
    # # selector or XPath arguments.
    # #
    # # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # # @yieldparam [Element] the matched XML element
    # # @raise [ElementNotFoundError] if no matching element is found
    # # @return [Element] the matched XML element
    # #
    def first!(*selector_or_xpath_args)
      search(*selector_or_xpath_args).first!.tap do |element|
        yield(element) if block_given?
      end
    end

    alias_method :at, :first

    # Removes the element from its parent and places it on the specified clipboard
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to. String values are converted to symbols. If not provided, the
    #   element is not placed on a clipboard.
    # @return [Element] the cut element
    #
    def cut(to: nil)
      node.remove
      clipboard(to).add(self) if to.present?
      self
    end

    # Makes a copy of the element and places it on the specified clipboard.
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to.  String values are converted to symbols.  If not provided, the
    #   copy is not placed on a clipboard.
    # @return [Element] the copied element
    #
    def copy(to: nil)
      # See `clone` method for a note about namespaces
      the_copy = clone
      the_copy.raw.traverse do |node|
        next if node.text? || node.document?
        document.record_id_copied(node[:id])
      end
      clipboard(to).add(the_copy) if to.present?
      the_copy
    end

    # When an element is cut or copied, use this method to get the element's content;
    # keeps IDs unique
    def paste
      # See `clone` method for a note about namespaces
      temp_copy = clone
      temp_copy.raw.traverse do |node|
        next if node.text? || node.document?
        node[:id] = document.modified_id_to_paste(node[:id]) unless node[:id].blank?
      end
      temp_copy.to_s
    end

    # Delete the element
    #
    def trash
      node.remove
      self
    end

    def parent
      self.class.new(node: raw.parent, document: document)
    end

    # TODO make it clear if all of these methods take Element, Node, or String

    # If child argument given, prepends it before the element's current children.
    # If sibling is given, prepends it as a sibling to this element.
    #
    # @param child [String] the child to prepend
    # @param sibling [String] the sibling to prepend
    #
    def prepend(child: nil, sibling: nil)
      if child && sibling
        raise RecipeError, "Only one of `child` or `sibling` can be specified"
      elsif !child && !sibling
        raise RecipeError, "One of `child` or `sibling` must be specified"
      elsif child
        if node.children.empty?
          node.children = child.to_s
        else
          node.children.first.add_previous_sibling(child)
        end
      else
        node.add_previous_sibling(sibling)
      end
      self
    end

    # If child argument given, appends it after the element's current children.
    # If sibling is given, appends it as a sibling to this element.
    #
    # @param child [String] the child to append
    # @param sibling [String] the sibling to append
    #
    def append(child: nil, sibling: nil)
      if child && sibling
        raise RecipeError, "Only one of `child` or `sibling` can be specified"
      elsif !child && !sibling
        raise RecipeError, "One of `child` or `sibling` must be specified"
      elsif child
        if node.children.empty?
          node.children = child.to_s
        else
          node.add_child(child)
        end
      else
        node.next = sibling
      end
      self
    end

    # Replaces this element's children
    #
    # @param with [String] the children to substitute for the current children
    #
    def replace_children(with:)
      node.children = with
      self
    end

    # TODO methods like replace_children that take string, either forbid or handle Element/Node args

    # Get the content of children matching the provided selector.  Mostly
    # useful when there is one child with text you want to extract.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [String]
    #
    def content(*selector_or_xpath_args)
      node.search(*selector_or_xpath_args).children.to_s
    end

    # Returns true if this element has a child matching the provided selector
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [Boolean]
    #
    def contains?(*selector_or_xpath_args)
      # TODO search(*selector_or_xpath_args).any?
      !node.at(*selector_or_xpath_args).nil?
    end

    # Returns the header tag name that is one level under the first header tag in this
    # element, e.g. if this element is a "div" whose first header is "h1", this will
    # return "h2"
    #
    # @return [String] the sub header tag name
    #
    def sub_header_name
      first_header = node.search("h1, h2, h3, h4, h5, h6").first

      first_header.nil? ?
        "h1" :
        first_header.name.gsub(/\d/) {|num| (num.to_i + 1).to_s}
    end

    # Returns the underlying Nokogiri object
    #
    # @return [Nokogiri::XML::Node]
    #
    def raw
      node
    end

    def inspect
      to_s
    end

    def to_s
      remove_default_namespaces_if_clone(node.to_s)
    end

    def to_xml
      remove_default_namespaces_if_clone(node.to_xml)
    end

    def to_xhtml
      remove_default_namespaces_if_clone(node.to_xhtml)
    end

    def clone
      super.tap do |element|
        # When we call dup, the dup gets a bunch of default namespace stuff that
        # the original doesn't have.  Why? Unclear, but hard to get rid of nicely.
        # So here we mark that the element is a clone and then all of the `to_s`-like
        # methods gsub out the default namespace gunk.  Clones are mostly used for
        # clipboards and are accessed using `paste` methods, so modifying the `to_s`
        # behavior works for us.  If we end up using `clone` in a way that doesn't
        # eventually get converted to string, we may have to investigate other
        # options.
        #
        # An alternative is to remove the `xmlns` attribute in the `html` tag before
        # the input file is parse into a Nokogiri document and then to add it back
        # in when the baked file is written out.
        #
        # Nokogiri::XML::Document.remove_namespaces! is not an option because that blows
        # away our MathML namespace.
        #
        # I may not fully understand why the extra default namespace stuff is happening
        # FWIW :-)
        #
        element.node = node.dup
        element.is_a_clone = true
      end
    end

    # @!method pages
    #   Returns a pages enumerator
    def_delegators :as_enumerator, :pages, :chapters, :terms, :figures, :notes, :tables, :examples

    protected

    attr_accessor :node
    attr_accessor :is_a_clone

    def as_enumerator
      ElementEnumerator.new {|block| block.yield(self)}
    end

    def clipboard(name_or_object)
      case name_or_object
      when Symbol
        document.clipboard(name: name_or_object)
      when Clipboard
        name_or_object
      else
        raise ArgumentError, "The provided argument (#{name_or_object}) is not "
                             "a clipboard name or a clipboard"
      end
    end

    def remove_default_namespaces_if_clone(string)
      if is_a_clone
        string.gsub("xmlns:default=\"http://www.w3.org/1999/xhtml\"","").gsub("default:","")
      else
        string
      end
    end

  end
end
