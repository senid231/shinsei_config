# frozen_string_literal: true

RSpec.describe ShinseiConfig do
  it 'has a version number' do
    expect(ShinseiConfig::VERSION).not_to be_nil
  end
end
