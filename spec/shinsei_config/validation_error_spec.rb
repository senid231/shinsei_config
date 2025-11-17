# frozen_string_literal: true

RSpec.describe ShinseiConfig::ValidationError do
  describe '#message' do
    subject { error.message }

    let(:error) { described_class.new(errors) }

    context 'when errors are present' do
      let(:errors) do
        double(
          'Errors',
          empty?: false,
          to_h: { api_keys: ['is missing'], write_account_stats: ['must be boolean'] }
        )
      end

      it 'includes validation failed header' do
        expect(subject).to include('Validation failed')
      end

      it 'includes api_keys error' do
        expect(subject).to include('api_keys: is missing')
      end

      it 'includes write_account_stats error' do
        expect(subject).to include('write_account_stats: must be boolean')
      end
    end
  end
end
