package repository

import (
	"context"
	"github.com/redis/go-redis/extra/redisotel/v9"
	"github.com/redis/go-redis/v9"
	"log/slog"
)

const prefix = "sample"

type Config struct {
	Enabled  bool
	Endpoint string
	client   *redis.Client
}

func (c *Config) Connect(ctx context.Context) (err error) {
	if c.Enabled {
		c.client = redis.NewClient(&redis.Options{
			Addr: c.Endpoint,
			DB:   0,
		})
		if _, err = c.client.Ping(ctx).Result(); err != nil {
			return err
		}
		if err = redisotel.InstrumentTracing(c.client); err != nil {
			return err
		}
		if err = redisotel.InstrumentMetrics(c.client); err != nil {
			return err
		}
	}
	return nil
}

func (c *Config) Disconnect(ctx context.Context) (err error) {
	if c.Enabled {
		err = c.client.Close()
		if err != nil {
			slog.Error("Failed to disconnect from redis", "error", err)
		}
		return err
	}
	return nil
}
