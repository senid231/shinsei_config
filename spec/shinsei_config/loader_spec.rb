# frozen_string_literal: true

RSpec.describe ShinseiConfig::Loader do
  let(:tmpdir) { Dir.mktmpdir }
  let(:config_path) { File.join(tmpdir, 'config.yml') }

  after { FileUtils.rm_rf(tmpdir) }

  describe '#load' do
    subject { loader.load }

    let(:loader) { described_class.new(config_path: config_path, env: env) }
    let(:env) { nil }

    context 'when file does not exist' do
      let(:config_path) { '/nonexistent/config.yml' }

      it 'raises error' do
        expect { subject }.to raise_error(ShinseiConfig::Error, /Config file not found/)
      end
    end

    context 'when environment is not specified' do
      context 'with plain YAML' do
        before do
          File.write(config_path, "foo: bar\nbaz: 42")
        end

        it 'loads YAML correctly' do
          expect(subject).to eq('foo' => 'bar', 'baz' => 42)
        end
      end

      context 'with ERB in YAML' do
        before do
          File.write(config_path, 'value: <%= 1 + 1 %>')
        end

        it 'processes ERB' do
          expect(subject).to eq('value' => 2)
        end
      end

      context 'with ERB in nested structures' do
        before do
          File.write(config_path, "nested:\n  value: <%= 'test'.upcase %>")
        end

        it 'processes ERB in nested values' do
          expect(subject).to eq('nested' => { 'value' => 'TEST' })
        end
      end
    end

    context 'when environment is specified' do
      let(:env) { 'development' }

      context 'with valid environment section' do
        before do
          yaml = <<~YAML
            development:
              foo: dev
            production:
              foo: prod
          YAML
          File.write(config_path, yaml)
        end

        it 'extracts correct environment section' do
          expect(subject).to eq('foo' => 'dev')
        end
      end

      context 'with ERB in environment section' do
        before do
          yaml = <<~YAML
            development:
              value: <%= 10 * 2 %>
            production:
              value: <%= 5 * 2 %>
          YAML
          File.write(config_path, yaml)
        end

        it 'processes ERB after environment extraction' do
          expect(subject).to eq('value' => 20)
        end
      end

      context 'when environment not found in config' do
        let(:env) { 'production' }

        before do
          File.write(config_path, "development:\n  foo: bar")
        end

        it 'raises error' do
          expect { subject }.to raise_error(ShinseiConfig::Error, /Environment 'production' not found/)
        end
      end
    end
  end
end
