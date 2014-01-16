require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!
  response = Typhoeus.get("http://www.omdbapi.com", :params => {:s => "#{search_str}"})

  parsed_str = JSON.parse(response.body)

  # parsed_str is {"Search":[{"Title":"The Simpsons Movie","Year":"2007","imdbID":"tt0462538","Type":"movie"},{"Title": etc.

  # parsed_str is {"Search"=>[{"Title"=>"The Simpsons Movie", "Year"=>"2007", "imdbID"=>"tt0462538", "Type"=>"movie"}, {"Title"=>"Scary Movie", etc.


  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  parsed_str["Search"].map{|movie| html_str += "<li><a href=poster/#{movie["imdbID"]}>#{movie["Title"]} #{movie["Year"]}</a></li>" }   

  # result_str["Search"].map{|movie| html_str += "<li><a href=http://www.imdb.com//title/#{movie["imdbID"]}>#{movie["Title"]} #{movie["Year"]}</a></li>" } 

  html_str += "</ul></body></html>"



end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.

  # imdb = params[:movie]

  response = Typhoeus.get("http://www.omdbapi.com", :params => {:i => "#{imdb_id}"})

  imdb_list = JSON.parse(response.body)


  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str += "<h3><img src=#{imdb_list["Poster"]}> </h3>"

  html_str += '<br /><a href="/">New Search</a></body></html>'

end



