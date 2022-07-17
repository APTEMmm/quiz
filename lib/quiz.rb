# frozen_string_literal: true

class Quiz
  attr_reader :points, :answers, :true_answers

  def initialize
    @points = 0
    @true_answers = 0
    @answers = 0
  end

  def count_points(question)
    @points += question.points
  end

  def count_true_answers
    @true_answers += 1
  end

  def count_answers
    @answers += 1
  end
end
