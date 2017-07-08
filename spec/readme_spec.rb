require 'spec_helper'

describe 'README.md' do
  readme = File.read File.expand_path('../../README.md', __FILE__)
  ruby_examples = readme.scan(/^```ruby(.+?)^```/m).flatten

  ruby_examples.each_with_index do |code, i|
    describe "example ##{i}" do
      it 'executes without failure' do
        begin

          eval(code)

        rescue Gem::LoadError => err
          # tolerate gem loading failure for our gem
          raise unless err.message.include? 'csp-solver'
        end
      end
    end
  end
end
