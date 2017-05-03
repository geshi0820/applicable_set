require "spec_helper"

RSpec.describe ApplicableSet do
  context 'flat set' do
    it { expect(And[1, 2].applicable?(Set[1, 2, 3])).to be_truthy }
    it { expect(And[1, 2].applicable?(Set[1, 3])).to eq false }
    it { expect(Or[1, 2].applicable?(Set[1, 2, 3])).to be_truthy }
    it { expect(Or[1, 2].applicable?(Set[1, 3])).to be_truthy }
    it { expect(Or[1, 2].applicable?(Set[0, 3])).to eq false }
    it { expect(Not[1, 2].applicable?(Set[1, 2, 3])).to eq false }
    it { expect(Not[1, 2].applicable?(Set[3])).to be_truthy }
  end

  context 'nested set' do
    it { expect(And[1, Or[2, 3]].applicable?(Set[1, 2])).to be_truthy }
    it { expect(And[1, Or[2, 3]].applicable?(Set[1, 3])).to be_truthy }
    it { expect(And[1, Or[2, 3]].applicable?(Set[2, 3])).to eq false }
    it { expect(Not[And[1, Or[2, 3]]].applicable?(Set[2, 3])).to be_truthy }
    it { expect(Or[1, And[2, 3]].applicable?(Set[1, 2])).to be_truthy }
    it { expect(Or[1, And[2, 3]].applicable?(Set[2, 3])).to be_truthy }
    it { expect(Or[1, And[2, 3]].applicable?(Set[3, 4])).to eq false }
    it { expect(Or[1, And[2, 3]].applicable?(Set[1])).to be_truthy }
    it { expect(Not[Or[1, And[2, 3]]].applicable?(Set[1])).to eq false }
  end

  context 'deeply nested set' do
    it do
      expect(And[1, Not[And[2, 3], Or[4, And[5, 7]]]].applicable?(Set[1, 2, 5]))
      .to be_truthy
    end

    it do
      expect(And[1, Not[And[2, 3], Or[4, And[5, 7]]]].applicable?(Set[1, 2, 3, 5]))
      .to be_falsey
    end

    it do
      expect(And[1, Not[And[2, 3], Or[4, And[5, 7]]]].applicable?(Set[1, 2, 4]))
      .to be_falsey
    end
  end
end
