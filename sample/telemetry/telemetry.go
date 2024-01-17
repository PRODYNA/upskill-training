package telemetry

import (
	"context"
	"errors"
	"fmt"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	metric2 "go.opentelemetry.io/otel/metric"
	trace2 "go.opentelemetry.io/otel/trace"
	"google.golang.org/grpc/credentials/insecure"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetricgrpc"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/metric"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.21.0"
	"google.golang.org/grpc"
	"time"
)

func InitOpenTelemetry(ctx context.Context, serviceName, serviceVersion string, endpoint string) (shutdown func(context.Context) error, err error) {
	if endpoint == "" {
		return func(context.Context) error { return nil }, nil
	}

	var shutdownFuncs []func(context.Context) error

	// shutdown is a helper function that calls all the shutdown functions
	shutdown = func(ctx context.Context) error {
		var err error
		for _, fn := range shutdownFuncs {
			err = errors.Join(err, fn(ctx))
		}
		shutdownFuncs = nil
		return err
	}

	// handleErr calls shutdown for cleanup and makes sure that all errors are returned
	handleErr := func(inErr error) {
		err = errors.Join(inErr, shutdown(ctx))
	}

	// Setup up resource
	res, err := newResource(serviceName, serviceVersion)
	if err != nil {
		handleErr(err)
		return
	}

	// Setup up propagator
	prop := newPropagator()
	otel.SetTextMapPropagator(prop)

	// Setup up trace provider
	traceProvider, err := newTraceProvider(res, endpoint)
	if err != nil {
		handleErr(err)
		return
	}
	shutdownFuncs = append(shutdownFuncs, traceProvider.Shutdown)
	otel.SetTracerProvider(traceProvider)

	// Setup up meter provider
	meterProvider, err := newMeterProvider(ctx, res, endpoint)
	if err != nil {
		handleErr(err)
		return
	}
	shutdownFuncs = append(shutdownFuncs, meterProvider.Shutdown)
	otel.SetMeterProvider(meterProvider)

	return
}

func newTraceExporter(ctx context.Context, endpoint string) (exporter *otlptrace.Exporter, err error) {
	ctx, cancel := context.WithTimeout(ctx, time.Second)
	defer cancel()

	conn, err := grpc.DialContext(ctx, endpoint, grpc.WithTransportCredentials(insecure.NewCredentials()), grpc.WithBlock())
	if err != nil {
		return nil, fmt.Errorf("Unable to create gRPC connection to collector %s: %w", endpoint, err)
	}

	traceExporter, err := otlptracegrpc.New(ctx, otlptracegrpc.WithGRPCConn(conn))
	if err != nil {
		return nil, fmt.Errorf("Unable to create trace exporter to collector %s: %w", endpoint, err)
	}

	return traceExporter, nil
}

func newMetricExporter(ctx context.Context, endpoint string) (exporter *otlpmetricgrpc.Exporter, err error) {
	ctx, cancel := context.WithTimeout(ctx, time.Second)
	defer cancel()

	conn, err := grpc.DialContext(ctx, endpoint, grpc.WithTransportCredentials(insecure.NewCredentials()), grpc.WithBlock())
	if err != nil {
		return nil, fmt.Errorf("Unable to create gRPC connection to collector %s: %w", endpoint, err)
	}

	metricsexporter, err := otlpmetricgrpc.New(ctx, otlpmetricgrpc.WithGRPCConn(conn))
	if err != nil {
		return nil, fmt.Errorf("Unable to create metrics exporter to collector %s: %w", endpoint, err)
	}

	return metricsexporter, nil
}

func newResource(serviceName string, serviceVersion string) (*resource.Resource, error) {
	return resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceName(serviceName),
			semconv.ServiceVersion(serviceVersion),
		),
	)
}

func newPropagator() propagation.TextMapPropagator {
	return propagation.NewCompositeTextMapPropagator(
		propagation.TraceContext{},
		propagation.Baggage{})
}

func newTraceProvider(res *resource.Resource, endpoint string) (*trace.TracerProvider, error) {
	traceExporter, err := newTraceExporter(context.Background(), endpoint)
	if err != nil {
		return nil, err
	}

	traceProvider := trace.NewTracerProvider(
		trace.WithBatcher(traceExporter,
			trace.WithBatchTimeout(5*time.Second)),
		trace.WithResource(res),
	)

	return traceProvider, nil
}

func newMeterProvider(ctx context.Context, res *resource.Resource, endpoint string) (*metric.MeterProvider, error) {
	metricExporter, err := newMetricExporter(ctx, endpoint)
	if err != nil {
		return nil, err
	}

	meterProvider := metric.NewMeterProvider(
		metric.WithResource(res),
		metric.WithReader(metric.NewPeriodicReader(metricExporter,
			metric.WithInterval(5*time.Second))),
	)
	return meterProvider, nil
}

func Tracer() trace2.Tracer {
	return otel.Tracer("yasm-proxy-odbc")
}

func Meter() metric2.Meter {
	return otel.Meter("yasm-proxy-odbc")
}
