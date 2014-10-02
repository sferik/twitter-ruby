require 'helper'

describe Twitter::NullObject do

  describe "null object without config.predicates_return false" do

    let(:yaml_klass) do
      if RUBY_VERSION < "1.9"
        "--- ! {}\n\n"
      else
        "--- !ruby/object:Twitter::NullObject {}\n"
      end
    end

    describe "can be dumped to yaml" do

      subject { YAML.dump(Twitter::NullObject.new) }

      it { expect(subject).to eq(yaml_klass) }
    end

    describe "can be loaded from yaml" do

      subject { YAML.load(yaml_klass) }

      it { expect{ subject }.not_to raise_error }
    end
  end

end