class Array
    def upcase
        self.map {|word| word.upcase}
    end
end
        

class Movie < ActiveRecord::Base
    cattr_accessor :all_ratings
    self.all_ratings = %w[G PG PG-13 R NC-17]
    
    def self.with_ratings(chosen_ratings)
        Movie.where(rating: chosen_ratings.upcase)
    end
end