# frozen_string_literal: true

require 'timeout'
require_relative 'lib/xml_parser'
require_relative 'lib/quiz'

questions = XMLParser.read_from_xml("#{File.dirname(__FILE__)}/data/questions.xml")
quiz = Quiz.new
puts 'У вас есть по 15 секунд на каждый вопрос'

questions.each do |question|
  puts
  puts question
  begin
    Timeout.timeout(question.seconds) do
      puts question.ask
      print '> '
      user_input = gets.to_i - 1
      quiz.count_answers
      if question.correctly_answered?(user_input)
        quiz.count_true_answers
        quiz.count_points(question)
      end
    end
  rescue Timeout::Error
    puts "\nВремя на ответ истекло"
    break
  end
end

puts "Правильных ответов: #{quiz.true_answers} из #{quiz.answers}"
puts "Вы набрали #{quiz.points} баллов"
