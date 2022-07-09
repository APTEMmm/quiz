# frozen_string_literal: true

require 'rexml/document'
require 'timeout'

class Question
  attr_reader :points, :variants, :seconds

  def self.read_from_xml(file_name)
    file = File.new(file_name, 'r:utf-8')
    doc = REXML::Document.new(file)
    file.close

    questions = []

    doc.elements.each('questions/question') do |questions_element|
      text = ''
      variants = []
      right_answer = 0
      points = questions_element.attributes['points'].to_i
      seconds = questions_element.attributes['seconds'].to_i

      questions_element.elements.each do |question_element|
        case question_element.name
        when 'text'
          text = question_element.text
        when 'variants'
          question_element.elements.each do |variant|
            variants << variant.text
            right_answer = variant.text if variant.attributes['right']
          end
          variants.shuffle!
          right_answer = variants.find_index(right_answer)
        end
      end
      questions << Question.new(text, variants, right_answer, points, seconds)
    end
    questions.shuffle!
  end

  def initialize(text, variants, right_answer, points, seconds)
    @text = text
    @variants = variants
    @right_answer = right_answer
    @points = points
    @seconds = seconds
  end

  def ask
    Timeout.timeout(@seconds) do
      @variants.each.with_index(1) do |variant, index|
        puts "#{index}. #{variant}"
      end
      print '> '
      user_input = gets.to_i - 1
      @correct = (@right_answer == user_input)
    end
  rescue Timeout::Error
    puts 'Время на ответ истекло'
    raise
  end

  def correctly_answered?
    @correct
  end

  def to_s
    puts
    "#{@text} (#{@points} баллов)"
  end
end
