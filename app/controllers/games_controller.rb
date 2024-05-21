# frozen_string_literal: true
require 'open-uri'
require 'json'

# Control the game
class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letter)
    word_chars = word.chars
    word_chars.each do |letter|
      word_count = word_chars.count(letter)
      letters_count = @letters.count(letter)
      return false if word_count > letters_count
    end
    true
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    @result = json['found']
  end
end
