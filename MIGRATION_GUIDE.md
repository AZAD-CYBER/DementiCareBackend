# Firebase to Go Backend Migration Guide

This guide helps you migrate the remaining Firebase-dependent components to the new Go backend.

## Files Still Using Firebase (Need Migration)

The following files still import from `firebase.js`:

1. **src/Patients.js** - Patient management
2. **src/App1.js** - Job listings
3. **src/Caregiver.js** - Caregiver functionality
4. **src/Prescription.js** - Prescription management
5. **src/ScoreChart.js** - Quiz score display
6. **src/components/Quiz.js** - Quiz functionality
7. **src/components/Dashboard/Dashboard.js** - Dashboard data
8. **src/components/DoctorsZone/DoctorsZone.js** - Doctor zone
9. **src/components/MainPage/MainPage.js** - Main page data
10. **src/components/AppointmentType/AppointmentType.js** - Appointments

## Migration Pattern

### Before (Firebase):
```javascript
import { db } from './firebase';

// Fetch data
const fetchData = async () => {
  const snapshot = await db.collection('patients').get();
  const data = snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data()
  }));
  setPatients(data);
};

// Add data
const addPatient = async (patientData) => {
  await db.collection('patients').add(patientData);
};

// Update data
const updatePatient = async (id, data) => {
  await db.collection('patients').doc(id).update(data);
};

// Delete data
const deletePatient = async (id) => {
  await db.collection('patients').doc(id).delete();
};
```

### After (Go Backend API):
```javascript
import apiService from './services/api';

// Fetch data
const fetchData = async () => {
  try {
    const data = await apiService.getPatients();
    setPatients(data);
  } catch (error) {
    console.error('Error fetching patients:', error);
  }
};

// Add data
const addPatient = async (patientData) => {
  try {
    const newPatient = await apiService.createPatient(patientData);
    return newPatient;
  } catch (error) {
    console.error('Error adding patient:', error);
  }
};

// Update data
const updatePatient = async (id, data) => {
  try {
    const updated = await apiService.updatePatient(id, data);
    return updated;
  } catch (error) {
    console.error('Error updating patient:', error);
  }
};

// Delete data
const deletePatient = async (id) => {
  try {
    await apiService.deletePatient(id);
  } catch (error) {
    console.error('Error deleting patient:', error);
  }
};
```

## Available API Methods

### Authentication
```javascript
import apiService, { isAuthenticated, getAuthToken, logout } from './services/api';

// Register
await apiService.register({ email, password, user_type, name, phone });

// Login
await apiService.login(email, password);

// Change password
await apiService.changePassword(oldPassword, newPassword);

// Check if authenticated
if (isAuthenticated()) { ... }

// Logout
logout();
```

### Patients
```javascript
// Get all patients
const patients = await apiService.getPatients();

// Get single patient
const patient = await apiService.getPatient(id);

// Create patient
const newPatient = await apiService.createPatient({
  name, age, gender, phone, address, diagnosis
});

// Update patient
const updated = await apiService.updatePatient(id, { name, age, ... });

// Delete patient
await apiService.deletePatient(id);
```

### Appointments
```javascript
// Get all appointments
const appointments = await apiService.getAppointments();

// Create appointment
const appointment = await apiService.createAppointment({
  patient_id, doctor_id, date, time, type, notes
});

// Update appointment
await apiService.updateAppointment(id, { status: 'confirmed' });

// Delete appointment
await apiService.deleteAppointment(id);
```

### Prescriptions
```javascript
// Get all prescriptions (optionally filtered by patient)
const prescriptions = await apiService.getPrescriptions(patientId);

// Create prescription
const prescription = await apiService.createPrescription({
  patient_id, medication, dosage, frequency, duration, instructions
});

// Update prescription
await apiService.updatePrescription(id, { dosage: '10mg' });

// Delete prescription
await apiService.deletePrescription(id);
```

### Quiz Results
```javascript
// Get quiz results (optionally filtered by patient)
const results = await apiService.getQuizResults(patientId);

// Save quiz result
await apiService.saveQuizResult({
  patient_id, score, max_score, answers: JSON.stringify(answerArray)
});
```

