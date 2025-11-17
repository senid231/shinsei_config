# frozen_string_literal: true

RSpec.describe ShinseiConfig::Settings do
  describe '#validate!' do
    subject { settings.validate! }

    let(:settings) { described_class.new }

    context 'when config_path is nil' do
      it 'raises error' do
        expect { subject }.to raise_error(ShinseiConfig::Error, 'config_path is required')
      end
    end

    context 'when config_path is empty' do
      before do
        settings.config_path = ''
      end

      it 'raises error' do
        expect { subject }.to raise_error(ShinseiConfig::Error, 'config_path is required')
      end
    end

    context 'when config_path is set' do
      before do
        settings.config_path = '/path/to/config.yml'
      end

      it 'does not raise' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
