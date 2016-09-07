require 'spec_helper'

describe CSP::Solver do
  it 'has a version number' do
    expect(CSP::Solver::VERSION).not_to be nil
  end

  describe 'what do you want for dinner?' do
    let(:csp) { CSP::Solver::Problem.new }
    let(:meals) do
      ['red sauce',
       'burritos',
       'shwarma',
       'mushroom sauce',
       'pizza',
       'chinese',
       'dogwood'].freeze
    end
    let(:takeout) do
      %w(dogwood chinese shwarma burritos)
    end
    let(:weekdays) do
      %i(monday tuesday
         wednesday thursday
         friday saturday sunday)
    end
    it 'no repeated meals' do
      csp.vars weekdays, meals
      # could also use #all_different here
      # https://komputerwiz.net/apps/csp-solver#api-csp-all_different
      # but this just helps expose the predicate
      csp.all_pairs(weekdays) { |a, b| a != b }
      expect(csp.solve).to eq(
        monday: 'red sauce',
        tuesday: 'burritos',
        wednesday: 'shwarma',
        thursday: 'mushroom sauce',
        friday: 'pizza',
        saturday: 'chinese',
        sunday: 'dogwood'
      )
    end
    it 'only takeout on weekends' do
      csp.vars weekdays, meals.shuffle
      csp.all_pairs(weekdays) { |a, b| a != b }
      csp.constrain(:saturday, :sunday) { |d| takeout.include?(d) }

      plan = csp.solve

      expect(takeout).to include(plan[:saturday])
      expect(takeout).to include(plan[:sunday])
    end
  end
end
