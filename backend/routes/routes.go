package routes

import (
	"dementicare-backend/controllers"
	"dementicare-backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine) {
	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// Auth routes
	auth := router.Group("/auth")
	{
		auth.POST("/register", controllers.Register)
		auth.POST("/login", controllers.Login)
		auth.POST("/user/login", controllers.Login) // Alternative endpoint
		auth.POST("/change-password", middleware.AuthMiddleware(), controllers.ChangePassword)
	}

	// Protected routes
	api := router.Group("/api")
	api.Use(middleware.AuthMiddleware())
	{
		// Patient routes
		patients := api.Group("/patients")
		{
			patients.GET("", controllers.GetPatients)
			patients.GET("/:id", controllers.GetPatient)
			patients.POST("", controllers.CreatePatient)
			patients.PUT("/:id", controllers.UpdatePatient)
			patients.DELETE("/:id", controllers.DeletePatient)
		}

		// Appointment routes
		appointments := api.Group("/appointments")
		{
			appointments.GET("", controllers.GetAppointments)
			appointments.GET("/:id", controllers.GetAppointment)
			appointments.POST("", controllers.CreateAppointment)
			appointments.PUT("/:id", controllers.UpdateAppointment)
			appointments.DELETE("/:id", controllers.DeleteAppointment)
		}

		// Prescription routes
		prescriptions := api.Group("/prescriptions")
		{
			prescriptions.GET("", controllers.GetPrescriptions)
			prescriptions.GET("/:id", controllers.GetPrescription)
			prescriptions.POST("", controllers.CreatePrescription)
			prescriptions.PUT("/:id", controllers.UpdatePrescription)
			prescriptions.DELETE("/:id", controllers.DeletePrescription)
		}

		// Quiz routes
		quiz := api.Group("/quiz")
		{
			quiz.GET("/results", controllers.GetQuizResults)
			quiz.POST("/results", controllers.SaveQuizResult)
		}

		// Job routes
		jobs := api.Group("/jobs")
		{
			jobs.GET("", controllers.GetJobs)
			jobs.GET("/:id", controllers.GetJob)
			jobs.POST("", controllers.CreateJob)
			jobs.PUT("/:id", controllers.UpdateJob)
			jobs.DELETE("/:id", controllers.DeleteJob)
		}

		// Doctor recommendation (ML service proxy)
		api.POST("/recommend-doctor", controllers.RecommendDoctor)

		// Doctors list for appointment booking
		api.GET("/doctors", controllers.GetDoctors)
	}

	// Contact form (public)
	router.POST("/contact", controllers.CreateContact)
}
