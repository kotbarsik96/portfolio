-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: portfolio
-- ------------------------------------------------------
-- Server version	8.0.35-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_attempts`
--

DROP TABLE IF EXISTS `auth_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_attempts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_attempts_user_id_foreign` (`user_id`),
  CONSTRAINT `auth_attempts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_attempts`
--

/*!40000 ALTER TABLE `auth_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_attempts` ENABLE KEYS */;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size_kb` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `width` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `height` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `images_user_id_foreign` (`user_id`),
  CONSTRAINT `images_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES (91,NULL,'/images/850bf958_desktop.png','850bf958_desktop.png','png','40','1650','930','2023-12-06 07:58:32','2023-12-06 07:58:32'),(92,NULL,'/images/c62012fb_mobile.png','c62012fb_mobile.png','png','24','390','774','2023-12-06 07:59:13','2023-12-06 07:59:13'),(96,NULL,'/images/7b73d21e_desktop.png','7b73d21e_desktop.png','png','39','1653','930','2024-01-02 07:51:28','2024-01-02 07:51:28'),(97,NULL,'/images/51829a28_mobile.png','51829a28_mobile.png','png','17','390','774','2024-01-02 07:51:30','2024-01-02 07:51:30'),(98,NULL,'/images/ae92029c_desktop.png','ae92029c_desktop.png','png','335','1653','930','2024-01-02 07:53:03','2024-01-02 07:53:03'),(99,NULL,'/images/995197eb_mobile.png','995197eb_mobile.png','png','83','390','774','2024-01-02 07:53:04','2024-01-02 07:53:04'),(100,NULL,'/images/c0dd01cf_desktop.png','c0dd01cf_desktop.png','png','74','1653','930','2024-01-02 07:56:26','2024-01-02 07:56:26'),(101,NULL,'/images/d22cd52b_mobile.png','d22cd52b_mobile.png','png','27','390','774','2024-01-02 07:56:27','2024-01-02 07:56:27'),(102,NULL,'/images/78fe65fd_desktop.png','78fe65fd_desktop.png','png','157','1653','930','2024-01-02 07:57:48','2024-01-02 07:57:48'),(103,NULL,'/images/ff28cd56_mobile.png','ff28cd56_mobile.png','png','38','390','774','2024-01-02 07:57:49','2024-01-02 07:57:49'),(104,NULL,'/images/5d971236_desktop.png','5d971236_desktop.png','png','55','1653','930','2024-01-02 07:58:23','2024-01-02 07:58:23'),(105,NULL,'/images/68836b78_mobile.png','68836b78_mobile.png','png','39','390','774','2024-01-02 07:58:24','2024-01-02 07:58:24'),(106,NULL,'/images/0cd79f61_desktop.png','0cd79f61_desktop.png','png','153','1653','930','2024-01-02 07:59:00','2024-01-02 07:59:00'),(107,NULL,'/images/308401f9_mobile.png','308401f9_mobile.png','png','26','390','774','2024-01-02 07:59:01','2024-01-02 07:59:01'),(108,NULL,'/images/a3a14ab2_desktop.png','a3a14ab2_desktop.png','png','223','1653','930','2024-01-02 08:00:03','2024-01-02 08:00:03'),(109,NULL,'/images/d6620d4f_mobile.png','d6620d4f_mobile.png','png','50','390','774','2024-01-02 08:00:04','2024-01-02 08:00:04'),(110,NULL,'/images/02f8debb_desktop.png','02f8debb_desktop.png','png','76','1653','930','2024-01-02 08:01:07','2024-01-02 08:01:07'),(111,NULL,'/images/fba888fc_mobile.png','fba888fc_mobile.png','png','38','390','774','2024-01-02 08:01:08','2024-01-02 08:01:08'),(112,NULL,'/images/9369dc7a_desktop.png','9369dc7a_desktop.png','png','279','1653','930','2024-01-02 08:03:50','2024-01-02 08:03:50'),(113,NULL,'/images/a1bd2edb_mobile.png','a1bd2edb_mobile.png','png','53','390','774','2024-01-02 08:03:52','2024-01-02 08:03:52'),(114,NULL,'/images/969d881f_desktop.png','969d881f_desktop.png','png','68','1653','930','2024-01-02 08:05:04','2024-01-02 08:05:04'),(115,NULL,'/images/1bc62f3f_mobile.png','1bc62f3f_mobile.png','png','33','390','774','2024-01-02 08:05:05','2024-01-02 08:05:05'),(116,NULL,'/images/f5732051_mobile.png','f5732051_mobile.png','png','31','390','774','2024-01-02 08:05:51','2024-01-02 08:05:51'),(117,NULL,'/images/9e05013d_desktop.png','9e05013d_desktop.png','png','179','1653','930','2024-01-02 08:07:13','2024-01-02 08:07:13'),(118,NULL,'/images/5b48316c_desktop.png','5b48316c_desktop.png','png','36','1653','930','2024-01-02 08:07:22','2024-01-02 08:07:22'),(119,NULL,'/images/4fff55ea_mobile.png','4fff55ea_mobile.png','png','25','390','774','2024-01-02 08:07:23','2024-01-02 08:07:23');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2014_10_12_100000_create_password_reset_tokens_table',1),(2,'2019_08_19_000000_create_failed_jobs_table',1),(3,'2019_12_14_000001_create_personal_access_tokens_table',1),(4,'2023_11_25_01_create_users_table',1),(5,'2023_11_25_02_create_images_table',1),(6,'2023_11_25_02_create_video_table',1),(7,'2023_11_25_03_create_works_table',1),(8,'2023_11_25_04_create_skills_table',1),(9,'2023_11_25_05_create_taxonomy_types_table',1),(10,'2023_11_25_06_create_taxonomies_table',1),(13,'2023_11_25_09_create_auth_attempts_table',1),(15,'2023_11_25_07_create_works_skills_table',2),(16,'2023_11_25_08_create_works_taxonomies_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;

--
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `skills` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_id` bigint unsigned DEFAULT NULL,
  `video_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `skills_image_id_foreign` (`image_id`),
  KEY `skills_video_id_foreign` (`video_id`),
  CONSTRAINT `skills_image_id_foreign` FOREIGN KEY (`image_id`) REFERENCES `images` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `skills_video_id_foreign` FOREIGN KEY (`video_id`) REFERENCES `video` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (3,1,'Всплывающие уведомления',NULL,24,'2023-12-04 05:52:50','2023-12-04 05:52:50'),(4,1,'Анимации при прокрутке',NULL,25,'2023-12-04 06:06:35','2024-01-05 06:25:13'),(16,1,'Модальное окно',NULL,45,'2023-12-04 06:34:32','2023-12-04 06:34:32'),(21,1,'Регистрация и авторизация',NULL,55,'2023-12-06 08:17:00','2023-12-06 08:17:36'),(23,1,'Ползунки',NULL,59,'2024-01-02 07:50:50','2024-01-02 07:50:50'),(24,1,'Слайдеры',NULL,60,'2024-01-02 07:50:58','2024-01-02 07:50:58'),(25,1,'Спойлеры',NULL,61,'2024-01-02 07:51:05','2024-01-02 07:51:05'),(26,1,'Табы',NULL,62,'2024-01-02 07:51:12','2024-01-02 07:51:12');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;

--
-- Table structure for table `taxonomies`
--

DROP TABLE IF EXISTS `taxonomies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxonomies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taxonomies_type_foreign` (`type`),
  CONSTRAINT `taxonomies_type_foreign` FOREIGN KEY (`type`) REFERENCES `taxonomy_types` (`type`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxonomies`
