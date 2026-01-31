package models

import (
	"time"

	"gorm.io/gorm"
)

type Job struct {
	ID           uint           `gorm:"primaryKey" json:"id"`
	Title        string         `json:"title"`
	Company      string         `json:"company"`
	Location     string         `json:"location"`
	Type         string         `json:"type"` // full-time, part-time, contract
	Description  string         `json:"description"`
	Requirements string         `json:"requirements"`
	Salary       string         `json:"salary"`
	PostedBy     uint           `json:"posted_by"`
	Status       string         `json:"status" gorm:"default:'active'"` // active, closed
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
}
