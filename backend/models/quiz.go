package models

import (
	"time"

	"gorm.io/gorm"
)

type QuizResult struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	PatientID uint           `json:"patient_id"`
	Score     int            `json:"score"`
	MaxScore  int            `json:"max_score"`
	Answers   string         `json:"answers" gorm:"type:json"` // Store as JSON
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}
