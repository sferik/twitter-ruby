require 'helper'

describe Twitter::NullObject do

  describe "null object without config.predicates_return false" do
    describe "can be dumped to yaml" do

      subject { YAML.dump(Twitter::NullObject.new) }

      it { expect(subject).to eq("--- !ruby/object:Twitter::NullObject {}\n") }
    end

    describe "can be loaded from yaml" do

      subject { YAML.load("--- !ruby/object:Twitter::NullObject {}\n") }

      it { expect{ subject }.not_to raise_error }
    end
  end

end