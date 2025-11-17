# frozen_string_literal: true

RSpec.describe ShinseiConfig::RootConfig do
  let(:tmpdir) { Dir.mktmpdir }
  let(:config_path) { File.join(tmpdir, 'test_config.yml') }

  after do
    FileUtils.rm_rf(tmpdir)
    Object.send(:remove_const, :TestConfig) if defined?(TestConfig)
  end

  describe '.load!' do
    subject { test_config_class.load! }

    context 'when config file is valid' do
      let(:test_config_class) do
        cfg_path = config_path
        Class.new(described_class) do
          settings do |s|
            s.config_path = cfg_path.to_s
          end
          schema do
            required(:write_account_stats).value(:bool?)
            required(:api_keys).hash do
              required(:service_a).filled(:string)
              required(:service_b).filled(:string)
            end
          end
        end
      end

      before do
        yaml = <<~YAML
          write_account_stats: true
          api_keys:
            service_a: test-key-a
            service_b: key-b
        YAML
        File.write(config_path, yaml)
      end

      it 'loads config successfully' do
        expect { subject }.not_to raise_error
      end

      it 'allows access to config attributes' do
        subject
        expect(test_config_class.write_account_stats).to be(true)
        expect(test_config_class.api_keys.service_a).to eq('test-key-a')
        expect(test_config_class.api_keys.service_b).to eq('key-b')
      end
    end

    context 'when using environment splitting' do
      let(:test_config_class) do
        cfg_path = config_path
        Class.new(described_class) do
          settings do |s|
            s.config_path = cfg_path.to_s
            s.env = 'development'
          end
          schema do
            required(:env_name).filled(:string)
          end
        end
      end

      before do
        yaml = <<~YAML
          development:
            env_name: dev
          production:
            env_name: prod
        YAML
        File.write(config_path, yaml)
      end

      it 'loads correct environment section' do
        subject
        expect(test_config_class.env_name).to eq('dev')
      end
    end
  end

  describe '.config' do
    subject { test_config_class.config }

    let(:test_config_class) do
      cfg_path = config_path
      Class.new(described_class) do
        settings do |s|
          s.config_path = cfg_path.to_s
        end
        schema do
          required(:foo).filled(:string)
        end
      end
    end

    context 'when config not loaded' do
      it 'raises error' do
        expect { subject }.to raise_error(ShinseiConfig::Error, /Config not loaded/)
      end
    end
  end

  describe 'custom methods' do
    subject { test_config_class.service_a_test? }

    let(:test_config_class) do
      cfg_path = config_path
      Class.new(described_class) do
        settings do |s|
          s.config_path = cfg_path.to_s
        end
        schema do
          required(:api_keys).hash do
            required(:service_a).filled(:string)
          end
        end

        def self.service_a_test?
          api_keys.service_a.start_with?('test-')
        end
      end
    end

    before do
      yaml = <<~YAML
        api_keys:
          service_a: test-key
      YAML
      File.write(config_path, yaml)
      test_config_class.load!
    end

    context 'when custom method uses delegated config' do
      it 'works correctly' do
        expect(subject).to be(true)
      end
    end
  end
end
