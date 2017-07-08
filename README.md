# CSP::Solver
A gem for solving arbitrary [constraint satisfaction problems][wiki-csp] (CSPs). If the constraints are [hard][hard-constraints] (as opposed to flexible/soft) and can be specified in the Ruby programming language, then this library can find a solution.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csp-solver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csp-solver

## Usage

```ruby
# first we need to set up a Problem
problem = CSP::Solver::Problem.new
# then we need to set up some variables and their domain
weekdays = %i(monday tuesday wednesday thursday friday saturday sunday)
meals = %w(bread cheese potatoes)
problem.vars weekdays, meals
# then we set up constraints as predicate blocks
problem.all_pairs(weekdays) { |a, b| a != b}
# (or you can use the convenience method `all_different`)
# problem.all_different(weekdays)
# then it's as simple as calling #solve
problem.solve
# which returns to us a hash of variables as keys, and
# domain entries as values
# => { weekday: meal }
```

See also: [Official documentation and API][csp-solver-docs]

## Development

This project makes uses [git-flow][] conventions: the **master** branch is intended for the current stable release. Active development commits should be made on the **develop** branch or, better yet, on **feature/** branches that will merge back into **develop**.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number (`CSP::Solver::VERSION`) in `lib/csp/solver/version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org][].

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komputerwhiz/csp-solver. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant][] code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[wiki-csp]: http://en.wikipedia.org/wiki/Constraint_satisfaction_problem
[hard-constraints]: https://en.wikipedia.org/wiki/Constraint_satisfaction_problem#Flexible_CSPs
[csp-solver-docs]: http://komputerwiz.net/apps/csp-solver
[git-flow]: http://nvie.com/posts/a-successful-git-branching-model/
[rubygems.org]: https://rubygems.org
[Contributor Covenant]: http://contributor-covenant.org
