package logging

import (
	"context"
	"go.opentelemetry.io/otel/trace"
	"log/slog"
)

const (
	traceCtxKey contextKey = iota + 1
)

type contextKey int

type SlogTraceHandler struct {
	slog.Handler
}

func (h SlogTraceHandler) Handle(ctx context.Context, r slog.Record) error {
	if traceId, ok := ctx.Value(traceCtxKey).(trace.TraceID); ok {
		r.Add("traceId", traceId)
	}
	return h.Handle(ctx, r)
}
