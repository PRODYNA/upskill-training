package main

import (
	"flag"
	"fmt"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/httplog/v2"
	"github.com/prodyna/kuka-training/sample/handler/env"
	"github.com/prodyna/kuka-training/sample/handler/health"
	"github.com/prodyna/kuka-training/sample/handler/pi"
	"github.com/prodyna/kuka-training/sample/handler/root"
	"github.com/riandyrn/otelchi"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

const (
	portKey    = "port"
	verboseKey = "verbose"
)

func main() {
	flag.String(portKey, "8000", "port to listen on")
	flag.Int(verboseKey, 0, "verbosity level")
	flag.Parse()

	reqlog := httplog.NewLogger("httplog-example", httplog.Options{
		// JSON:             true,
		LogLevel:         slog.LevelDebug,
		Concise:          true,
		RequestHeaders:   true,
		MessageFieldName: "message",
		// TimeFieldFormat: time.RFC850,
		Tags: map[string]string{
			"version": "v1.0-81aa4244d9fc8076a",
			"env":     "dev",
		},
		QuietDownRoutes: []string{
			"/",
			"/health",
		},
		QuietDownPeriod: 10 * time.Second,
		// SourceFieldName: "source",
	})

	slog.Info("Configuration", "port", flag.Lookup("port").Value, "verbose", flag.Lookup("verbose").Value)

	done := make(chan os.Signal, 1)
	signal.Notify(done, syscall.SIGINT, syscall.SIGTERM)

	// create chi router
	r := chi.NewRouter()

	// add otelchi middleware
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Recoverer)
	r.Use(httplog.RequestLogger(reqlog))
	r.Use(otelchi.Middleware("sample"))

	r.Get("/", root.RootHandler)
	r.Get("/health", health.HealthHandler)
	r.Get("/env", env.EnvHandler)
	r.Get("/pi", pi.PiHandler)

	go func() {
		port := fmt.Sprintf(":%s", flag.Lookup(portKey).Value)
		slog.Info("Starting server", "port", port)
		if err := http.ListenAndServe(port, r); err != nil {
			slog.Error("Failed to start server", "error", err)
		}
	}()

	<-done
	slog.Info("Shutting down server")

}
