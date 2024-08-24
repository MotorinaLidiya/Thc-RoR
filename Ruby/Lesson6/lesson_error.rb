class LessonError < StandardError
  def initialize(message)
    super(message)
  end

  def self.error(message)
    raise new(message)
  end
end
