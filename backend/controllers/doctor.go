package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// GetDoctors returns all users with user_type = 'doctor'
func GetDoctors(c *gin.Context) {
	var doctors []models.User

	if err := config.DB.Where("user_type = ?", "doctor").Find(&doctors).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch doctors"})
		return
	}

	// Remove password from response
	for i := range doctors {
		doctors[i].Password = ""
	}

	c.JSON(http.StatusOK, gin.H{"doctors": doctors})
}
