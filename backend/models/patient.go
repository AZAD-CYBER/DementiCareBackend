package models

import (
	"time"

	"gorm.io/gorm"
)

type Patient struct {
	ID          uint           `gorm:"primaryKey" json:"id"`
	Name        string         `json:"name"`
	Age         int            `json:"age"`
	Gender      string         `json:"gender"`
	Phone       string         `json:"phone"`
	Address     string         `json:"address"`
	Diagnosis   string         `json:"diagnosis"`
	CaregiverID uint           `json:"caregiver_id"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `gorm:"index" json:"-"`
}
