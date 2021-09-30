class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      
      if !params.has_key?(:ratings)
        ratings_hash = @all_ratings.each_with_object({}) {|rating, h| h[rating] = '1'}
        params[:ratings] = ratings_hash
        # redirect_to movies_path(:ratings => ratings_hash) and return
      end
      
      @checked_boxes = params[:ratings].keys
      @title_style = ""
      @date_style = ""
      if params[:title_sort]
        @movies = Movie.order(:title)
        @title_style = "hilite p-3 mb-2 bg-warning"
      elsif params[:date_sort]
        @movies = Movie.order(:release_date)
        @date_style = "hilite p-3 mb-2 bg-warning"
      else
        # @movies = Movie.all
        @movies = Movie.with_ratings(@checked_boxes)
      end
    end
  
    def new
      @all_ratings = Movie.all_ratings
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