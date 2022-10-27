# GEMEMDB

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/GEMEMDB`. To experiment with that code, run `bin/console` for an interactive prompt.

Гем для помощи студентам в работе с конечными автоматами и регулярными выражениями

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add GEMEMDB

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install GEMEMDB

## Usage

reg_fm('Some regular expression') строит конечный автомат из регулярного выражения в формате:
[[{"..." => 1}], [{"..." => 2}], []],
где номер элемента массива это номер состояния

matrixToEquation(param, perem, matrix)
Функция Перехода из конечного автомата в регулярное выражение
Переходы из состояний могут быть только в одном направлении(т.е. для примера ниже из состояния 'S' можно перейти в любое, а из состояния D можно перейти в любое кроме предыдущего состояния 'S' и т.д.)
На вход подается 2 массива с состояниями и переменными, матрица переходов, на выход регулярное выражение
              param =  ['0', '1']
perem =  ['Se', Matrix[['D', 'S'],
          'De',        ['D', 'P'],
          'Pe',        ['0', 'Q'],
          'Qe']        ['Q', 'Q']]

equationToSolution(perem, equation)
Функция решения системы уравнений с регулярными коэффициентами
На вход подается массив с состояниями, матрица переходов, на выход регулярное выражение
  perem =  ['Ae',   equation = ["0B+1A+e",
            'B',                "0C+1B",
            "C"]                "0A+1C"]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/GEMEMDB. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/GEMEMDB/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GEMEMDB project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/GEMEMDB/blob/master/CODE_OF_CONDUCT.md).
