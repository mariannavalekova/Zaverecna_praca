<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once '../vendor/autoload.php';
require_once '../config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

function AdminLogin() {
    $db = db_connect();
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    if (!isset($data['email'], $data['password'])) {
        http_response_code(400);
        echo json_encode(['message' => 'Invalid input']);
        return;
    }

    $email = $data['email'];
    $password = $data['password'];

    try {
        $stmt = $db->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            http_response_code(401);
            echo json_encode(['message' => 'The entered email or password is incorrect']);
            return;
        }

        if (!password_verify($password, $user['password'])) {
            http_response_code(401);
            echo json_encode(['message' => 'The entered email or password is incorrect']);
            return;
        }

        if ($user['role'] !== 'admin') {
            http_response_code(403); 
            echo json_encode(['message' => 'Access denied: you are not an admin']);
            return;
        }

        $secretKey = 'GMBD1cqoXMbcvaJFYi0uFImhrG6YsWTalAh7alQ0iQSi3K2blZPjaYEMBd6g1EzO'; 
        $issuedAt = time();
        $expirationTime = $issuedAt + 3600; 

        $payload = [
            'iat'  => $issuedAt,
            'exp'  => $expirationTime,
            'iss'  => 'your_domain.com', 
            'data' => [
                'user_id'  => $user['user_id'],
                'email'    => $user['email'],
                'username' => $user['username'],
                'role'     => $user['role']
            ]
        ];

        $jwt = JWT::encode($payload, $secretKey, 'HS256');
        $user_is_teacher = $user['is_teacher'] ? true : false;

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
        db_close($db);
    }
}

AdminLogin();
?>
