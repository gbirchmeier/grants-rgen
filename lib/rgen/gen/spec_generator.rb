require 'active_support/inflector'

class Rgen::Gen::SpecGenerator
  include ActiveSupport::Inflector

  def generate(model)
    generate_file_content(
      model.name,
      generate_specs_string(model))
  end

  private

  def generate_file_content(model_name, specs_str)
    letname = "#{model_name.underscore}1"
    <<TEMPLATE_END
require 'rails_helper'

RSpec.describe #{model_name}, type: :model do
  let(:#{letname}) { FactoryBot.create(:#{model_name.underscore}) }

  context 'simple validations' do
    before(:example) { #{letname} }

#{specs_str}
  end
end
TEMPLATE_END
  end

  def generate_specs_for_attribute(att)
    return nil unless att.presence || att.unique
    rva = []

    if att.datatype=='boolean' && att.presence
      rva << "    it { should allow_value(true).for(:#{att.name}) }"
      rva << "    it { should allow_value(false).for(:#{att.name}) }"
      rva << "    it { should_not allow_value(nil).for(:#{att.name}) }"
    else
      rva << "    it { should validate_presence_of(:#{att.name}) }" if att.presence
      rva << "    it { should validate_uniqueness_of(:#{att.name}) }" if att.unique
    end
    rva.join("\n")
  end

  def generate_specs_string(model)
    rva = []
    model.attributes.each do |att|
      val = generate_specs_for_attribute(att)
      rva << val unless val.nil?
    end
    rva.join("\n")
  end
end