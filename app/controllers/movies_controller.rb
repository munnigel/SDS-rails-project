class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    #when no checkboxes are ticked
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = @all_ratings

    arr_of_ratings = params[:ratings]
    #when a checkbox is ticked
    if (!arr_of_ratings.nil?)
      @ratings_to_show_hash = []
      params[:ratings].each_key {|key|
      @ratings_to_show_hash.append(key)}
      session[:ratings] = @ratings_to_show_hash
    end

   
    #retrieve only selected movies based on ratings
    @movies = Movie.with_ratings(@ratings_to_show_hash)
    
    # using parsed data and if to set different instructions
    #these params[] are only for temporary data, once they are navigated out, the sorted list is gone
    
    if (!params[:sort].blank?)
      if (params[:sort] == "title")
        @movies = Movie.with_ratings(@ratings_to_show_hash).order(params[:sort])
        @title_header = 'hilite bg-warning'
      elsif (params[:sort] == "release_date")
        @movies = Movie.with_ratings(@ratings_to_show_hash).order(params[:sort])
        @release_date_header = 'hilite bg-warning'
      end
      session[:sort] = params[:sort] 
    end


    #these session[] are to remember the sorted list once you get out of the page and want to get back in again
    if (!session[:sort].blank?)
      @ratings_to_show_hash = session[:ratings] 
      if (session[:sort] == "title")
        @movies = Movie.with_ratings(@ratings_to_show_hash).order(session[:sort])
        @title_header = 'hilite bg-warning'
      elsif (session[:sort] == "release_date")
        @movies = Movie.with_ratings(@ratings_to_show_hash).order(session[:sort])
        @release_date_header = 'hilite bg-warning'
      end
    end

  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
