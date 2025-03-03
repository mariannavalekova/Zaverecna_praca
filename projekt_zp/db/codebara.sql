-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hostiteľ: 127.0.0.1
-- Čas generovania: Po 03.Mar 2025, 10:04
-- Verzia serveru: 10.4.32-MariaDB
-- Verzia PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáza: `codebara`
--

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `articles`
--

CREATE TABLE `articles` (
  `article_id` int(11) NOT NULL,
  `chapter_id` int(11) NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `articles`
--

INSERT INTO `articles` (`article_id`, `chapter_id`, `content`, `created_at`, `updated_at`) VALUES
(1, 4, '<h4><strong>What is a Variable in Python?</strong></h4><p>A variable in Python is a symbolic name that refers to a value stored in memory. Unlike some other programming languages, Python does not require explicit declaration of variable types. The type of a variable is inferred based on the assigned value.<br>&nbsp;</p><h4><strong>Declaring and Assigning Variables</strong></h4><p>In Python, a variable is created as soon as a value is assigned to it using the = operator.</p><pre><code class=\"language-python\">x = 10       # Integer variable\ny = 3.14     # Floating-point variable\nname = \"John\" # String variable\nis_active = True  # Boolean variable</code></pre><p>&nbsp;</p><h4><strong>Variable Naming Rules</strong></h4><ol><li>Variable names must start with a letter (A-Z or a-z) or an underscore _.</li><li>The rest of the name can contain letters, numbers (0-9), and underscores.</li><li>Variable names are case-sensitive (age and Age are different variables).</li><li>Reserved words (keywords) cannot be used as variable names.</li></ol><pre><code class=\"language-python\">my_variable = 5\n_userName = \"Alice\"\ncount123 = 42</code></pre><p>&nbsp;</p>', '2025-02-24 13:53:06', '2025-02-27 06:26:02'),
(2, 5, '<h2><strong>Loops</strong></h2><p>bh byj by b</p><p>&nbsp;</p><pre><code class=\"language-python\">len()</code></pre><p>fbvksjvksjvskjvbk</p><p>&nbsp;</p>', '2025-02-25 11:17:26', '2025-02-25 12:00:02');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `chapters`
--

CREATE TABLE `chapters` (
  `chapter_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `chapters`
--

INSERT INTO `chapters` (`chapter_id`, `title`) VALUES
(4, 'Variables'),
(5, 'Loops'),
(6, 'If conditions');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `class`
--

CREATE TABLE `class` (
  `class_id` int(11) NOT NULL,
  `class_code` varchar(45) NOT NULL,
  `teacher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `class`
--

INSERT INTO `class` (`class_id`, `class_code`, `teacher_id`) VALUES
(1, 'upqLf8bKX1', 5),
(2, 'vVKJtIALJs', 5),
(3, 'mwrN1oHqXf', 5);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `class_has_students`
--

CREATE TABLE `class_has_students` (
  `class_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `class_has_students`
--

INSERT INTO `class_has_students` (`class_id`, `student_id`) VALUES
(1, 6);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `completed_levels`
--

CREATE TABLE `completed_levels` (
  `user_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `completed_levels`
--

INSERT INTO `completed_levels` (`user_id`, `level_id`, `date`) VALUES
(5, 15, '2025-02-27 10:59:56'),
(6, 15, '2025-02-27 10:26:56'),
(7, 14, '2025-02-25 13:29:50'),
(7, 15, '2025-02-27 07:33:14');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `levels`
--

CREATE TABLE `levels` (
  `level_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL,
  `chapter_id` int(11) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `tangerine_count` int(11) DEFAULT NULL,
  `level_hint` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `levels`
--

INSERT INTO `levels` (`level_id`, `title`, `chapter_id`, `description`, `tangerine_count`, `level_hint`) VALUES
(14, 'Variables', 4, 'Create a variable named tangerine and increase its value after collecting a tangerine. At the end say how many tangerines you have.', 1, ''),
(15, 'Say your name', 4, 'Assign yourn name into variable called name and let Capy greet you.', 0, 'Required methods: say(), moveRight()');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `obstacles`
--

CREATE TABLE `obstacles` (
  `obstacle_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `type` varchar(45) NOT NULL,
  `position_x` int(11) NOT NULL,
  `position_y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `obstacles`
--

INSERT INTO `obstacles` (`obstacle_id`, `level_id`, `image_path`, `type`, `position_x`, `position_y`) VALUES
(94, 14, '/src/assets/level_assets/tangerine.png', 'tangerine', 253, 95),
(95, 14, '/src/assets/level_assets/finish.png', 'finish', 250, 349),
(96, 15, '/src/assets/level_assets/finish.png', 'finish', 201, 100);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `role` varchar(45) NOT NULL DEFAULT 'user',
  `school_name` varchar(500) DEFAULT NULL,
  `teacher_name` varchar(45) DEFAULT NULL,
  `teacher_surname` varchar(45) DEFAULT NULL,
  `is_teacher` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `role`, `school_name`, `teacher_name`, `teacher_surname`, `is_teacher`) VALUES
(5, 'username', '$2y$10$zegFmxC4rkPD/kGKFC7yAevTCJH12JsboX./q.vUxKl1QRj1HOhEC', 'email@gmail.com', 'user', 'UKF Nitra', 'Johny', 'Depp', 1),
(6, 'Ursula', '$2y$10$88hDtrJc2iNhlXU6OTBqe.2wHSd9ia5DSrcHD9zmmqwgHA2ZS/jvm', 'student@gmail.com', 'user', NULL, NULL, NULL, 0),
(7, 'admin', '$2y$10$Ij/MozfUxJNcUGVe2de0YumgDIhH.kiGpSzwhQIcKPYGPNRiQiS6a', 'admin@gmail.com', 'admin', NULL, NULL, NULL, 0),
(8, 'Ferko', '$2y$10$rq0jEQhtYekGYPRbpBkFV.PzAjsuXXPI0ljYIdWp3GOou/KXk9Hc2', 'student2@gmail.com', 'user', NULL, NULL, NULL, 0);

--
-- Kľúče pre exportované tabuľky
--

--
-- Indexy pre tabuľku `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`article_id`),
  ADD UNIQUE KEY `uq_chapter_id` (`chapter_id`);

--
-- Indexy pre tabuľku `chapters`
--
ALTER TABLE `chapters`
  ADD PRIMARY KEY (`chapter_id`);

--
-- Indexy pre tabuľku `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `fk_class_users1_idx` (`teacher_id`);

--
-- Indexy pre tabuľku `class_has_students`
--
ALTER TABLE `class_has_students`
  ADD PRIMARY KEY (`class_id`,`student_id`),
  ADD KEY `fk_class_has_users_users1_idx` (`student_id`),
  ADD KEY `fk_class_has_users_class1_idx` (`class_id`);

--
-- Indexy pre tabuľku `completed_levels`
--
ALTER TABLE `completed_levels`
  ADD PRIMARY KEY (`user_id`,`level_id`),
  ADD KEY `fk_users_has_levels_users1_idx` (`user_id`),
  ADD KEY `fk_users_has_levels_levels1` (`level_id`);

--
-- Indexy pre tabuľku `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`level_id`),
  ADD KEY `fk_levels_chapters1_idx` (`chapter_id`);

--
-- Indexy pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  ADD PRIMARY KEY (`obstacle_id`),
  ADD KEY `fk_obstacles_levels` (`level_id`);

--
-- Indexy pre tabuľku `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT pre exportované tabuľky
--

--
-- AUTO_INCREMENT pre tabuľku `articles`
--
ALTER TABLE `articles`
  MODIFY `article_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pre tabuľku `chapters`
--
ALTER TABLE `chapters`
  MODIFY `chapter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pre tabuľku `class`
--
ALTER TABLE `class`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pre tabuľku `levels`
--
ALTER TABLE `levels`
  MODIFY `level_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  MODIFY `obstacle_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT pre tabuľku `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Obmedzenie pre exportované tabuľky
--

--
-- Obmedzenie pre tabuľku `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`chapter_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Obmedzenie pre tabuľku `class`
--
ALTER TABLE `class`
  ADD CONSTRAINT `fk_class_users1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `class_has_students`
--
ALTER TABLE `class_has_students`
  ADD CONSTRAINT `fk_class_has_users_class1` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_class_has_users_users1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `completed_levels`
--
ALTER TABLE `completed_levels`
  ADD CONSTRAINT `fk_users_has_levels_levels1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_users_has_levels_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `levels`
--
ALTER TABLE `levels`
  ADD CONSTRAINT `fk_levels_chapters1` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`chapter_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  ADD CONSTRAINT `fk_obstacles_levels` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
