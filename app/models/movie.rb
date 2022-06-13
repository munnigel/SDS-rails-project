class Movie < ActiveRecord::Base
  def self.all_ratings 
    self.find(:all, :select => "rating", :group => "rating")
  end
end
