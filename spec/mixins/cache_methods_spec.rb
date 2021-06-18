# frozen_string_literal: true

RSpec.describe Kitchen::Mixins::CacheMethods do
  before do
    stub_const('CacheMethodsTestClass', Class.new do
      include Kitchen::Mixins::CacheMethods
      def some_method(_foo)
        Random.rand
      end
    end)

    CacheMethodsTestClass.cache_methods(:some_method)
  end

  it 'caches the result of some_method' do
    instance = CacheMethodsTestClass.new
    first_call_blah = instance.some_method('blah')
    expect(instance.some_method('blah')).to eq first_call_blah
    expect(instance.some_method('foobar')).not_to eq first_call_blah
  end

  it 'provides a way to get the uncached method' do
    instance = CacheMethodsTestClass.new
    first_call_blah = instance.some_method('blah')
    expect(instance.uncached_some_method('blah')).not_to eq first_call_blah
  end
end