--

/*!40000 ALTER TABLE `taxonomies` DISABLE KEYS */;
INSERT INTO `taxonomies` VALUES (1,'stack','HTML','2023-11-28 14:01:13','2023-11-28 14:01:13'),(2,'stack','CSS','2023-11-28 14:01:52','2023-12-01 05:35:07'),(18,'stack','JavaScript','2023-12-01 05:16:55','2023-12-01 05:27:29'),(19,'stack','PHP','2023-12-01 05:30:27','2023-12-01 05:30:27'),(20,'stack','Vue JS 3','2023-12-01 05:32:38','2023-12-01 13:56:09'),(21,'stack','Laravel','2023-12-01 05:32:44','2023-12-01 05:32:44'),(22,'stack','MySQL','2023-12-01 05:32:53','2023-12-01 05:32:53'),(26,'tag','Лендинг','2023-12-01 05:44:19','2023-12-01 05:44:19'),(27,'tag','Интернет-магазин','2023-12-01 05:44:21','2023-12-01 05:44:21'),(28,'tag','Блог/Интернет-магазин','2023-12-01 05:44:25','2023-12-01 05:44:25'),(29,'type','Верстка по макету','2023-12-01 06:13:55','2023-12-01 06:13:55'),(30,'type','Интеграция с backend','2023-12-01 06:13:59','2023-12-01 06:13:59'),(33,'stack','Gulp','2023-12-01 13:43:46','2023-12-01 13:43:46'),(36,'stack','Vite','2023-12-01 13:44:46','2023-12-01 13:44:46'),(40,'stack','Git','2023-12-01 13:53:08','2023-12-01 13:53:08');
/*!40000 ALTER TABLE `taxonomies` ENABLE KEYS */;

