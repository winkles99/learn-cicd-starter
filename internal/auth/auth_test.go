package auth

import (
	"net/http"
	"testing"
)

func TestGetAPIKey_Success(t *testing.T) {
	headers := http.Header{}
	headers.Set("Authorization", "ApiKey testkey123")
	key, err := GetAPIKey(headers)
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if key != "testkey123" {
		t.Errorf("expected key 'testkey123', got '%s'", key)
	}
}

func TestGetAPIKey_NoHeader(t *testing.T) {
	headers := http.Header{}
	key, err := GetAPIKey(headers)
	if err == nil {
		t.Fatal("expected error for missing header, got nil")
	}
	if key != "" {
		t.Errorf("expected empty key, got '%s'", key)
	}
}

func TestGetAPIKey_MalformedHeader(t *testing.T) {
	headers := http.Header{}
	headers.Set("Authorization", "Bearer sometoken")
	key, err := GetAPIKey(headers)
	if err == nil {
		t.Fatal("expected error for malformed header, got nil")
	}
	if key != "" {
		t.Errorf("expected empty key, got '%s'", key)
	}
}
