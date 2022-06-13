class Movie < ActiveRecord::Base
  def self.all_ratings
    return %w[G PG PG-13 R NC-17]
  end

  def self.with_ratings(ratings_list)
    if ratings_list = []
      return Movie.all
    end
    return Movie.where(Rating: ratings_list)
  end
end
