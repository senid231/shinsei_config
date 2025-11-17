# frozen_string_literal: true

RSpec.describe ShinseiConfig::ConfigBuilder do
  describe '.build' do
    subject { described_class.build(hash_data) }

    context 'with simple hash' do
      let(:hash_data) { { 'foo' => 'bar', 'baz' => 42 } }

      it 'builds config with accessible attributes' do
        expect(subject.foo).to eq('bar')
        expect(subject.baz).to eq(42)
      end
    end

    context 'with nested hash' do
      let(:hash_data) { { 'outer' => { 'inner' => 'value' } } }

      it 'builds nested config objects' do
        expect(subject.outer.inner).to eq('value')
      end
    end

    context 'with array values' do
      let(:hash_data) { { 'items' => [1, 2, 3] } }

      it 'preserves arrays' do
        expect(subject.items).to eq([1, 2, 3])
      end
    end

    context 'with nested structure' do
      let(:hash_data) { { 'nested' => { 'value' => 'test' } } }

      it 'deep freezes config' do
        expect(subject).to be_frozen
      end

      it 'deep freezes nested objects' do
        expect(subject.nested).to be_frozen
      end
    end
  end
end
