package models

import (
	"time"

	"gorm.io/gorm"
)

type Prescription struct {
	ID           uint           `gorm:"primaryKey" json:"id"`
	PatientID    uint           `json:"patient_id"`
	DoctorID     uint           `json:"doctor_id"`
	Medication   string         `json:"medication"`
	Dosage       string         `json:"dosage"`
	Frequency    string         `json:"frequency"`
	Duration     string         `json:"duration"`
	Instructions string         `json:"instructions"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
}