--
-- Table structure for table `taxonomy_types`
--

DROP TABLE IF EXISTS `taxonomy_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxonomy_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taxonomy_types_type_index` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxonomy_types`
--

/*!40000 ALTER TABLE `taxonomy_types` DISABLE KEYS */;
INSERT INTO `taxonomy_types` VALUES (1,'stack','Стек','2023-11-27 16:28:25','2023-11-27 16:28:25'),(2,'type','Тип','2023-11-27 16:28:25','2023-11-27 16:28:25'),(3,'tag','Тег','2023-11-27 16:28:26','2023-11-27 16:28:26');
/*!40000 ALTER TABLE `taxonomy_types` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `google2fa_secret` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'illusiveman_test','kotbarsik96@gmail.com','$2y$12$VZIbNbiaVYz9rjlfMAGkhOsOTZ2No4YLQe2olC6Yvh80k.27sR/9m','J3PEIJAPA74K6TFZ','YbgaX2g3bsi9eKYS4AcH0T8Eb4oPpzkN6qIV7nJtlEzeujYLmDr2HZj4A4Ma','2023-11-27 16:28:40','2023-11-27 16:28:40');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Table structure for table `video`
--

DROP TABLE IF EXISTS `video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size_kb` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `width` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `height` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_seconds` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `video_user_id_foreign` (`user_id`),
  CONSTRAINT `video_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video`
--

