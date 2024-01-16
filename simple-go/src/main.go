package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
  "strings"
	"github.com/gorilla/mux"
  "sort"
  "math/big"
  "runtime"
  "strconv"
  "sync"
  "time"
  "log"
  "io"
)

// HealthResponse represents the response for the health endpoint
type HealthResponse struct {
	Status string `json:"status"`
}

// EnvResponse represents the response for the environment variables endpoint
type EnvResponse map[string]string

func main() {
	r := mux.NewRouter()

  // Create a log file for request logging
	logFile, err := os.Create("requests.log")
	if err != nil {
		log.Fatal("Error creating log file: ", err)
	}
	defer logFile.Close()

	// Use log.New to create a logger that writes to both stdout and the log file
	logger := log.New(io.MultiWriter(os.Stdout, logFile), "HTTP ", log.Ldate|log.Ltime)

	// Define routes
  r.HandleFunc("/", RootHandler).Methods("GET")
	r.HandleFunc("/health", HealthHandler).Methods("GET")
	r.HandleFunc("/status", HealthHandler).Methods("GET")
	r.HandleFunc("/env", EnvHandler).Methods("GET")
  r.HandleFunc("/load", LoadHandler)

  r.Path("/favicon.ico").Handler(http.StripPrefix("/",
		http.FileServer(http.Dir("."))))
  r.PathPrefix("/").HandlerFunc(DefaultErrorHandler)
  http.Handle("/", r)  

	// Start the server
	port := 8080
  logger.Printf("Server is running on port %d...\n", port)
  http.ListenAndServe(fmt.Sprintf(":%d", port), r)
}

func DefaultErrorHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Received request for unknown path: %s %s", r.Method, r.URL.Path)
	http.NotFound(w, r)
}

func RootHandler(w http.ResponseWriter, r *http.Request) {
	html := `
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<title>Welcome to Go Service</title>
			<style>
				body {
					font-family: Arial, sans-serif;
`
	html += fmt.Sprintf("				background-color: %s !important;", os.Getenv("BG_COLOR"))
	html += `
					background-color: #f4f4f4;
					margin: 0;
					padding: 0;
					display: flex;
					justify-content: center;
					align-items: center;
					height: 100vh;
				}

				.container {
					text-align: center;
				}

				h1 {
					color: #333;
				}

				p {
					color: #666;
				}
			</style>
		</head>
		<body>
			<div class="container">
`

html += fmt.Sprintf("				<h1>%s!</h1>", os.Getenv("WELCOME_MSG"))
html += `
				
				<p>This is a simple Go web service.</p>
			</div>
		</body>
		</html>
	`
  
  log.Printf("Received request: %s %s", r.Method, r.URL.Path)
	w.Header().Set("Content-Type", "text/html")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, html)
}

// HealthHandler handles requests to the health endpoint
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{Status: "OK"}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// ... (previous code)

// EnvHandler handles requests to the environment variables endpoint
func EnvHandler(w http.ResponseWriter, r *http.Request) {
	envVars := EnvResponse{}
  log.Printf("Received request: %s %s", r.Method, r.URL.Path)
	for _, envVar := range os.Environ() {
		pair := strings.SplitN(envVar, "=", 2)
		envVars[pair[0]] = strings.Replace(pair[1], "\n", "<br>", -1)
	}

	// Sort the environment variables alphabetically
	keys := make([]string, 0, len(envVars))
	for key := range envVars {
		keys = append(keys, key)
	}
	sort.Strings(keys)

html := `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Environment Variables</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .container {
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                width: 60%;
                margin-top: 50px;
            }

            h1 {
                color: #A0C52A;
                border-bottom: 2px solid #dee2e6;
                padding-bottom: 10px;
                margin-bottom: 20px;
                text-align: center;
            }

            .variable {
                margin-bottom: 10px;
                clear: both;
                word-break: break-all;
            }

            .variable span {
                font-weight: bold;
                color: #A0C52A;
                display: block;
                float: left;
                width: 200px;
            }

            .variable p {
                margin: 0;
                padding-left: 250px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Environment Variables</h1>
`


	for _, key := range keys {
		value := envVars[key]
		html += fmt.Sprintf("<div class=\"variable\"><span>%s:</span> <p>%s</p></div>", key, value)
	}

	html += `
			</div>
		</body>
		</html>
	`

	w.Header().Set("Content-Type", "text/html")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, html)
}

func LoadHandler(w http.ResponseWriter, r *http.Request) {
	// Parse the query parameter "duration" for the time in seconds
	durationStr := r.URL.Query().Get("duration")
  log.Printf("Received request: %s %s %s", r.Method, r.URL.Path, durationStr)
	duration, err := strconv.Atoi(durationStr)
	if err != nil || duration <= 0 {
		http.Error(w, "Invalid value for 'duration'", http.StatusBadRequest)
		return
	}

	// Use goroutines to perform mathematical calculations concurrently for the specified duration
	var wg sync.WaitGroup
	wg.Add(runtime.NumCPU())
	for i := 0; i < runtime.NumCPU(); i++ {
		go func() {
			defer wg.Done()
			calculatePiWithDuration(duration)
		}()
	}
	wg.Wait()

	fmt.Fprintf(w, "Calculations completed for %d seconds on %d CPU cores\n", duration, runtime.NumCPU())
}

// calculatePiWithDuration performs mathematical calculations to approximate Pi for the specified duration
func calculatePiWithDuration(duration int) {
	startTime := time.Now()

	for time.Since(startTime).Seconds() < float64(duration) {
		// Use the Nilakantha Somayaji series to approximate Pi
		result := new(big.Float).SetFloat64(3.0)
		sign := 1.0

		for i := 1; i <= 100000; i++ {
			term := new(big.Float).SetFloat64(1.0 / float64((2*i)*(2*i+1)*(2*i+2)))
			term.Mul(term, new(big.Float).SetFloat64(sign))
			result.Add(result, term)
			sign *= -1
		}

		pi := new(big.Float).SetFloat64(3.0)
		pi.Add(pi, result)

		// The result is not used; this is just to consume CPU resources
		_ = pi
	}
}
