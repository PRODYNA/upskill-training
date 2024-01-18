package pi

import (
	"context"
	"testing"
)

// test the pi function
func TestPiDuration(testing *testing.T) {
	ctx := context.Background()
	calculatePiWithDuration(ctx, 3)
}
