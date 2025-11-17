# frozen_string_literal: true

RSpec.describe ShinseiConfig::SchemaValidator do
  describe '#validate!' do
    subject { validator.validate!(data) }

    let(:validator) do
      described_class.new do
        required(:name).filled(:string)
        required(:age).filled(:integer)
      end
    end

    context 'when data is valid' do
      let(:data) { { 'name' => 'John', 'age' => 30 } }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when data is invalid' do
      let(:data) { { 'age' => 30 } }

      it 'raises ValidationError' do
        expect { subject }.to raise_error(ShinseiConfig::ValidationError)
      end
    end
  end
end
