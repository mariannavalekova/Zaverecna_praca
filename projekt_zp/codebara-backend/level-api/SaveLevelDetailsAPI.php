<?php
require_once '../config.php';

function save_level_details_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['level_id'], $data['title'], $data['description'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing required fields: level_id, title, description.']);
        exit;
    }

    $level_id        = intval($data['level_id']);
    $title           = trim($data['title']);
    $description     = trim($data['description']);
    $tangerine_count = isset($data['tangerine_count']) ? intval($data['tangerine_count']) : 0;
    $level_hint      = isset($data['level_hint']) ? trim($data['level_hint']) : "";

    $obstacles = isset($data['obstacles']) ? $data['obstacles'] : [];

    $conn = db_connect();
    try {
        $stmt = $conn->prepare("
            UPDATE levels
            SET title = :title,
                description = :description,
                tangerine_count = :tangerine_count,
                level_hint = :level_hint
            WHERE level_id = :level_id
        ");
        $stmt->execute([
            'title'           => $title,
            'description'     => $description,
            'tangerine_count' => $tangerine_count,
            'level_hint'      => $level_hint,
            'level_id'        => $level_id
        ]);

        $stmtDel = $conn->prepare("DELETE FROM obstacles WHERE level_id = :level_id");
        $stmtDel->execute(['level_id' => $level_id]);

        $stmtObs = $conn->prepare("
            INSERT INTO obstacles (level_id, image_path, type, position_x, position_y)
            VALUES (:level_id, :image_path, :type, :position_x, :position_y)
        ");
        foreach ($obstacles as $obs) {
            $parsedPath = parse_url($obs['image_path'], PHP_URL_PATH);
            $stmtObs->execute([
                'level_id'   => $level_id,
                'image_path' => trim($parsedPath),
                'type'       => trim($obs['type']),
                'position_x' => intval($obs['position_x']),
                'position_y' => intval($obs['position_y']),
            ]);
        }

        echo json_encode(['success' => true, 'message' => 'Level updated successfully.']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

save_level_details_api();
