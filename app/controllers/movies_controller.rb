class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings

      if !params.has_key?(:ratings) || !params.has_key?(:table_sort)
        if !params.has_key?(:ratings)
          if !session.has_key?(:ratings)
            ratings_hash = @all_ratings.each_with_object({}) {|rating, h| h[rating] = '1'}
            session[:ratings] = ratings_hash
          end
          params[:ratings] = session[:ratings]
        end
        if !params.has_key?(:table_sort)
          if !session.has_key?(:table_sort)
            session[:table_sort] = "no_sort"
          end
          params[:table_sort] = session[:table_sort]
        end
        flash.keep
        redirect_to movies_path(:ratings => params[:ratings], :table_sort => params[:table_sort]) and return
      end
      
      session[:ratings] = params[:ratings]
      session[:table_sort] = params[:table_sort]
      
      @checked_boxes = params[:ratings].keys
      @title_style = ""
      @date_style = ""
      @movies = Movie.all
      
      case params[:table_sort]
      when "title_sort"
        # logger.debug "here title"
        @movies = @movies.order(:title)
        @title_style = "hilite p-3 mb-2 bg-warning"
      when "date_sort"
        @movies = Movie.order(:release_date)
        @date_style = "hilite p-3 mb-2 bg-warning"
      else
        @title_style = ""
        @date_style = ""
      end
      
      @movies = @movies.with_ratings(@checked_boxes)
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