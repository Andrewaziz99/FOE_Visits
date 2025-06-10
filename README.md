# Daily Visits Management Application

Welcome to the **Daily Visits Management Application**! This application is designed to help organizations manage and track daily visits efficiently. It provides features for recording visitor details, scheduling visits, and generating reports.

---

## Features

- **Visitor Management**:
    - Add, update, and delete visitor information.
    - Track visitor details such as name, phone number, department, and purpose of visit.

- **Visit Scheduling**:
    - Schedule visits with specific dates, times, and destinations.
    - View and manage upcoming visits in a calendar view.


- **User Authentication**:
    - Secure login and registration system for authorized users.
    - Role-based access control (e.g., admin, staff).

- **Search and Filter**:
    - Search for visitors by name, phone number, or department.
    - Filter visits by date, status, or destination.



### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Andrewaziz99/FOE_Visits.git
   cd FOE_Visits
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Create .env File**:
    - Create a `.env` file in the root directory.
    - Add the following environment variables:
        ```env
        SUPABASE_URL=your_supabase_url
        SUPABASE_KEY=your_supabase_key
        ```
    - Replace `SUPABASE_URL`, `SUPABASE_KEY`, with your Supabase project details.

4. **Configure Supabase**:
    - Create a Supabase project at [Supabase](https://supabase.com/).

5. **Run the Application**:
   ```bash
   flutter run
   ```
6. **Build the Application**:
   ```bash
   flutter build windows
   ```

---

## Usage

1. **Login**:
    - Use your credentials to log in. If you don't have an account, register as a new user.

2. **Add a Visitor**:
    - Navigate to the "Visitors" section and click "Add Visitor."
    - Fill in the visitor details and save.

3. **Schedule a Visit**:
    - Go to the "Calendar" section and select a date.
    - Add visit details such as visitor, destination, and purpose.

4. **Generate Reports**:
    - Visit the "Reports" section and select the desired time range.
    - Export the report in your preferred format.

---

## Technologies Used

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (Authentication and database)
- **State Management**: Flutter Bloc
- **Database**: Supabase Realtime Database
- **UI Components**: Flutter Material Design

---

## Contributing

We welcome contributions! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeatureName`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeatureName`).
5. Open a pull request.

---
## Contact

For any questions or feedback, please contact:

- **Name**: Andrew Aziz
- **Email**: andrewaziz097@hmail.com
- **GitHub**: [Andrewaziz99](https://github.com/Andrewaziz99)

---

Thank you for using the **Daily Visits Management Application**! We hope it simplifies your visit management process. 🚀
