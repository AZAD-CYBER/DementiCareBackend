package models

import (
	"time"

	"gorm.io/gorm"
)

type Appointment struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	PatientID uint           `json:"patient_id"`
	DoctorID  uint           `json:"doctor_id"`
	Date      time.Time      `json:"date"`
	Time      string         `json:"time"`
	Type      string         `json:"type"`                            // consultation, follow-up, emergency
	Status    string         `json:"status" gorm:"default:'pending'"` // pending, confirmed, cancelled, completed
	Notes     string         `json:"notes"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}
