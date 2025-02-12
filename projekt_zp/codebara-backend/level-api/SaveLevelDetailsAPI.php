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

    $level_id   = intval($data['level_id']);
    $title      = trim($data['title']);
    $description= trim($data['description']);
    $obstacles  = isset($data['obstacles']) ? $data['obstacles'] : [];

    $conn = connect_to_database();
    try {
        // 1. Update the level's title & description
        $stmt = $conn->prepare("
            UPDATE levels
            SET title = :title, description = :description
            WHERE level_id = :level_id
        ");
        $stmt->execute([
            'title'       => $title,
            'description' => $description,
            'level_id'    => $level_id
        ]);

        // 2. Clear existing obstacles for this level
        $stmtDel = $conn->prepare("DELETE FROM obstacles WHERE level_id = :level_id");
        $stmtDel->execute(['level_id' => $level_id]);

        // 3. Insert new obstacles
        $stmtObs = $conn->prepare("
            INSERT INTO obstacles (level_id, image_path, type, position_x, position_y)
            VALUES (:level_id, :image_path, :type, :position_x, :position_y)
        ");
        foreach ($obstacles as $obs) {
            // Convert the full URL to a relative path
            //  e.g. from "http://localhost:5173/src/assets/rock.jpg"
            //  to   "src/assets/rock.jpg"
            $parsedPath   = parse_url($obs['image_path'], PHP_URL_PATH);  // yields "/src/assets/rock.jpg"
           

            $stmtObs->execute([
                'level_id'   => $level_id,
                'image_path' => trim($parsedPath),
                'type'       => trim($obs['type']),
                'position_x' => intval($obs['position_x']),
                'position_y' => intval($obs['position_y']),
            ]);
        }

        echo json_encode(['success' => true, 'message' => 'Level and obstacles updated successfully.']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

save_level_details_api();
