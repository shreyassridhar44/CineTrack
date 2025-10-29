import * as functions from "firebase-functions";
import * as https from "https";
// Use the correct TypeScript syntax for importing CommonJS modules like 'cors'
import cors = require("cors");

// Initialize cors middleware to allow requests from any origin
const corsHandler = cors({origin: true});

// Your TMDB API key is now securely stored on the server
const tmdbApiKey = "160525505900ecae3ec71989bcd8e898";

export const tmdbProxy = functions.https.onRequest((request, response) => {
  // Handle CORS preflight requests
  corsHandler(request, response, () => {
    // The path from the original request (e.g., /movie/popular)
    const requestPath = request.path;

    // The query from the original request (e.g., ?page=2)
    const requestQuery = request.url.split("?")[1] || "";
    
    // Construct the full URL to the TMDB API
    const apiUrl = `https://api.themoviedb.org/3${requestPath}` +
                   `?api_key=${tmdbApiKey}&${requestQuery}`;

    // Make the request to the TMDB API
    https.get(apiUrl, (apiRes) => {
      let data = "";
      apiRes.on("data", (chunk) => {
        data += chunk;
      });
      apiRes.on("end", () => {
        response.status(200).send(data);
      });
    }).on("error", (_err) => { // Use _err to avoid "unused variable" error
      functions.logger.error("Error fetching from TMDB:", _err);
      response.status(500).send({error: "Failed to fetch data from TMDB"});
    });
  });
});