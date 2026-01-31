package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetPrescriptions(c *gin.Context) {
	var prescriptions []models.Prescription

	patientID := c.Query("patient_id")
	query := config.DB

	if patientID != "" {
		query = query.Where("patient_id = ?", patientID)
	}

	if err := query.Find(&prescriptions).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch prescriptions"})
		return
	}

	c.JSON(http.StatusOK, prescriptions)
}

func GetPrescription(c *gin.Context) {
	id := c.Param("id")
	var prescription models.Prescription

	if err := config.DB.First(&prescription, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Prescription not found"})
		return
	}

	c.JSON(http.StatusOK, prescription)
}

func CreatePrescription(c *gin.Context) {
	var prescription models.Prescription
	if err := c.ShouldBindJSON(&prescription); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Set doctor ID from authenticated user
	prescription.DoctorID = c.GetUint("user_id")

	if err := config.DB.Create(&prescription).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create prescription"})
		return
	}

	c.JSON(http.StatusCreated, prescription)
}

func UpdatePrescription(c *gin.Context) {
	id := c.Param("id")
	var prescription models.Prescription

	if err := config.DB.First(&prescription, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Prescription not found"})
		return
	}

	if err := c.ShouldBindJSON(&prescription); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Save(&prescription).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update prescription"})
		return
	}

	c.JSON(http.StatusOK, prescription)
}

func DeletePrescription(c *gin.Context) {
	id := c.Param("id")

	if err := config.DB.Delete(&models.Prescription{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete prescription"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Prescription deleted successfully"})
}
