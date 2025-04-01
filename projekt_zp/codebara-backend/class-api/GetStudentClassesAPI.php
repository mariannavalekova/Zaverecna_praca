<?php
require_once '../config.php';

function getStudentClasses() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['student_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing student_id parameter.']);
        exit;
    }

    $student_id = intval($_GET['student_id']);
    $conn = db_connect();

    try {
        $stmt = $conn->prepare("
            SELECT c.class_id, c.class_code, c.teacher_id, u.teacher_name, u.teacher_surname
            FROM class AS c
            JOIN class_has_students AS chs ON c.class_id = chs.class_id
            JOIN users AS u ON c.teacher_id = u.user_id
            WHERE chs.student_id = :student_id
        ");
        $stmt->execute(['student_id' => $student_id]);
        $classes = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $result = [];
        foreach ($classes as $class) {
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

getStudentClasses();
?>
