package controllers

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type DoctorRecommendationRequest struct {
	Rating     int `json:"rating"`
	Experience int `json:"experience"`
}

func RecommendDoctor(c *gin.Context) {
	var req DoctorRecommendationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Get ML service URL from environment
	mlServiceURL := os.Getenv("ML_SERVICE_URL")
	if mlServiceURL == "" {
		mlServiceURL = "http://localhost:5001"
	}

	// Prepare request to ML service
	requestBody, err := json.Marshal(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to prepare ML request"})
		return
	}

	// Call Python ML service
	resp, err := http.Post(mlServiceURL+"/recommend", "application/json", bytes.NewBuffer(requestBody))
	if err != nil {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "ML service unavailable"})
		return
	}
	defer resp.Body.Close()

	// Read response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to read ML response"})
		return
	}

	// Parse and forward response
	var mlResponse map[string]interface{}
	if err := json.Unmarshal(body, &mlResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse ML response"})
		return
	}

	c.JSON(http.StatusOK, mlResponse)
}
