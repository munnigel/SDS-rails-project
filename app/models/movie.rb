class Movie < ActiveRecord::Base
  def self.all_ratings
    return %w[G PG PG-13 R NC-17]
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      return self.all
    end
    return self.where(rating: ratings_list)
  end
end
