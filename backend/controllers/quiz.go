package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetQuizResults(c *gin.Context) {
	var results []models.QuizResult

	patientID := c.Query("patient_id")
	query := config.DB

	if patientID != "" {
		query = query.Where("patient_id = ?", patientID)
	}

	if err := query.Order("created_at desc").Find(&results).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch quiz results"})
		return
	}

	c.JSON(http.StatusOK, results)
}

func SaveQuizResult(c *gin.Context) {
	var result models.QuizResult
	if err := c.ShouldBindJSON(&result); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Create(&result).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save quiz result"})
		return
	}

	c.JSON(http.StatusCreated, result)
}
