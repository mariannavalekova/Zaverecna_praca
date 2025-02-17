<?php

require_once '../config.php';

function registration_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); 
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['username'], $data['email'], $data['password'])) {
        http_response_code(400); 
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $username = trim($data['username']);
    $email    = trim($data['email']);
    $password = $data['password'];
    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE username = :username");
        $stmt->execute(['username' => $username]);
        if ($stmt->fetchColumn() > 0) {
            http_response_code(409); 
            echo json_encode(['error' => 'Username is already taken.']);
            exit;
        }

        $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE email = :email");
        $stmt->execute(['email' => $email]);
        if ($stmt->fetchColumn() > 0) {
            http_response_code(409); 
            echo json_encode(['error' => 'Email is already registered.']);
            exit;
        }

        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

        $stmt = $conn->prepare("
            INSERT INTO users (username, password, email, role)
            VALUES (:username, :password, :email, 'user')
        ");
        $stmt->execute([
            'username' => $username,
            'password' => $hashedPassword,
            'email'    => $email
        ]);

        http_response_code(201); 
        echo json_encode(['success' => 'User registered successfully.']);

    } catch (PDOException $e) {
        http_response_code(500); 
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        exit;
    }
}

registration_api();
