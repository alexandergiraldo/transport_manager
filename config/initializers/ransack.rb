Ransack.configure do |config|
  config.add_predicate 'between',
                        arel_predicate: 'between',
                        formatter: proc { |v| v.split(' - ') },
                        type: :string
end

module Arel
  module Predications
    def between(range)
      gteq(range[0]).and(lteq(range[1]))
    end
  end
end