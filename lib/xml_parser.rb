require_relative 'question'
require 'rexml/document'

class XMLParser
  def self.read_from_xml(file_name)
    file = File.new(file_name, 'r:utf-8')
    doc = REXML::Document.new(file)
    file.close

    doc.elements.to_a('questions/question').map do |questions_element|
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
      Question.new(text, variants, right_answer, points, seconds)
    end.shuffle!
  end
end