/*!40000 ALTER TABLE `video` DISABLE KEYS */;
INSERT INTO `video` VALUES (17,NULL,'/video/71f80f40_animacii-pri-prokrutke.mp4','71f80f40_animacii-pri-prokrutke.mp4','анимации при прокрутке.mp4','mp4','2313','1920','1080',16,'2023-12-03 11:54:46','2023-12-03 11:54:46'),(22,NULL,'/video/5853efb3_animacii-pri-prokrutke.mp4','5853efb3_animacii-pri-prokrutke.mp4','анимации при прокрутке.mp4','mp4','2313','1920','1080',16,'2023-12-03 13:27:35','2023-12-03 13:27:35'),(23,NULL,'/video/354b3416_vsplyvausie-uvedomlenia.mp4','354b3416_vsplyvausie-uvedomlenia.mp4','всплывающие уведомления.mp4','mp4','1211','1920','1080',30,'2023-12-03 13:28:12','2023-12-03 13:28:12'),(24,NULL,'/video/93e2ebb3_vsplyvausie-uvedomlenia.mp4','93e2ebb3_vsplyvausie-uvedomlenia.mp4','всплывающие уведомления.mp4','mp4','1211','1920','1080',30,'2023-12-04 05:52:40','2023-12-04 05:52:40'),(25,NULL,'/video/d8424dea_animacii-pri-prokrutke.mp4','d8424dea_animacii-pri-prokrutke.mp4','анимации при прокрутке.mp4','mp4','2313','1920','1080',16,'2023-12-04 06:04:11','2023-12-04 06:04:11'),(45,NULL,'/video/50bec213_modalʹnoe-okno.mp4','50bec213_modalʹnoe-okno.mp4','модальное окно.mp4','mp4','703','1920','1080',12,'2023-12-04 06:34:28','2023-12-04 06:34:28'),(55,NULL,'/video/7e591e92_registracia-i-avtorizacia.mp4','7e591e92_registracia-i-avtorizacia.mp4','регистрация и авторизация.mp4','mp4','2200','1920','1080',62,'2023-12-06 08:17:14','2023-12-06 08:17:14'),(58,NULL,'/video/6551fcdd_modalʹnoe-okno.mp4','6551fcdd_modalʹnoe-okno.mp4','модальное окно.mp4','mp4','703','1920','1080',12,'2023-12-30 10:33:25','2023-12-30 10:33:25'),(59,NULL,'/video/8a3808e4_polzunki.mp4','8a3808e4_polzunki.mp4','ползунки.mp4','mp4','311','1920','1080',25,'2024-01-02 07:50:45','2024-01-02 07:50:45'),(60,NULL,'/video/64b39e10_slajdery.mp4','64b39e10_slajdery.mp4','слайдеры.mp4','mp4','1658','1920','1080',20,'2024-01-02 07:50:56','2024-01-02 07:50:56'),(61,NULL,'/video/049c9f9d_spojlery.mp4','049c9f9d_spojlery.mp4','спойлеры.mp4','mp4','1124','1920','1080',12,'2024-01-02 07:51:02','2024-01-02 07:51:02'),(62,NULL,'/video/d6225f7d_taby.mp4','d6225f7d_taby.mp4','табы.mp4','mp4','314','1920','1080',12,'2024-01-02 07:51:09','2024-01-02 07:51:09');
/*!40000 ALTER TABLE `video` ENABLE KEYS */;

--
-- Table structure for table `works`
--

