package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateContact(c *gin.Context) {
	var contact models.Contact
	if err := c.ShouldBindJSON(&contact); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Create(&contact).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save contact message"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Contact message sent successfully"})
}
