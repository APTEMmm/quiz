# frozen_string_literal: true

require_relative 'question'
require 'rexml/document'

class XMLParser
  def self.read_from_xml(file_name)
    file = File.new(file_name, 'r:utf-8')
    doc = REXML::Document.new(file)
    file.close

    doc.elements.to_a('questions/question').map do |questions_element|
      text = questions_element.elements['text'].text
      variants_array = questions_element.elements.to_a('variants/variant').shuffle!
      variants = variants_array.map(&:text)
      right_answer = variants.find_index(variants_array.select { |variant| variant.attributes['right'] == 'true' }[0]
                                                       .text)
      points = questions_element.attributes['points'].to_i
      seconds = questions_element.attributes['seconds'].to_i
      Question.new(text, variants, right_answer, points, seconds)
    end.shuffle!
  end
end
