<?php

// Enable error reporting for debugging (disable in production)
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Include the Composer autoloader
require_once '../vendor/autoload.php';

// Include the config file for database connection
require_once '../config.php';

// Import Firebase JWT library classes
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

function AdminLogin() {
    // Initialize the database connection
    $db = connect_to_database();

    // Get the incoming JSON payload
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    // Validate the required fields
    if (!isset($data['email'], $data['password'])) {
        http_response_code(400);
        echo json_encode(['message' => 'Invalid input']);
        return;
    }

    $email = $data['email'];
    $password = $data['password'];

    try {
        // Check if the user exists by email
        $stmt = $db->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            http_response_code(401);
            echo json_encode(['message' => 'The entered email or password is incorrect']);
            return;
        }

        // Verify the password
        if (!password_verify($password, $user['password'])) {
            http_response_code(401);
            echo json_encode(['message' => 'The entered email or password is incorrect']);
            return;
        }

        // Ensure the user is an admin
        if ($user['role'] !== 'admin') {
            http_response_code(403); // Forbidden
            echo json_encode(['message' => 'Access denied: you are not an admin']);
            return;
        }

        // Generate JWT using Firebase JWT
        $secretKey = 'M07gGoLVPCMAPuFvV2PLgFBFYH3lPb0Ov22jlxxcliX3PkBYXnXfFmXm76y5twn7'; // Replace with your secret key (store securely)
        $issuedAt = time();
        $expirationTime = $issuedAt + 3600; // Token valid for 1 hour

        // Prepare the JWT payload. Note: our users table has username and role fields.
        $payload = [
            'iat'  => $issuedAt,
            'exp'  => $expirationTime,
            'iss'  => 'your_domain.com', // Replace with your domain
            'data' => [
                'user_id'  => $user['user_id'],
                'email'    => $user['email'],
                'username' => $user['username'],
                'role'     => $user['role']
            ]
        ];

        // Encode the JWT
        $jwt = JWT::encode($payload, $secretKey, 'HS256');

        // Determine if the user is a teacher based on the is_teacher field (if applicable)
        $user_is_teacher = $user['is_teacher'] ? true : false;

        // Return the JWT and user data as JSON, ensuring that user_is_admin is true
        echo json_encode([
            'access_token'    => $jwt,
            'user_id'         => $user['user_id'],
            'user_is_admin'   => true,
            'user_is_teacher' => $user_is_teacher
        ]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['message' => 'Database error: ' . $e->getMessage()]);
    } finally {
        // Close the database connection
        close_database_connection($db);
    }
}

// Call the function to handle the request
AdminLogin();
?>
