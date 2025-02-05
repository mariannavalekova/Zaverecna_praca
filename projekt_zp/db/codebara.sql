-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hostiteľ: 127.0.0.1:3307
-- Čas generovania: St 05.Feb 2025, 14:12
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
-- Štruktúra tabuľky pre tabuľku `chapters`
--

CREATE TABLE `chapters` (
  `chapter_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'upqLf8bKX1', 5);

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

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `levels`
--

CREATE TABLE `levels` (
  `level_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL,
  `description` mediumtext NOT NULL,
  `aswer_string` varchar(255) NOT NULL,
  `chapter_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(6, 'student', '$2y$10$88hDtrJc2iNhlXU6OTBqe.2wHSd9ia5DSrcHD9zmmqwgHA2ZS/jvm', 'student@gmail.com', 'user', NULL, NULL, NULL, 0),
(7, 'admin', '$2y$10$Ij/MozfUxJNcUGVe2de0YumgDIhH.kiGpSzwhQIcKPYGPNRiQiS6a', 'admin@gmail.com', 'admin', NULL, NULL, NULL, 0);

--
-- Kľúče pre exportované tabuľky
--

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
  ADD KEY `fk_users_has_levels_levels1_idx` (`level_id`),
  ADD KEY `fk_users_has_levels_users1_idx` (`user_id`);

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
  ADD KEY `fk_obstacles_levels_idx` (`level_id`);

--
-- Indexy pre tabuľku `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT pre exportované tabuľky
--

--
-- AUTO_INCREMENT pre tabuľku `chapters`
--
ALTER TABLE `chapters`
  MODIFY `chapter_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `class`
--
ALTER TABLE `class`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pre tabuľku `levels`
--
ALTER TABLE `levels`
  MODIFY `level_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  MODIFY `obstacle_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pre tabuľku `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Obmedzenie pre exportované tabuľky
--

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
  ADD CONSTRAINT `fk_users_has_levels_levels1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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
  ADD CONSTRAINT `fk_obstacles_levels` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
