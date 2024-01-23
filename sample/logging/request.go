package logging

import (
	"github.com/go-chi/httplog/v2"
	"log/slog"
	"net/http"
	"time"
)

var skipPaths = []string{}

func RequestLogger() func(next http.Handler) http.Handler {
	logOptions := httplog.Options{
		Concise:        true,
		RequestHeaders: true,
		HideRequestHeaders: []string{
			"accept",
			"accept-encoding",
			"accept-language",
			"accept-ranges",
			"connection",
			"cookie",
			"user-agent",
		},
		QuietDownRoutes: []string{
			"/health",
		},
		QuietDownPeriod: 10 * time.Second,
	}
	httpLogger := &httplog.Logger{
		Logger:  slog.Default(),
		Options: logOptions,
	}
	return httplog.Handler(httpLogger, skipPaths)
}
