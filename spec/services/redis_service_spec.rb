require 'rails_helper'

RSpec.describe RedisService do
  describe 'initialize' do
    let(:test_arg) { 'some arg' }
    subject(:solution) { described_class.new(test_arg) } 

    it "initializes with valig args" do
      expect(solution.some_arg).to eq test_arg
    end
  end
end
