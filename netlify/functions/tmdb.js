exports.handler = async (event, context) => {
  // Get the API key from the environment variables we will set on Netlify
  const { TMDB_API_KEY } = process.env;

  // Get the movie path (e.g., /movie/popular) from the request
  const moviePath = event.path.replace("/.netlify/functions/tmdb", "");

  // Get any query params (e.g., ?page=2) from the request
  const queryString = event.queryStringParameters ? `?${new URLSearchParams(event.queryStringParameters).toString()}` : "";

  // Construct the full, secure API URL
  const apiUrl = `https://api.themoviedb.org/3${moviePath}?api_key=${TMDB_API_KEY}&${queryString}`;

  try {
    // Fetch data from the TMDB API
    const response = await fetch(apiUrl);
    const data = await response.json();

    return {
      statusCode: 200,
      body: JSON.stringify(data),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to fetch data from TMDB" }),
    };
  }
};