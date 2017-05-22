require 'open-uri'

class PagesController < ApplicationController
  def game
    new_game = generate_grid(9)
    @grid = new_game.join('')
  end

  def score
    @answer = params["response"]
    @grid = params["grid"]
    @result = run_game(@answer, @grid)
  end

  ALPHABET = "abcdefghijklmnopqrstuvwxyz".upcase

  def generate_grid(grid_size)
    res = []
    res << ALPHABET[Random.new.rand(25)].to_s until res.length == grid_size
    return res
  end

  def word_valid(attempt, grid)
    attempt.split("").all? { |letter| grid.count(letter) >= attempt.count(letter) }
  end

  def run_game(attempt, grid)
    result = {}
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=d20a5579-bc45-4d56-9e45-dd43b27c0dd2&input=#{attempt}"
    translate = open(url).read
    translated_word = JSON.parse(translate)["outputs"][0]["output"]
    if translated_word != attempt
      if word_valid(attempt.upcase, grid)
        return result = {
        message: "well done",
        translation: translated_word,
        score: attempt.length
      }
      else
        return result = {
        message: "not in the grid",
        translation: translated_word,
        score: 0
      }
      end
    else
      return result = {
      message: "not an English word",
      translation: attempt,
      score: 0
      }
    end
  end
end

