require 'rails_helper'

describe Container do
  with_model :Song do
    table do |t|
      t.jsonb :content
    end

    model do
      include Container

      content_attribute :title
      content_attribute :artist
      content_attribute :genre
    end
  end

  describe 'class meta' do
    subject { Song }

    it 'knows its content attributes' do
      expect(subject.content_attributes).to eq [:title, :artist, :genre]
    end
  end

  describe 'usage' do
    let(:attributes) { { artist: 'Eek-a-Mouse', title: 'Wa-Do-Dem',
      genre: 'Reggae' } }

    let(:song) { Song.new attributes }

    it 'has stored its content correctly' do
      expect(song.content).to eq attributes.stringify_keys
    end

    it 'has accessors for its content' do
      expect(song.artist).to eq 'Eek-a-Mouse'
    end

    describe '#all_content' do
      subject { song.all_content }
      it { should eq attributes }
    end

    describe '#apply_content' do
      before do
        song.apply_content new_content
      end

      subject { song.content }

      context 'partial update' do
        let(:new_content) {{ genre: 'Dub' }}

        it { is_expected.to eq({ 'artist' => 'Eek-a-Mouse',
          'title' => 'Wa-Do-Dem', 'genre' => 'Dub' })}
      end

      context 'full update' do
        let(:new_content) {{ artist: 'Martyn', title: 'Vancouver',
          genre: 'Techno' }}

        it { is_expected.to eq new_content.stringify_keys }
      end
    end
  end
end