### Jobs
```javascript
// Get all jobs
const jobs = await apiService.getJobs();

// Create job
const job = await apiService.createJob({
  title, company, location, type, description, requirements, salary
});

// Update job
await apiService.updateJob(id, { status: 'closed' });

// Delete job
await apiService.deleteJob(id);
```

### Doctor Recommendation (ML)
```javascript
// Get doctor recommendations
const recommendations = await apiService.recommendDoctor(location, experience);
// Returns: { data: { recommended_doctors, experience, contacts } }
```

### Contact Form
```javascript
// Submit contact form
await apiService.submitContact({ name, email, message });
```

## Error Handling

The API service throws errors that you should catch:

```javascript
try {
  const data = await apiService.getPatients();
  setPatients(data);
} catch (error) {
  // error.message contains the error message
  setError(error.message);
  console.error('API Error:', error);
}
```

## Authentication Headers

The API service automatically adds authentication headers to protected endpoints using the token stored in localStorage. Make sure users are logged in before accessing protected resources:

```javascript
import { isAuthenticated } from './services/api';

useEffect(() => {
  if (!isAuthenticated()) {
    navigate('/login');
    return;
  }
  // Fetch protected data
  fetchData();
}, []);
```

## Data Structure Changes

### User Object
```javascript
// Firebase (old)
{
  uid: "firebase-uid",
  email: "user@example.com",
  // ... custom fields
}

// Go Backend (new)
{
  id: 1,
  email: "user@example.com",
  user_type: "doctor", // doctor, caregiver, patient
  name: "Dr. Smith",
  phone: "+1234567890",
  created_at: "2024-01-01T00:00:00Z",
  updated_at: "2024-01-01T00:00:00Z"
}
```

### Timestamps
```javascript
// Firebase (old)
timestamp: firebase.firestore.Timestamp

// Go Backend (new)
created_at: "2024-01-01T00:00:00Z"  // ISO 8601 string
updated_at: "2024-01-01T00:00:00Z"
```

### IDs
```javascript
// Firebase (old)
id: "random-firestore-id"

// Go Backend (new)
id: 1  // Integer auto-increment
```

## Real-time Updates

Firebase Firestore provided real-time updates. With the REST API, you need to implement polling or WebSocket if needed:

```javascript
// Polling example
useEffect(() => {
  const fetchData = async () => {
    const data = await apiService.getPatients();
    setPatients(data);
  };
  
  fetchData();
  const interval = setInterval(fetchData, 30000); // Refresh every 30 seconds
  
  return () => clearInterval(interval);
}, []);
```

## Migration Checklist

For each component:

- [ ] Remove `import { db } from './firebase'`
- [ ] Add `import apiService from './services/api'`
- [ ] Replace `db.collection()` with `apiService` methods
- [ ] Update data structure (IDs, timestamps)
- [ ] Add try-catch error handling
- [ ] Add authentication checks if needed
- [ ] Test CRUD operations
- [ ] Update loading states
- [ ] Update error messages

## Quick Reference

| Firebase Operation | Go Backend API |
|-------------------|----------------|
| `db.collection('patients').get()` | `apiService.getPatients()` |
| `db.collection('patients').doc(id).get()` | `apiService.getPatient(id)` |
| `db.collection('patients').add(data)` | `apiService.createPatient(data)` |
| `db.collection('patients').doc(id).update(data)` | `apiService.updatePatient(id, data)` |
| `db.collection('patients').doc(id).delete()` | `apiService.deletePatient(id)` |
| `db.collection('patients').where(...)` | Add query params to API |
| `firebase.auth().currentUser` | `isAuthenticated()` / `getAuthToken()` |
| `firebase.auth().signOut()` | `logout()` |

## Need Help?

If you encounter issues during migration:

1. Check the Go backend logs
2. Verify the API endpoint exists in `backend/routes/routes.go`
3. Check authentication token is valid
4. Verify request/response data structure
5. Review `src/services/api.js` for available methods

## Testing After Migration

1. Login/Logout functionality
2. Create operations
3. Read/List operations
4. Update operations
5. Delete operations
6. Error handling
7. Loading states
8. Authentication redirects

## Example: Complete Component Migration

See `src/Auth/Login.js` and `src/pages/ContactUs.js` for complete examples of migrated components.
