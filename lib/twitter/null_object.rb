require 'naught'

module Twitter
  NullObject = Naught.build do |config|
    config.black_hole
    config.define_explicit_conversions
    config.define_implicit_conversions

    def to_int
      0
    end

    def nil?
      true
    end
  end
end
