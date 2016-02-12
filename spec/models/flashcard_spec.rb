require 'spec_helper'

describe Flashcard do
  describe '#question' do
    subject { Flashcard.new(question: 'What?', answer: 'Yes.') }

    it 'returns the flashcard question' do
      expect(subject.question).to eq 'What?'
    end
  end

  describe '#answer' do
    subject { Flashcard.new(question: 'What?', answer: 'Yes.') }

    it 'returns the flashcard answer' do
      expect(subject.answer).to eq 'Yes.'
    end
  end

  describe '#to_a' do
    subject { Flashcard.new(question: 'What?', answer: 'Yes.') }

    it 'turns the question and answer into an array' do
      expect(subject.to_a).to eq ['What?', 'Yes.']
    end
  end

  describe '#to_hash' do
    subject { Flashcard.new(question: 'What?', answer: 'Yes.') }

    it 'turns the question and answer into a hash' do
      expect(subject.to_hash).to eq({ question: 'What?', answer: 'Yes.' })
    end
  end

  describe '.load' do
    let(:test_csv) { File.join(Dir.pwd, 'spec', 'datasets', 'flashcards.csv') }

    before { stub_const('Flashcard::FILEPATH', test_csv) }

    it 'loads flashcards from a csv' do
      expect(Flashcard.load.map(&:to_a)).to eq([['What?', 'Yes.']])
    end
  end

  context 'when writing to the csv file' do
    let(:attributes) { { question: 'Hello?', answer: 'Hello.' } }
    let(:test_csv) { File.join(Dir.pwd, 'spec', 'datasets', 'flashcards.csv') }

    subject { Flashcard.new(attributes) }

    before { stub_const('Flashcard::FILEPATH', test_csv) }

    describe '#save' do
      after { subject.destroy }

      it 'writes a flashcard to the file' do
        subject.save

        expect(Flashcard.load.map(&:to_a)).to include(['Hello?', 'Hello.'])
      end
    end

    describe '#destroy' do
      before { subject.save }

      it 'removes a flashcard from the file' do
        subject.destroy

        expect(Flashcard.load.map(&:to_a)).to_not include(['Hello?', 'Hello.'])
      end
    end

    describe '.create' do
      subject { Flashcard.create(question: '2 + 2?', answer: '4?') }

      after { subject.destroy }

      it 'saves a new flashcard to the csv' do
        subject

        expect(Flashcard.load.map(&:to_a)).to include(['2 + 2?', '4?'])
      end
    end
  end
end
