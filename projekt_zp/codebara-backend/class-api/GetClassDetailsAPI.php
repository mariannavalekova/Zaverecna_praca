<?php
require_once '../config.php';

function getClassDetails() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['teacher_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing teacher_id parameter.']);
        exit;
    }

    $teacher_id = intval($_GET['teacher_id']);
    $conn = db_connect();

    try {
        // Retrieve all classes for the given teacher
        $stmt = $conn->prepare("SELECT * FROM class WHERE teacher_id = :teacher_id");
        $stmt->execute(['teacher_id' => $teacher_id]);
        $classes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $result = [];
        foreach ($classes as $class) {
            // Retrieve the students who have joined the class (join class_has_students with users)
            $stmt2 = $conn->prepare("
                SELECT u.user_id, u.username, u.email 
                FROM class_has_students AS chs 
                JOIN users AS u ON chs.student_id = u.user_id 
                WHERE chs.class_id = :class_id
            ");
            $stmt2->execute(['class_id' => $class['class_id']]);
            $students = $stmt2->fetchAll(PDO::FETCH_ASSOC);

            $class['students'] = $students;
            $result[] = $class;
        }
        echo json_encode(['classes' => $result]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

getClassDetails();
?>
