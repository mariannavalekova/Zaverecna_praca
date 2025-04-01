<?php
require_once '../config.php';

function joinClass() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['student_id'], $data['class_code'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $student_id = intval($data['student_id']);
    $class_code = trim($data['class_code']);

    $conn = db_connect();

    try {
        // Find the class by its class code
        $stmt = $conn->prepare("SELECT class_id FROM class WHERE class_code = :class_code");
        $stmt->execute(['class_code' => $class_code]);
        $class = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$class) {
            http_response_code(404);
            echo json_encode(['error' => 'Class not found.']);
            exit;
        }

        $class_id = $class['class_id'];

        // Check if the student has already joined this class
        $stmt = $conn->prepare("SELECT * FROM class_has_students WHERE class_id = :class_id AND student_id = :student_id");
        $stmt->execute(['class_id' => $class_id, 'student_id' => $student_id]);
        if ($stmt->fetch(PDO::FETCH_ASSOC)) {
            echo json_encode(['error' => 'You have already joined this class.']);
            exit;
        }

        // Insert the record into class_has_students
        $stmt = $conn->prepare("INSERT INTO class_has_students (class_id, student_id) VALUES (:class_id, :student_id)");
        $stmt->execute(['class_id' => $class_id, 'student_id' => $student_id]);

        echo json_encode(['success' => true, 'message' => 'Joined class successfully.']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

joinClass();
?>
