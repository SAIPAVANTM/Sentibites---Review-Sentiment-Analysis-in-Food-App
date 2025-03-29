<?php

header('Content-Type: application/json');

// Database credentials
$host = 'localhost';
$user = 'root';
$password = '';
$dbname = 'sentibites';

// Create connection
$conn = new mysqli($host, $user, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'] ?? '';
    $price = $_POST['price'] ?? '';
    $category = $_POST['category'] ?? '';
    $description = $_POST['description'] ?? '';

    // Check for required fields
    if (empty($name) || empty($price) || empty($category)) {
        echo json_encode(['status' => 'error', 'message' => 'Name, price, and category are required']);
        exit;
    }

    $uploadDir = 'C:/xampp/htdocs/sentibites/uploads/'; // Local path for storing images
    $baseURL = 'http://192.168.121.210/sentibites/uploads/';  // Base URL for accessing images

    // Ensure the uploads directory exists
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $imageURL = null;

    if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
        $imageName = time() . '_' . basename($_FILES['image']['name']);
        $targetFilePath = $uploadDir . $imageName;

        if (move_uploaded_file($_FILES['image']['tmp_name'], $targetFilePath)) {
            $imageURL = $baseURL . $imageName;  // Store the URL path in the database
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to upload image']);
            exit;
        }
    }

    // Insert data into the database
    $stmt = $conn->prepare("INSERT INTO owner_add_items (name, price, category, image, description) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param('sdsss', $name, $price, $category, $imageURL, $description);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Item added successfully', 'image_url' => $imageURL]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database insert failed: ' . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
