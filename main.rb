# frozen_string_literal: true

require 'timeout'
require_relative 'lib/question'
require_relative 'lib/xml_parser'

questions = XMLParser.read_from_xml("#{File.dirname(__FILE__)}/data/questions.xml")

puts 'У вас есть по 15 секунд на каждый вопрос'

true_answers_count = 0
points = 0
questions.each do |question|
  puts
  puts question
  begin
    Timeout.timeout(question.seconds) do
      puts question.ask
      print '> '
      user_input = gets.to_i - 1
      if question.correctly_answered?(user_input)
        true_answers_count += 1
        points += question.points
      end
    end
  rescue Timeout::Error
    puts "\nВремя на ответ истекло"
    raise
  end
end

puts "Правильных ответов: #{true_answers_count} из #{questions.size}"
puts "Вы набрали #{points} баллов"
