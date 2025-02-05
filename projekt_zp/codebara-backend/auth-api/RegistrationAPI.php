<?php

require_once '../config.php';

function registration_api() {
    header('Content-Type: application/json');

    // Allow only POST requests
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    // Get JSON input and decode it
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate required fields
    if (!isset($data['username'], $data['email'], $data['password'])) {
        http_response_code(400); // Bad Request
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $username = trim($data['username']);
    $email    = trim($data['email']);
    $password = $data['password'];

    // Connect to the database using your config.php function
    $conn = connect_to_database();

    try {
        // Check if the username already exists
        $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE username = :username");
        $stmt->execute(['username' => $username]);
        if ($stmt->fetchColumn() > 0) {
            http_response_code(409); // Conflict
            echo json_encode(['error' => 'Username is already taken.']);
            exit;
        }

        // Check if the email already exists
        $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE email = :email");
        $stmt->execute(['email' => $email]);
        if ($stmt->fetchColumn() > 0) {
            http_response_code(409); // Conflict
            echo json_encode(['error' => 'Email is already registered.']);
            exit;
        }

        // Hash the password securely using password_hash() with BCRYPT
        // No truncation of the hash here
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

        // Insert the new user into the database; role is set to 'user' by default
        $stmt = $conn->prepare("
            INSERT INTO users (username, password, email, role)
            VALUES (:username, :password, :email, 'user')
        ");
        $stmt->execute([
            'username' => $username,
            'password' => $hashedPassword,
            'email'    => $email
        ]);

        http_response_code(201); // Created
        echo json_encode(['success' => 'User registered successfully.']);

    } catch (PDOException $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        exit;
    }
}

// Execute the registration function
registration_api();
