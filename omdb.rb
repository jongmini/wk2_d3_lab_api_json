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

  search_str = response.body

  # search_str is {"Search":[{"Title":"The Simpsons Movie","Year":"2007","imdbID":"tt0462538","Type":"movie"},{"Title":"Scary Movie","Year":"2000","imdbID":"tt0175142","Type":"movie"},{"Title":"Scary Movie 2","Year":"2001","imdbID":"tt0257106","Type":"movie"},{"Title":"Scary Movie 3","Year":"2003","imdbID":"tt0306047","Type":"movie"},{"Title":"Bee Movie","Year":"2007","imdbID":"tt0389790","Type":"movie"},{"Title":"Epic Movie","Year":"2007","imdbID":"tt0799949","Type":"movie"},{"Title":"Scary Movie 4","Year":"2006","imdbID":"tt0362120","Type":"movie"},{"Title":"Not Another Teen Movie","Year":"2001","imdbID":"tt0277371","Type":"movie"},{"Title":"Disaster Movie","Year":"2008","imdbID":"tt1213644","Type":"movie"},{"Title":"Jackass: The Movie","Year":"2002","imdbID":"tt0322802","Type":"movie"}]}

  result_str = JSON.parse(search_str)

  # result_str is {"Search"=>[{"Title"=>"The Simpsons Movie", "Year"=>"2007", "imdbID"=>"tt0462538", "Type"=>"movie"}, {"Title"=>"Scary Movie", "Year"=>"2000", "imdbID"=>"tt0175142", "Type"=>"movie"}, {"Title"=>"Scary Movie 2", "Year"=>"2001", "imdbID"=>"tt0257106", "Type"=>"movie"}, {"Title"=>"Scary Movie 3", "Year"=>"2003", "imdbID"=>"tt0306047", "Type"=>"movie"}, {"Title"=>"Bee Movie", "Year"=>"2007", "imdbID"=>"tt0389790", "Type"=>"movie"}, {"Title"=>"Epic Movie", "Year"=>"2007", "imdbID"=>"tt0799949", "Type"=>"movie"}, {"Title"=>"Scary Movie 4", "Year"=>"2006", "imdbID"=>"tt0362120", "Type"=>"movie"}, {"Title"=>"Not Another Teen Movie", "Year"=>"2001", "imdbID"=>"tt0277371", "Type"=>"movie"}, {"Title"=>"Disaster Movie", "Year"=>"2008", "imdbID"=>"tt1213644", "Type"=>"movie"}, {"Title"=>"Jackass: The Movie", "Year"=>"2002", "imdbID"=>"tt0322802", "Type"=>"movie"}]}


  # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  result_str["Search"].map{|movie| html_str += "<li><a href=poster/#{movie["imdbID"]}>#{movie["Title"]} #{movie["Year"]}</a></li>" }   

  # result_str["Search"].map{|movie| html_str += "<li><a href=http://www.imdb.com//title/#{movie["imdbID"]}>#{movie["Title"]} #{movie["Year"]}</a></li>" } 

  html_str += "</ul></body></html>"



end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.

  # imdb = params[:movie]

  response = Typhoeus.get("http://www.omdbapi.com", :params => {:i => "#{imdb_id}"})

  imdb_list = response.body

  result_str = JSON.parse(imdb_list)

  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3>#{result_str["Search"]["Poster"]}</h3>"

  # result_str["Search"].map{ |movie| movie["Poster"] }

  html_str += '<br /><a href="/">New Search</a></body></html>'

end

# http://www.imdb.com/media/rm3844446208/tt0317219?ref_=tt_ov_i

# http://www.imdb.com/media/rm3873693440/tt2294629?ref_=tt_ov_i

