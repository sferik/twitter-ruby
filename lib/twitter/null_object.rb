require 'naught'

module Twitter
  NullObject = Naught.build do |config|
    config.black_hole
    config.define_explicit_conversions
    config.define_implicit_conversions

    def nil?
      true
    end
  end
end
