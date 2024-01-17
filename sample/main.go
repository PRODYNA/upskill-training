package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/httplog/v2"
	"github.com/prodyna/kuka-training/sample/handler/env"
	"github.com/prodyna/kuka-training/sample/handler/health"
	"github.com/prodyna/kuka-training/sample/handler/pi"
	"github.com/prodyna/kuka-training/sample/handler/root"
	"github.com/prodyna/kuka-training/sample/meta"
	"github.com/prodyna/kuka-training/sample/telemetry"
	"github.com/riandyrn/otelchi"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

const (
	portKey                  = "port"
	verboseKey               = "verbose"
	opentelemetryEndpointKey = "telemetry-endpoint"
	logformatKey             = "logformat"
)

func main() {
	flag.String(portKey, LookupEnvOrString("PORT", "8000"), "port to listen on (PORT)")
	flag.Int(verboseKey, LookupEnvOrInt("VERBOSE", 0), "verbosity level (VERBOSE)")
	flag.String(opentelemetryEndpointKey, LookupEnvOrString("OPENTELEMETRY_ENDPOINT", ""), "telemetry endpoint (OPENTELEMETRY_ENDPOINT)")
	flag.String("logformat", LookupEnvOrString("LOGFORMAT", "text"), "log format either json or text (LOGFORMAT)")
	flag.Bool("help", false, "show help")
	flag.Parse()

	if flag.Lookup("help").Value.String() == "true" {
		flag.Usage()
		return
	}

	jsonLog := flag.Lookup(logformatKey).Value.String() == "json"

	reqlog := httplog.NewLogger("httplog-example", httplog.Options{
		JSON:             jsonLog,
		LogLevel:         slog.LevelDebug,
		Concise:          true,
		RequestHeaders:   true,
		MessageFieldName: "message",
		TimeFieldFormat:  time.DateTime,
		Tags: map[string]string{
			"app":     meta.Name,
			"version": meta.Version,
		},
		QuietDownRoutes: []string{
			"/",
			"/health",
		},
		QuietDownPeriod: 10 * time.Second,
		// SourceFieldName: "source",
	})

	slog.Info("Configuration",
		"port", flag.Lookup("port").Value,
		"verbose", flag.Lookup("verbose").Value,
		"telemetry-endpoint", flag.Lookup("telemetry-endpoint").Value)

	var shutdown func(ctx context.Context) error
	opentelemetryEndpoint := flag.Lookup(opentelemetryEndpointKey).Value.String()
	if opentelemetryEndpoint != "" {
		slog.Info("OpenTelemetry enabled", "endpoint", opentelemetryEndpoint)
		sd, err := telemetry.InitOpenTelemetry(context.Background(), "sample", meta.Version, opentelemetryEndpoint)
		if err != nil {
			slog.Error("Failed to initialize OpenTelemetry", "error", err)
			return
		}
		shutdown = sd
	} else {
		slog.Info("OpenTelemetry disabled")
	}

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
	r.Get("/pi/{duration}", pi.PiHandler)

	go func() {
		port := fmt.Sprintf(":%s", flag.Lookup(portKey).Value)
		slog.Info("Starting server", "port", port)
		if err := http.ListenAndServe(port, r); err != nil {
			slog.Error("Failed to start server", "error", err)
		}
	}()

	<-done
	slog.Info("Shutting down server")
	if shutdown != nil {
		slog.Info("Shutting down OpenTelemetry")
		err := shutdown(context.Background())
		if err != nil {
			slog.Error("Failed to shutdown OpenTelemetry", "error", err)
		}
	}

}

func LookupEnvOrString(key string, defaultVal string) string {
	if val, ok := os.LookupEnv(key); ok {
		return val
	}
	return defaultVal
}

func LookupEnvOrInt(key string, defaultVal int) int {
	if val, ok := os.LookupEnv(key); ok {
		v, err := strconv.Atoi(val)
		if err != nil {
			slog.Error("Failed to parse environment variable", "key", key, "value", val, "error", err)
		}
		return v
	}
	return defaultVal
}
