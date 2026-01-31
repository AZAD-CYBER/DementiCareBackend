package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetJobs(c *gin.Context) {
	var jobs []models.Job

	if err := config.DB.Where("status = ?", "active").Order("created_at desc").Find(&jobs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch jobs"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"jobs": jobs})
}

func GetJob(c *gin.Context) {
	id := c.Param("id")
	var job models.Job

	if err := config.DB.First(&job, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Job not found"})
		return
	}

	c.JSON(http.StatusOK, job)
}

func CreateJob(c *gin.Context) {
	var job models.Job
	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Get user_id from JWT token if available, otherwise default to 1
	userID, exists := c.Get("user_id")
	if exists {
		job.PostedBy = userID.(uint)
	} else {
		job.PostedBy = 1 // Default to user 1 if not authenticated
	}

	job.Status = "active" // Set default status

	if err := config.DB.Create(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create job"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"job": job, "message": "Job created successfully"})
}

func UpdateJob(c *gin.Context) {
	id := c.Param("id")
	var job models.Job

	if err := config.DB.First(&job, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Job not found"})
		return
	}

	if err := c.ShouldBindJSON(&job); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Save(&job).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update job"})
		return
	}

	c.JSON(http.StatusOK, job)
}

func DeleteJob(c *gin.Context) {
	id := c.Param("id")

	if err := config.DB.Delete(&models.Job{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete job"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Job deleted successfully"})
}
