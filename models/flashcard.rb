require 'csv'

class Flashcard
  FILEPATH = File.join(Dir.pwd, 'datasets', 'flashcards.csv')

  attr_reader :question, :answer

  def initialize(attrs={})
    @question = attrs[:question]
    @answer   = attrs[:answer]
  end

  def to_a
    [question, answer]
  end

  def to_hash
    { question: question, answer: answer }
  end

  def save
    CSV.open(FILEPATH, 'ab') do |csv|
      csv << self.to_a
    end

    self
  end

  def self.create(attrs={})
    new(attrs).save
  end

  def self.load
    CSV.foreach(FILEPATH, headers: true, header_converters: :symbol).map do |row|
      new(row.to_hash)
    end
  end

  def destroy
    scrubbed_table = CSV.table(FILEPATH).delete_if do |row|
      to_hash == row.to_hash
    end

    File.open(FILEPATH, 'w') do |file|
      file.write(scrubbed_table.to_csv)
    end
  end
end