DROP TABLE IF EXISTS `works`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_desktop_id` bigint unsigned DEFAULT NULL,
  `image_mobile_id` bigint unsigned DEFAULT NULL,
  `pages_count` smallint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `works_image_desktop_id_foreign` (`image_desktop_id`),
  KEY `works_image_mobile_id_foreign` (`image_mobile_id`),
  KEY `works_user_id_foreign` (`user_id`),
  CONSTRAINT `works_image_desktop_id_foreign` FOREIGN KEY (`image_desktop_id`) REFERENCES `images` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `works_image_mobile_id_foreign` FOREIGN KEY (`image_mobile_id`) REFERENCES `images` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `works_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works`
--

/*!40000 ALTER TABLE `works` DISABLE KEYS */;
INSERT INTO `works` VALUES (23,'Audiofree','https://audiofree.kotbarsik96.ru',91,92,8,1,'2023-12-06 07:58:34','2023-12-06 07:59:16'),(24,'Device','https://kotbarsik96.github.io/landings/device/dist/main/',96,97,2,1,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(25,'Клуб Садоводов','https://flcl.kotbarsik96.ru/',98,99,10,1,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(26,'Freshnesecom','https://kotbarsik96.github.io/freshnesecom/#/',100,101,8,1,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(27,'GamerShop','https://kotbarsik96.github.io/landings/gamershop/dist/',102,103,1,1,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(28,'Molecule','https://kotbarsik96.github.io/landings/molecule/dist/',104,105,1,1,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(29,'Resource','https://kotbarsik96.github.io/landings/resource/dist/',106,107,1,1,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(30,'Streetster','https://kotbarsik96.github.io/streetster/#/',108,109,7,1,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(31,'Takeaway&Delivery','https://kotbarsik96.github.io/landings/T&D/dist/',110,111,1,1,'2024-01-02 08:03:42','2024-01-02 08:03:42'),(32,'Trevland','https://kotbarsik96.github.io/landings/trevland/dist/',112,113,1,1,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(33,'Vantage','https://kotbarsik96.github.io/landings/vantage/dist/',114,115,1,1,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(34,'Webovio','https://kotbarsik96.github.io/landings/webovio/dist/',117,116,1,1,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(35,'Yebo','https://kotbarsik96.github.io/landings/yebo/dist/',118,119,1,1,'2024-01-02 08:07:51','2024-01-02 08:07:51');
/*!40000 ALTER TABLE `works` ENABLE KEYS */;

--
-- Table structure for table `works_skills`
--

DROP TABLE IF EXISTS `works_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works_skills` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `work_id` bigint unsigned NOT NULL,
  `skill_id` bigint unsigned NOT NULL,
  `comment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `works_skills_work_id_foreign` (`work_id`),
  KEY `works_skills_skill_id_foreign` (`skill_id`),
  CONSTRAINT `works_skills_skill_id_foreign` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `works_skills_work_id_foreign` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works_skills`
--

/*!40000 ALTER TABLE `works_skills` DISABLE KEYS */;
INSERT INTO `works_skills` VALUES (45,23,3,'при взаимодействии с товаром','https://audiofree.kotbarsik96.ru/catalog','2024-01-01 10:55:40','2024-01-01 10:55:40'),(46,23,16,'при добавлении в корзину. избранное','https://audiofree.kotbarsik96.ru/catalog','2024-01-01 10:55:40','2024-01-01 10:55:40'),(47,23,21,'test: при добавлении в корзину. избранное',NULL,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(49,24,23,NULL,NULL,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(50,24,26,'(на главной странице: \"доставка, гарантия, кредит\")',NULL,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(51,25,3,'при взаимодействии с товаром',NULL,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(52,25,16,'при регистрации и авторизации',NULL,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(53,25,21,NULL,NULL,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(54,25,23,NULL,NULL,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(55,25,24,NULL,NULL,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(56,25,25,'на странице товара','https://flcl.kotbarsik96.ru/product/363','2024-01-02 07:55:01','2024-01-02 07:55:01'),(57,25,26,'на странице товара','https://flcl.kotbarsik96.ru/product/363','2024-01-02 07:55:01','2024-01-02 07:55:01'),(58,26,16,'при открытии корзины',NULL,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(59,26,23,NULL,NULL,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(60,26,25,NULL,NULL,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(61,26,26,NULL,NULL,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(62,27,4,NULL,NULL,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(63,27,24,NULL,NULL,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(64,28,4,NULL,NULL,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(65,29,4,NULL,NULL,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(66,30,24,'https://kotbarsik96.github.io/streetster/#/bike/streetster-bakerstreet',NULL,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(67,32,24,NULL,NULL,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(68,33,4,NULL,NULL,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(69,34,4,NULL,NULL,'2024-01-02 08:07:14','2024-01-02 08:07:14');
/*!40000 ALTER TABLE `works_skills` ENABLE KEYS */;

--
-- Table structure for table `works_taxonomies`
--

DROP TABLE IF EXISTS `works_taxonomies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `works_taxonomies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `work_id` bigint unsigned NOT NULL,
  `taxonomy_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `works_taxonomies_work_id_foreign` (`work_id`),
  KEY `works_taxonomies_taxonomy_id_foreign` (`taxonomy_id`),
  CONSTRAINT `works_taxonomies_taxonomy_id_foreign` FOREIGN KEY (`taxonomy_id`) REFERENCES `taxonomies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `works_taxonomies_work_id_foreign` FOREIGN KEY (`work_id`) REFERENCES `works` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `works_taxonomies`
--

/*!40000 ALTER TABLE `works_taxonomies` DISABLE KEYS */;
INSERT INTO `works_taxonomies` VALUES (242,23,29,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(243,23,30,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(244,23,1,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(245,23,2,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(246,23,18,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(247,23,19,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(248,23,20,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(249,23,21,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(250,23,22,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(251,23,36,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(252,23,40,'2024-01-01 10:55:39','2024-01-01 10:55:39'),(254,23,29,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(255,23,30,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(256,23,1,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(257,23,2,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(258,23,18,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(259,23,19,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(260,23,20,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(261,23,21,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(262,23,22,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(263,23,36,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(264,23,40,'2024-01-01 12:01:33','2024-01-01 12:01:33'),(265,23,27,'2024-01-01 12:01:34','2024-01-01 12:01:34'),(266,24,29,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(267,24,1,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(268,24,2,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(269,24,18,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(270,24,33,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(271,24,40,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(272,24,26,'2024-01-02 07:52:53','2024-01-02 07:52:53'),(273,25,29,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(274,25,30,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(275,25,1,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(276,25,2,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(277,25,18,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(278,25,19,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(279,25,22,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(280,25,33,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(281,25,40,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(282,25,28,'2024-01-02 07:55:01','2024-01-02 07:55:01'),(283,26,29,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(284,26,1,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(285,26,2,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(286,26,18,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(287,26,20,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(288,26,36,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(289,26,40,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(290,26,28,'2024-01-02 07:57:40','2024-01-02 07:57:40'),(291,27,29,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(292,27,1,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(293,27,2,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(294,27,18,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(295,27,33,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(296,27,40,'2024-01-02 07:58:16','2024-01-02 07:58:16'),(297,28,29,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(298,28,1,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(299,28,2,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(300,28,18,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(301,28,33,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(302,28,40,'2024-01-02 07:58:53','2024-01-02 07:58:53'),(303,29,29,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(304,29,1,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(305,29,2,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(306,29,18,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(307,29,33,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(308,29,40,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(309,29,26,'2024-01-02 07:59:54','2024-01-02 07:59:54'),(310,30,29,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(311,30,1,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(312,30,2,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(313,30,18,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(314,30,20,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(315,30,36,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(316,30,40,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(317,30,28,'2024-01-02 08:01:00','2024-01-02 08:01:00'),(318,31,29,'2024-01-02 08:03:42','2024-01-02 08:03:42'),(319,31,1,'2024-01-02 08:03:42','2024-01-02 08:03:42'),(320,31,2,'2024-01-02 08:03:42','2024-01-02 08:03:42'),(323,31,40,'2024-01-02 08:03:42','2024-01-02 08:03:42'),(325,32,29,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(326,32,1,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(327,32,2,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(328,32,18,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(329,32,33,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(330,32,40,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(331,32,26,'2024-01-02 08:04:23','2024-01-02 08:04:23'),(332,31,29,'2024-01-02 08:04:50','2024-01-02 08:04:50'),(333,31,1,'2024-01-02 08:04:50','2024-01-02 08:04:50'),(334,31,2,'2024-01-02 08:04:50','2024-01-02 08:04:50'),(335,31,40,'2024-01-02 08:04:50','2024-01-02 08:04:50'),(336,31,26,'2024-01-02 08:04:50','2024-01-02 08:04:50'),(337,33,29,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(338,33,1,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(339,33,2,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(340,33,18,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(341,33,33,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(342,33,40,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(343,33,26,'2024-01-02 08:05:26','2024-01-02 08:05:26'),(344,34,29,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(345,34,1,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(346,34,2,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(347,34,18,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(348,34,33,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(349,34,40,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(350,34,26,'2024-01-02 08:07:14','2024-01-02 08:07:14'),(351,35,29,'2024-01-02 08:07:51','2024-01-02 08:07:51'),(352,35,1,'2024-01-02 08:07:51','2024-01-02 08:07:51'),(353,35,2,'2024-01-02 08:07:51','2024-01-02 08:07:51'),(354,35,33,'2024-01-02 08:07:51','2024-01-02 08:07:51'),(355,35,40,'2024-01-02 08:07:51','2024-01-02 08:07:51'),(356,35,26,'2024-01-02 08:07:51','2024-01-02 08:07:51');
/*!40000 ALTER TABLE `works_taxonomies` ENABLE KEYS */;

--
-- Dumping routines for database 'portfolio'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-05 10:56:47
