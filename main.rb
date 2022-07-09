# frozen_string_literal: true

require_relative 'lib/question'

questions = Question.read_from_xml("#{File.dirname(__FILE__)}/questions.xml")

puts 'У вас есть по 15 секунд на каждый вопрос'

true_answers_count = 0
points = 0
questions.each do |question|
  puts question
  question.ask
  if question.correctly_answered?
    true_answers_count += 1
    points += question.points
  end
end

puts "Правильных ответов: #{true_answers_count} из #{questions.size}"
puts "Вы набрали #{points} баллов"
