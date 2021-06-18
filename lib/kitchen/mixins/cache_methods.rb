# frozen_string_literal: true

# rubocop:disable Style/Documentation
module Kitchen
  module Mixins
    # A mixin for including the cache_methods class method
    #
    # @example
    #   class Kitchen::BookElement
    #     include Mixins::CacheMethods
    #   end
    #
    #   class SomeRecipe
    #     Kitchen::BookElement.cache_methods(:metadata, :chapters)
    #     ...
    #     # now when you call `book.chapters` the result will be cached for subsequent calls
    #   end
    #
    module CacheMethods
      module ClassMethods
        # Caches the results for the given methods such that subsequent calls with the same
        # arguments on the same object return the cached result instead of repeating the
        # (likely expensive) original call.
        #
        # Should only call this for methods which don't in fact change their result during
        # baking.  E.g. chapters and pages pretty much stay in the same place even if their
        # internal nodes change, so they are decent candidates.
        #
        # After calling cache_methods, the original implementation of the given methods will still
        # available as `uncached_#{method}`, e.g. when calling `cache_methods(:foo, :bar)`,
        # `uncached_foo` and `uncached_bar` are available.
        #
        # @param methods [Array<String, Symbol] a list of methods to cache
        #
        def cache_methods(*methods)
          methods.each do |method|
            method = method.to_sym
            uncached_method = "uncached_#{method}".to_sym

            alias_method uncached_method, method

            define_method(method) do |*args, &block|
              @cached_method_results ||= {}

              cache_key = [method, args]
              cache_key.push(block.source_location[0]) if block_given?

              @cached_method_results[cache_key] ||= send(uncached_method, *args, &block)
            end
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
# rubocop:enable Style/Documentation
