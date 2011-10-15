require 'rspec/core/formatters/base_formatter'

class StatisticsFormatter < ::RSpec::Core::Formatters::BaseFormatter

  def dump_summary(duration, example_count, failure_count, pending_count)
    output.puts [ format_seconds(duration), example_count, failure_count, pending_count ].join(',')
  end

end
