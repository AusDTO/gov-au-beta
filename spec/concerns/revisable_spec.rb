require 'rails_helper'

describe Revisable do
  with_model :Recipe do
    table do |t|
      t.string :ingredients
      t.string :instructions
    end

    model do
      include Revisable
    end
  end

  let(:recipe) { Recipe.new ingredients: 'sugar, flour', instructions: 'bake' }

  describe '#revise!' do
    context 'revising one content attribute' do
      subject { recipe.revise! instructions: 'bake for three hours' }

      it { is_expected.to be_a Revision }
      it { is_expected.not_to be_applied }

      it 'should only include diffs for the changed attribute' do
        expect(subject.diffs).to have_key :instructions
        expect(subject.diffs).not_to have_key :ingredients
      end
    end

    context 'revising all content attributes' do
      subject { recipe.revise! ingredients: 'eggs, sugar, flour',
        instructions: 'mix, bake, burn and throw away' }

      it { is_expected.to be_a Revision }
      it { is_expected.not_to be_applied }

      it 'should include diffs for all attributes' do
        expect(subject.diffs).to have_key :instructions
        expect(subject.diffs).to have_key :ingredients
      end
    end
  end

  describe '#persistable_diff' do
    subject { recipe.persistable_diff 'a', 'ab' }

    it { is_expected.to eq [[['+', 1, 'b']]] }
  end
end
