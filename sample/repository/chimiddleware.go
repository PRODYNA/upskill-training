package repository

import (
	"fmt"
	"net/http"
)

func (config *Config) RequestCount(next http.Handler) http.Handler {
	return http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		if config.Enabled {
			config.client.Incr(ctx, fmt.Sprintf("%s-all", prefix))
			requestKey := fmt.Sprintf("%s-%s", prefix, r.URL.Path)
			config.client.Incr(ctx, requestKey)
		}
		next.ServeHTTP(rw, r.WithContext(ctx))
	})
}
