package controllers

import (
	"dementicare-backend/config"
	"dementicare-backend/models"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// Response struct for appointments with user names
type AppointmentResponse struct {
	ID          uint      `json:"id"`
	PatientID   uint      `json:"patient_id"`
	PatientName string    `json:"patient_name"`
	DoctorID    uint      `json:"doctor_id"`
	DoctorName  string    `json:"doctor_name"`
	Date        time.Time `json:"date"`
	Time        string    `json:"time"`
	Type        string    `json:"type"`
	Status      string    `json:"status"`
	Notes       string    `json:"notes"`
	CreatedAt   time.Time `json:"created_at"`
}

func GetAppointments(c *gin.Context) {
	userType := c.GetString("user_type")
	userID := c.GetUint("user_id")

	log.Printf("GetAppointments - userType: %s, userID: %d", userType, userID)

	var results []AppointmentResponse

	query := config.DB.Table("appointments").
		Select("appointments.*, " +
			"doctors.name as doctor_name, " +
			"patients.name as patient_name").
		Joins("LEFT JOIN users as doctors ON appointments.doctor_id = doctors.id").
		Joins("LEFT JOIN users as patients ON appointments.patient_id = patients.id").
		Order("appointments.created_at desc")

	// Filter based on user type
	if userType == "doctor" {
		log.Printf("Doctor viewing their appointments (doctor_id = %d)", userID)
		query = query.Where("appointments.doctor_id = ?", userID)
	} else if userType == "patient" {
		log.Printf("Patient viewing their appointments (patient_id = %d)", userID)
		query = query.Where("appointments.patient_id = ?", userID)
	}
	// Admin/caregiver can see all appointments

	if err := query.Scan(&results).Error; err != nil {
		log.Printf("Error fetching appointments: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch appointments"})
		return
	}

	log.Printf("Found %d appointments", len(results))
	c.JSON(http.StatusOK, gin.H{"appointments": results})
}

func GetAppointment(c *gin.Context) {
	id := c.Param("id")
	var appointment models.Appointment

	if err := config.DB.First(&appointment, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Appointment not found"})
		return
	}

	c.JSON(http.StatusOK, appointment)
}

func CreateAppointment(c *gin.Context) {
	userType := c.GetString("user_type")
	userID := c.GetUint("user_id")

	// Only patients can book appointments
	if userType != "patient" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only patients can book appointments"})
		return
	}

	var appointment models.Appointment
	if err := c.ShouldBindJSON(&appointment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Override patient_id with authenticated user's ID
	appointment.PatientID = userID

	// Validate doctor_id is provided
	if appointment.DoctorID == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Doctor ID is required"})
		return
	}

	if err := config.DB.Create(&appointment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create appointment"})
		return
	}

	log.Printf("Appointment created - ID: %d, Patient: %d, Doctor: %d", appointment.ID, appointment.PatientID, appointment.DoctorID)
	c.JSON(http.StatusCreated, appointment)
}

func UpdateAppointment(c *gin.Context) {
	id := c.Param("id")
	var appointment models.Appointment

	if err := config.DB.First(&appointment, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Appointment not found"})
		return
	}

	if err := c.ShouldBindJSON(&appointment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := config.DB.Save(&appointment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update appointment"})
		return
	}

	c.JSON(http.StatusOK, appointment)
}

func DeleteAppointment(c *gin.Context) {
	id := c.Param("id")

	if err := config.DB.Delete(&models.Appointment{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete appointment"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Appointment deleted successfully"})
}
