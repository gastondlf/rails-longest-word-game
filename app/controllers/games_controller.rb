require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    session[:scores] ||= []
    @letters = []
    grid_vowels = ["A", "E", "I", "O", "U"]
    @letters << grid_vowels.sample
    i = 0
    while i < 10 - 1
      @letters << ("A".."Z").to_a.sample
      i += 1
    end
  end

  def reset_cache
    session[:scores] = []
  end

  def score
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @letters = params[:letters]
    @user_input = params[:input1]
    @valid = in_the_grid?(@user_input, @letters)
    @found = check_dictionary?(@user_input) if @valid

    if @valid && @found
      @message = "Congratulations! <strong>#{@user_input.upcase}</strong> is a valid English word!"
      @score = ((60 - (@end_time - @start_time)) * @user_input.length).round
      session[:scores] << @score
      @grand_total = session[:scores].sum
    elsif  @valid
      @message = "Sorry but #{@user_input.upcase} does not seem to be a valid English word..."
      @score = 0
      session[:scores] << @score
      @grand_total = session[:scores].sum
    else
      @message = "Sorry but #{@user_input.upcase} can't be build out of #{@letters}"
      @score = 0
      session[:scores] << @score
      @grand_total = session[:scores].sum
    end
  end

  private

  def check_dictionary?(attempt)
    url = "https://dictionary.lewagon.com/#{attempt}"
    dictionary_serialized = URI.parse(url).read
    dictionary = JSON.parse(dictionary_serialized)
    dictionary["found"]
  end

  def in_the_grid?(attempt, grid)
    included = true
    repeated = true
    attempt.each_char do |c|
      included = false if grid.include?(c.upcase) == false
      repeated = false if attempt.scan(c).count > grid.count(c.upcase)
    end
    included && repeated
  end

end
