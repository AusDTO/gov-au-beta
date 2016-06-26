require 'rails_helper'

describe Revisable do
  with_model :Recipe do
    table do |t|
      t.string :ingredients
      t.string :instructions
    end

    model do
      include Revisable

      def self.content_attributes
        [:ingredients, :instructions]
      end
    end
  end

  let(:recipe) { Recipe.create }

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

    describe 'revision ancestry' do
      let!(:first_revision) { recipe.revise! instructions: 'bake slowly' }

      context 'revising based on an explicit parent revision' do
        subject { recipe.revise_from_revision! first_revision,
          instructions: 'actually bake slowly' }

        it 'should have correct parent revision' do
          expect(subject.parent).to eq first_revision
        end
      end

      context 'revising implicitly based on latest applied revision' do
        before { first_revision.update_attribute :applied_at, 1.day.ago }
        subject { recipe.revise! instructions: 'actually bake slowly' }

        it 'should have correct parent revision' do
          expect(subject.parent).to eq first_revision
        end
      end
    end
  end

  describe '#persistable_diff' do
    subject { recipe.persistable_diff 'a', 'ab' }

    it { is_expected.to eq [[['+', 1, 'b']]] }
  end
end
