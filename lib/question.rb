# frozen_string_literal: true

class Question
  attr_reader :points, :seconds

  def initialize(text, variants, right_answer, points, seconds)
    @text = text
    @variants = variants
    @right_answer = right_answer
    @points = points
    @seconds = seconds
  end

  def ask
    @variants.map.with_index(1) { |variant, index| "#{index}. #{variant}" }
  end

  def correctly_answered?(user_input)
    @right_answer == user_input
  end

  def to_s
    "#{@text} (#{@points} баллов)"
  end
end
