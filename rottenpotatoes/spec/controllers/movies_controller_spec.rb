require 'rails_helper'
require 'support/action_controller_workaround'

describe MoviesController, type: :controller do
  
  describe 'show home page' do
    it 'should render the home page' do
      get :index
      expect(response).to render_template(:index)
    end
  end
  
  describe 'add movie page' do 
    it 'should render the #new page' do 
      get :new
      expect(response).to render_template(:new)
    end
    
    it 'should add a movie' do
      params = 
      { movie: 
        {
          title: 'Inception', 
          rating: 'PG', 
          director: 'Christopher Nolan', 
          release_date: '2010-01-01'
        }
      }
      post :create, params
      expect(response).to redirect_to(movies_path)
    end
  end
  
  describe 'edit movie' do 
    it 'should render the #edit page given a movie' do 
      @movie = Movie.create!(:title => 'Inception')
      get :edit, {:id => @movie.id}
      expect(response).to render_template(:edit)
    end
    
    it 'should edit the movie' do 
      @movie = Movie.create!(:title => 'Inception')
      params = {
        movie: {
          release_date: '2010-01-01'
        },
        id: @movie.id
      }
      put :update, params
      
      # verify update is made in database
      @movie = Movie.where("id = ?", @movie.id).first
      expect(@movie[:release_date]).to eq '2010-01-01'
    end
  end
  
  describe 'show movie details page' do 
    it 'should render the #show page given a movie' do 
      @movie = Movie.create!(:title => 'Inception')
      get :show, {:id => @movie.id}
      expect(response).to render_template(:show)
    end
  end
  
  describe 'show movies with same director' do
    # set up data for testing
    before :all do
      @movie1 = Movie.create!(:title => 'Star Wars', :rating => 'PG', :director => 'George Lucas', :release_date => '1977-05-25')
      @movie2 = Movie.create!(:title => 'Blade Runner', :rating => 'PG', :director => 'Ridley Scott', :release_date => '1982-06-25')
      @movie3 = Movie.create!(:title => 'Alien ', :rating => 'R', :release_date => '1979-05-25')
      @movie4 = Movie.create!(:title => 'THX-1138', :rating => 'R', :director => 'George Lucas', :release_date => '1971-03-11')
    end
    
    # clean database after finish
    after :all do 
      DatabaseCleaner.clean_with(:truncation)
    end
    
    it 'should call method to find movies with same director' do 
      get :director, {:id => @movie2.id}
      # method call successfully
      expect(response.status).to eq(200)
    end
    
    it 'should redirect to home page when director is empty' do 
      # @movie3 does not have a director 
      get :director, {:id => @movie3.id}
      # movies_path == home page
      expect(response).to redirect_to(movies_path)
    end 
    
    it 'should render a page with all movies of the same director' do 
      # @movie1 and @movie 4 have the same director
      get :director, {:id => @movie1.id}
      expect(assigns(:movies)).to eq [@movie1, @movie4]
      expect(response).to render_template(:director)
    end
  end
end