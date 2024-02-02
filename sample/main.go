package main

import (
	"context"
	"flag"
	"fmt"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/prodyna/kuka-training/sample/handler/env"
	"github.com/prodyna/kuka-training/sample/handler/health"
	"github.com/prodyna/kuka-training/sample/handler/pi"
	"github.com/prodyna/kuka-training/sample/handler/root"
	"github.com/prodyna/kuka-training/sample/logging"
	"github.com/prodyna/kuka-training/sample/meta"
	"github.com/prodyna/kuka-training/sample/telemetry"
	"github.com/prodyna/kuka-training/sample/telemetry/metrics"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/riandyrn/otelchi"
	"github.com/samber/slog-chi"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
)

const (
	portKey                  = "port"
	verboseKey               = "verbose"
	opentelemetryEndpointKey = "telemetry-endpoint"
	logformatKey             = "logformat"
	staticDirKey             = "static-dir"
)

func main() {
	flag.String(portKey, LookupEnvOrString("PORT", "8000"), "port to listen on (PORT)")
	flag.Int(verboseKey, LookupEnvOrInt("VERBOSE", 0), "verbosity level (VERBOSE)")
	flag.String(opentelemetryEndpointKey, LookupEnvOrString("OPENTELEMETRY_ENDPOINT", ""), "OpenTelemetry endpoint (OPENTELEMETRY_ENDPOINT)")
	flag.String("logformat", LookupEnvOrString("LOGFORMAT", "text"), "log format either json or text (LOGFORMAT)")
	flag.String(staticDirKey, LookupEnvOrString("STATICDIR", "static"), "static directory (STATIC_DIR)")
	flag.Bool("help", false, "show help")
	flag.Parse()

	if flag.Lookup("help").Value.String() == "true" {
		flag.Usage()
		return
	}

	json := flag.Lookup(logformatKey).Value.String() == "json"
	logging.LoggerConfig{
		JSON: json,
	}.ConfigureDefaultLogger()

	slog.Info("Configuration",
		portKey, flag.Lookup(portKey).Value,
		verboseKey, flag.Lookup(verboseKey).Value,
		opentelemetryEndpointKey, flag.Lookup(opentelemetryEndpointKey).Value,
		logformatKey, flag.Lookup(logformatKey).Value,
		staticDirKey, flag.Lookup(staticDirKey).Value)

	var shutdown func(ctx context.Context) error
	opentelemetryEndpoint := flag.Lookup(opentelemetryEndpointKey).Value.String()
	if opentelemetryEndpoint != "" {
		slog.Info("OpenTelemetry enabled", "endpoint", opentelemetryEndpoint)
		sd, err := telemetry.InitOpenTelemetry(context.Background(), meta.Name, meta.Version, opentelemetryEndpoint)
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

	requestCount, err := metrics.NewRequestCountHandler()
	if err != nil {
		slog.Error("Failed to create request count handler", "error", err)
		return
	}

	// add otelchi middleware
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(otelchi.Middleware(meta.Name))
	r.Use(slogchi.NewWithConfig(slog.Default(), slogchi.Config{
		WithSpanID:  true,
		WithTraceID: true,
	}))
	r.Use(middleware.Recoverer)
	r.Use(requestCount.RequestCount)

	// create pi handler config
	piHandlerConfig, err := pi.NewPiConfig()
	if err != nil {
		slog.Error("Failed to create pi handler config", "error", err)
		return
	}

	r.Get("/", root.RootHandler)
	r.Get("/health", health.HealthHandler)
	r.Get("/env", env.EnvHandler)
	r.Get("/pi/{duration}", piHandlerConfig.PiHandler)

	// some handlers
	staticDir := flag.Lookup(staticDirKey).Value.String()
	fs := http.FileServer(http.Dir(staticDir))
	slog.Info("Serving static files from", "static-dir", staticDir)
	r.Handle("/static/*", http.StripPrefix("/static/", fs))
	r.Handle("/favicon.ico", http.NotFoundHandler())
	r.Handle("/metrics", promhttp.Handler())

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
