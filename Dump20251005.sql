-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: flutterfirstproject
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKpiovo1hsx7hi5f9ax85epqya9` (`user_id`),
  CONSTRAINT `FKgc8dtql9mkq268detxiox7fpm` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Khilgaon','1990-08-22','imranhss@gmail.com','MALE','Muhammad_Emran_Hossain_c01f540d-2db1-4d89-887a-343624c3af9b','Muhammad Emran Hossain','01619192323',1),(2,'Jajira','2022-10-22','abdullahjawad@gmail.com','MALE','Md_Abdullah_Jawad_22c7196f-9c8f-4749-9359-a7a9ce868734','Md Abdullah Jawad','01945025652',7);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `air_conditioning` bit(1) NOT NULL,
  `airport_suttle` bit(1) NOT NULL,
  `break_fast` bit(1) NOT NULL,
  `free_parking` bit(1) NOT NULL,
  `free_wifi` bit(1) NOT NULL,
  `gym` bit(1) NOT NULL,
  `health_services` bit(1) NOT NULL,
  `laundry_service` bit(1) NOT NULL,
  `play_ground` bit(1) NOT NULL,
  `restaurant` bit(1) NOT NULL,
  `room_service` bit(1) NOT NULL,
  `swimming_pool` bit(1) NOT NULL,
  `wheelchair_accessible` bit(1) NOT NULL,
  `hotel_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKtb8vbts0tbu3wedo4d9hb9rjm` (`hotel_id`),
  CONSTRAINT `FK23ayav9or91wbe85x0v9svxv1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES (1,_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',1),(2,_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',2),(3,_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',3),(4,_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',4),(5,_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',_binary '',5);
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `advance_amount` double NOT NULL,
  `check_in` datetime(6) DEFAULT NULL,
  `check_out` datetime(6) DEFAULT NULL,
  `contract_person_name` varchar(255) DEFAULT NULL,
  `discount_rate` double NOT NULL,
  `due_amount` double NOT NULL,
  `number_of_rooms` int NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `total_amount` double NOT NULL,
  `customer_id` bigint NOT NULL,
  `hotel_id` bigint NOT NULL,
  `room_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbvfibgflhsb0g2hnjauiv5khs` (`customer_id`),
  KEY `FK7y09f5lun38jnooaw2hch0ke9` (`hotel_id`),
  KEY `FKrgoycol97o21kpjodw1qox4nc` (`room_id`),
  CONSTRAINT `FK7y09f5lun38jnooaw2hch0ke9` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`),
  CONSTRAINT `FKbvfibgflhsb0g2hnjauiv5khs` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `FKrgoycol97o21kpjodw1qox4nc` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,5000,'2025-08-31 06:00:00.000000','2025-09-01 06:00:00.000000','Rahmatullah Shahrukh',0,13000,1,'01715246542',18000,1,1,2),(2,20000,'2025-09-01 06:00:00.000000','2025-09-03 06:00:00.000000','Atiqur Rahman',0,52000,2,'01547852465',72000,1,1,2),(3,6000,'2025-09-01 06:00:00.000000','2025-09-05 06:00:00.000000','',0,90000,2,'',96000,1,4,11),(4,5000,'2025-09-09 06:00:00.000000','2025-09-10 06:00:00.000000','Istiaque',0,20000,1,'01547856546',25000,1,1,3),(5,10000,'2025-09-09 06:00:00.000000','2025-09-11 06:00:00.000000','Atiqur Rahman',0,10000,1,'01745464650',20000,2,4,12),(6,4000,'2025-09-09 06:00:00.000000','2025-09-11 06:00:00.000000','Sadear Rahman',0,10000,1,'0157450405',14000,2,4,10),(7,6000,'2025-09-09 06:00:00.000000','2025-09-11 06:00:00.000000','Rejaul Karim',0,30000,1,'01547852210',36000,2,3,9),(8,10000,'2025-09-10 06:00:00.000000','2025-09-11 06:00:00.000000','Istiaque Ahmed',0,10000,1,'01515203269',20000,2,3,8),(9,5000,'2025-09-16 06:00:00.000000','2025-09-18 06:00:00.000000','Junayet ',0,15000,1,'0154785240',20000,2,3,7),(10,9000,'2025-09-22 06:00:00.000000','2025-09-23 06:00:00.000000','Sadiar Rahman',0,15000,2,'01754680500',24000,3,1,1),(11,16000,'2025-09-17 06:00:00.000000','2025-09-19 06:00:00.000000','Sadiar Rahman',0,20000,1,'01722652595',36000,3,3,9),(12,2000,'2025-09-18 06:00:00.000000','2025-09-19 06:00:00.000000','Rakib Islam',0,10000,1,'01547852140',12000,3,2,6),(13,10000,'2025-09-20 06:00:00.000000','2025-09-21 06:00:00.000000','Sadiar Rahman',0,20000,1,'01547654050',30000,3,2,5);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKrfbvkrffamfql7cjmen8v976v` (`email`),
  UNIQUE KEY `UKeuat1oase6eqv195jvb71a93s` (`user_id`),
  CONSTRAINT `FKrh1g1a20omjmn6kurd35o3eit` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Shamoly, Dhaka','1998-01-08','mdrahmatullahshahrukh@gmail.com','MALE','Md_Rahmatullah_Sharukh_b2e3c81d-6a18-4cd1-9a0a-c41563f9dbc6','Md Rahmatullah Sharukh','01752456540',3),(2,'MuhammadPur','2025-09-01','junayet03@gmail.com','MALE','Md_Shamim_Junayet_Istiaque_3784e510-378a-498f-ab27-cbe520445821','Md Shamim Junayet Istiaque','01245879654',6),(3,'Norail','2025-09-17','sadiar@gmail.com','MALE','Sadiar_Rahman_6629ec3d-5c63-414a-9fea-9169492b0048','Sadiar Rahman','05147521560',9),(4,'tjhdrgtdfg','2025-10-05','md.t.imran.j.dev@gmail.com','Male','Md_imran_mia_eb68d6ba-9e24-44ef-bc04-f4f3253bc4c7','Md imran mia','165465465r',10);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gallery`
--

DROP TABLE IF EXISTS `gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gallery` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `photo_url` varchar(255) DEFAULT NULL,
  `hotel_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKs3sef4k4tlqk2y9ndim0s4lh6` (`hotel_id`),
  CONSTRAINT `FKs3sef4k4tlqk2y9ndim0s4lh6` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery`
--

LOCK TABLES `gallery` WRITE;
/*!40000 ALTER TABLE `gallery` DISABLE KEYS */;
INSERT INTO `gallery` VALUES (1,'bc3b1f3e-48e5-4c7b-8bcd-216bf5414146_delux.jpg',1),(2,'dbd89bfd-8740-4a26-b5ec-6d8c5c6232af_doublebed.jpg',1),(3,'0fcb9ea4-7f9e-439d-a653-dd2e929d8786_i1.jpg',1),(4,'f174bf92-a37c-40e3-9ae8-f13b45c05761_i2.jpg',1),(5,'68fc15c1-a2d0-472c-af17-5c7fa21ac755_i3.jpg',1),(6,'0e1f3639-9099-4643-89bc-93bf4a824b81_i4.jpg',1),(7,'1dc9086d-6868-44e1-9f76-d6066cc489aa_i5.jpg',1),(8,'cad7b865-ca1a-47f4-9a17-d38c1a3985de_i6.jpg',1),(9,'98fe7914-5644-4e74-89d2-f0c427bf8363_inter.jpg',1),(10,'6a22c062-3bbc-40b8-96a1-e9972f07e9df_premium.jpg',1),(11,'e89c14e4-413e-4991-b232-b0bb3059dbf3_deluxe.jpg',2),(12,'a00c176b-1ca0-4fe7-963c-365772edb742_premium.jpg',2),(13,'566a2326-fe3d-46be-a84e-90d4202f8399_r1.jpg',2),(14,'481c78f8-6647-4f68-8138-c65f547f4544_r2.jpg',2),(15,'6d8c338d-d8bb-4458-b233-bbd17c6d6353_r3.jpg',2),(16,'841263e5-d674-41c7-ab77-2f71f172d7a5_r4.jpg',2),(17,'b5eab876-a1f7-49cc-b2a9-989eeae96d95_r5.jpg',2),(18,'6f90f7b6-7071-492b-b1ed-fa8986b3c57a_r6.jpg',2),(19,'bdb2ad76-e163-47bb-bc93-00b26366116e_r7.jpg',2),(20,'2fc91dd9-91e7-4921-b897-6ed2979d21ff_r8.jpg',2),(21,'a03cc361-f4e2-4642-946e-dcc94b810e6a_r9.jpg',2),(22,'29a9cf12-b4b4-451f-8ba8-7c3988f6c557_r10.jpg',2),(23,'5356d82a-d66a-4733-8e7e-6e35389cd426_r11.jpg',2),(24,'6b125a66-be39-4ee2-a9bd-33b34dbf987e_readison.jpg',2),(25,'8616425e-7f01-4cb1-8224-460dc0a8c4bd_Signle.jpg',2),(26,'a139e56c-58df-4098-9eca-a1aadddf11ec_SaymanDelux.jpg',3),(27,'c564bb3e-d037-44f6-8f12-0e672ba44a29_SaymanKing.jpg',3),(28,'e1838b0c-1b74-49e9-9766-9db98eff0f1b_SaymanPremium.jpg',3),(29,'d338f126-c53a-4e9d-8667-c6abfbb56a4f_SymanBeach_Resort.jpg',3),(30,'2c74f360-a297-436b-bf61-8f844fb1ba7d_i1.jpg',3),(31,'a422e8c4-a5ed-46b2-a912-a05dd46d1a2c_i4.jpg',3),(32,'d12c806c-7304-43c4-ae17-2765f2d3ac1a_i5.jpg',3),(33,'cefc8cd7-af7c-4c2a-b5c8-f1cb4e39f9ad_deluxe.jpg',4),(34,'6bb36b3b-ad76-4340-bcf1-aefb84000279_doublebed.jpg',4),(35,'603760ff-355a-4815-8e82-9a465c899366_s1.jpg',4),(36,'fabd0956-9ee9-4729-ab1d-5d13e6210ff6_s2.jpg',4),(37,'869748da-a457-477e-9130-bc8e390e0c02_s3.jpg',4),(38,'2e8b0b75-f589-49a2-a905-37d5a5bcfed8_s4.jpg',4),(39,'e894df4a-d22b-441a-966a-1fb95046723c_s5.jpg',4),(40,'9e52bdc1-8fd1-4644-9256-d46cf47c9bfe_s6.jpg',4),(41,'088ee7d7-612e-4445-ad6f-998bd00a9bf0_s7.jpg',4),(42,'62c45914-292d-4fe9-b2a7-9b62a812775d_s8.jpg',4),(43,'ae9c2a1a-fad7-481f-af8f-82ff38c1cb20_s9.jpg',4),(44,'9778c1f0-6106-423c-84d2-dbd0e25e3aa6_s10.jpg',4),(45,'c86d72a4-ad6b-40a0-9a2e-d46a99965ca5_s11.jpg',4),(46,'34a21dc7-207b-4e7f-86ee-bb35a50438a5_SampanHotel.jpg',4),(47,'04f7e170-9d2e-4155-b2aa-d692c7ffaff0_single.jpg',4),(48,'4425d72e-c590-4c14-9bd3-228387497369_Deluxe.jpg',5),(49,'be1d1066-3a0d-468b-bc69-744e30de3f1c_s.jpg',5),(50,'72b0b1ca-25ae-4f4e-83ed-7b6862f7b8b2_s1.jpg',5),(51,'ebe86fab-d17e-46af-99e5-3957ea6d97a9_s2.jpg',5),(52,'2893a28b-9900-47b5-a7af-9d2e9a87ecf5_s3.jpg',5),(53,'b2f0d90f-626a-443d-bb2b-35cb19eccf9f_s4.jpg',5),(54,'1b4a4135-6e85-4406-90b7-cde0c2f40e1c_s5.jpg',5),(55,'1fd47551-dbce-4ee4-872d-52a80043bfb4_s6.jpg',5),(56,'b61a78c4-2c6c-49b5-ae3e-8f3c218762e6_s7.jpg',5),(57,'698f65bf-95ed-4ebe-b1e2-9868d32530d3_s8.png',5),(58,'bd6212a1-cf9f-4047-b40f-5cce6ccf7adf_sarahResortDoubleDeluxe-56.jpg',5),(59,'4b5cd699-6693-43ea-8d0e-15076ec59422_sarahResortPremium.jpg',5),(60,'9e152aa6-4671-4eb6-a9db-8a23dd4211ef_SaraResort.jpg',5);
/*!40000 ALTER TABLE `gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_admin`
--

DROP TABLE IF EXISTS `hotel_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKidx11d5bvbtj7odnpg30c6nms` (`email`),
  UNIQUE KEY `UKemunrxx7vpw58hatvb083ncxi` (`user_id`),
  CONSTRAINT `FKb4nb9l1jn4s1bgdsfvd7t0kep` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_admin`
--

LOCK TABLES `hotel_admin` WRITE;
/*!40000 ALTER TABLE `hotel_admin` DISABLE KEYS */;
INSERT INTO `hotel_admin` VALUES (1,'Azimpur','1998-11-15','mdtusherimran049@gmail.com','MALE','Md_Imran_Mia_ce2eb98b-a939-4bad-a99d-654eb5b597c8','Md Imran Mia','01571407696',2),(2,'Mohammadpur, Dhaka','1999-02-28','mdrakibislam7512@gmail.com','MALE','Md_Rakib_Islam_9d61984c-6be7-46bf-9fe8-a07d8d8ff6ce','Md Rakib Islam','01675452525',4),(3,'Muladi, Gopalganj','1999-03-01','abdurrahimkhan214dc@gmail.com','MALE','Md_Rahim_Khan_5f5b6013-47a6-48e8-98e9-458bb2b332e6','Md Rahim Khan','01546875420',5),(4,'Bhola','1996-01-01','mdatiqulislam59@gmail.com','MALE','Md_Atikul_Islam_f762e972-4123-4f80-bb29-a0e7e9bc24d0','Md Atikul Islam','01710072023',8);
/*!40000 ALTER TABLE `hotel_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_info`
--

DROP TABLE IF EXISTS `hotel_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(1000) DEFAULT NULL,
  `hotel_policy` varchar(1000) DEFAULT NULL,
  `owner_info` varchar(1000) NOT NULL,
  `hotel_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK3f1y9bk7a9x2klxs5junnob6q` (`hotel_id`),
  CONSTRAINT `FKrglor4gfjlhfgifqima9qfrts` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_info`
--

LOCK TABLES `hotel_info` WRITE;
/*!40000 ALTER TABLE `hotel_info` DISABLE KEYS */;
INSERT INTO `hotel_info` VALUES (1,'Hotel descriptions are becoming a more prominent part of search engine marketing technology, however, they are more difficult to write than they might sound. To make a description of hotels writing bulletproof, unskippable, and exciting is by having a blog feature. Because hotels are not just places to stay they are also a place where people go for a vacation. This means that when describing a hotel the information should include details about what activities you can do in them and not just about the room.','\n1. Check-in time is 02:00 PM and check-out time is 12:00 PM noon. Subject to availability, early check-in and late    check-out will be considered.\n2. Extra Person charges – Rs. 350 per person.\n3. GST / Taxes charged extra and applicable as per government directives.\n4. 100 % advance Payment deposit at the time of Check in.\n5. We do not accept personal Cheques for payment.\n6. It is Mandatory for all customers and their visitor guests to share their ID cards. Foreign Nationals are required to present their passport and valid visa.\n7. Smoking, Alcohol, Gambling, Prostitution, contraband goods, drugs, etc – are all strictly prohibited within the hotel premises.\n8. Non Vegetarian and / or Pungent food is not allowed in the hotel premises.\n9. We do not allow Pets.\n10. We do not allow visitors entry to guest room.\n11. We accept advance booking only upto 1 month with full tariff advance payment.\n12. Personal food and beverages are not allowed.\n','Hospitality quotes are powerful and proven distillations of the shared experiences of hoteliers and their staff. Whether it’s a pithy description of a common challenge that everyone should expect and overcome, a brutal hard truth that every hotelier must accept.',1),(2,'Hotels are one of the most important industries in the world. They are an essential part\n of a traveler’s experience. The hotel industry is also a large, global industry with\n significant revenue and importance to the economy. The key to hotels remaining relevant\n is by having an online web presence. When one is writing about hotels it’s important to\n create an exceptional description of hotels that includes topics that are pertinent to the\n ir target audience and include accurate information about them. Also, make sure a hotel’s\n website is up-to-date. This will help land a hotel’s booking call to action goal for all\n its services and products.Most hotels rely on one page and contact form to provide most\n of the information to potential guests. The problem is that those two are not enough to\n get a complete picture of what the hotel can offer. This is why photos and videos are so\n important.','1. Check-in time is 02:00 PM and check-out time is 12:00 PM noon. Subject to availability, early check-in and late check-out will be considered.\n 2. Extra Person charges – Rs. 350 per person. \n 3. GST / Taxes charged extra and applicable as per government directives.\n 4. 100 % advance Payment deposit at the time of Check in.\n 5. We do not accept personal Cheques for payment.\n 6. It is Mandatory for all customers and their visitor guests to share their ID cards. Foreign Nationals are required to present their passport and valid visa.\n 7. Smoking, Alcohol, Gambling, Prostitution, contraband goods, drugs, etc – are all strictly prohibited within the hotel premises.\n 8. Non Vegetarian and / or Pungent food is not allowed in the hotel premises.\n 9. We do not allow Pets. 10. We do not allow visitors entry to guest room.\n 11. We accept advance booking only upto 1 month with full tariff advance payment.\n 12. Personal food and beverages are not allowed.\n','Hospitality quotes are powerful and proven distillations of the shared experiences of  hoteliers and their staff. Whether it’s a pithy description of a common challenge that  everyone should expect and overcome, a brutal hard truth that every hotelier must accept,  or an insightful piece of wisdom that can change minds and shine a light on possible  solution, there’s a hospitality quote to help any frustrated, uninspired or just curious  hotelier make more of the opportunities around their business.',2),(3,'Hotels are one of the most important industries in the world. They are an essential part\n of a traveler’s experience. The hotel industry is also a large, global industry with\n significant revenue and importance to the economy. The key to hotels remaining relevant\n is by having an online web presence. When one is writing about hotels it’s important to\n create an exceptional description of hotels that includes topics that are pertinent to the\n ir target audience and include accurate information about them. Also, make sure a hotel’s\n website is up-to-date. This will help land a hotel’s booking call to action goal for all\n its services and products.Most hotels rely on one page and contact form to provide most\n of the information to potential guests. The problem is that those two are not enough to\n get a complete picture of what the hotel can offer. This is why photos and videos are so\n important.','1. Check-in time is 02:00 PM and check-out time is 12:00 PM noon. Subject to availability, early check-in and late check-out will be considered.\n 2. Extra Person charges – Rs. 350 per person. \n 3. GST / Taxes charged extra and applicable as per government directives.\n 4. 100 % advance Payment deposit at the time of Check in.\n 5. We do not accept personal Cheques for payment.\n 6. It is Mandatory for all customers and their visitor guests to share their ID cards. Foreign Nationals are required to present their passport and valid visa.\n 7. Smoking, Alcohol, Gambling, Prostitution, contraband goods, drugs, etc – are all strictly prohibited within the hotel premises.\n 8. Non Vegetarian and / or Pungent food is not allowed in the hotel premises.\n 9. We do not allow Pets. 10. We do not allow visitors entry to guest room.\n 11. We accept advance booking only upto 1 month with full tariff advance payment.\n 12. Personal food and beverages are not allowed.\n','Hospitality quotes are powerful and proven distillations of the shared experiences of  hoteliers and their staff. Whether it’s a pithy description of a common challenge that  everyone should expect and overcome, a brutal hard truth that every hotelier must accept,  or an insightful piece of wisdom that can change minds and shine a light on possible  solution, there’s a hospitality quote to help any frustrated, uninspired or just curious  hotelier make more of the opportunities around their business.',3),(4,'Hotels are one of the most important industries in the world. They are an essential part\n of a traveler’s experience. The hotel industry is also a large, global industry with\n significant revenue and importance to the economy. The key to hotels remaining relevant\n is by having an online web presence. When one is writing about hotels it’s important to\n create an exceptional description of hotels that includes topics that are pertinent to the\n ir target audience and include accurate information about them. Also, make sure a hotel’s\n website is up-to-date. This will help land a hotel’s booking call to action goal for all\n its services and products.Most hotels rely on one page and contact form to provide most\n of the information to potential guests. The problem is that those two are not enough to\n get a complete picture of what the hotel can offer. This is why photos and videos are so\n important.','1. Check-in time is 02:00 PM and check-out time is 12:00 PM noon. Subject to availability, early check-in and late check-out will be considered.\n 2. Extra Person charges – Rs. 350 per person. \n 3. GST / Taxes charged extra and applicable as per government directives.\n 4. 100 % advance Payment deposit at the time of Check in.\n 5. We do not accept personal Cheques for payment.\n 6. It is Mandatory for all customers and their visitor guests to share their ID cards. Foreign Nationals are required to present their passport and valid visa.\n 7. Smoking, Alcohol, Gambling, Prostitution, contraband goods, drugs, etc – are all strictly prohibited within the hotel premises.\n 8. Non Vegetarian and / or Pungent food is not allowed in the hotel premises.\n 9. We do not allow Pets. 10. We do not allow visitors entry to guest room.\n 11. We accept advance booking only upto 1 month with full tariff advance payment.\n 12. Personal food and beverages are not allowed.\n','Hospitality quotes are powerful and proven distillations of the shared experiences of hoteliers and their staff. Whether it’s a pithy description of a common challenge that everyone should expect and overcome, a brutal hard truth that every hotelier must accept, or an insightful piece of wisdom that can change minds and shine a light on possible solution, there’s a hospitality quote to help any frustrated, uninspired or just curious hotelier make more of the opportunities around their business.',4),(5,'Hotels are one of the most important industries in the world. They are an essential part\n of a traveler’s experience. The hotel industry is also a large, global industry with\n significant revenue and importance to the economy. The key to hotels remaining relevant\n is by having an online web presence. When one is writing about hotels it’s important to\n create an exceptional description of hotels that includes topics that are pertinent to the\n ir target audience and include accurate information about them. Also, make sure a hotel’s\n website is up-to-date. This will help land a hotel’s booking call to action goal for all\n its services and products.Most hotels rely on one page and contact form to provide most\n of the information to potential guests. The problem is that those two are not enough to\n get a complete picture of what the hotel can offer. This is why photos and videos are so\n important.',' 1. Check-in time is 02:00 PM and check-out time is 12:00 PM noon. Subject to availability, early check-in and late check-out will be considered.\n 2. Extra Person charges – Rs. 350 per person. \n 3. GST / Taxes charged extra and applicable as per government directives.\n 4. 100 % advance Payment deposit at the time of Check in.\n 5. We do not accept personal Cheques for payment.\n 6. It is Mandatory for all customers and their visitor guests to share their ID cards. Foreign Nationals are required to present their passport and valid visa.\n 7. Smoking, Alcohol, Gambling, Prostitution, contraband goods, drugs, etc – are all strictly prohibited within the hotel premises.\n 8. Non Vegetarian and / or Pungent food is not allowed in the hotel premises.\n 9. We do not allow Pets. 10. We do not allow visitors entry to guest room.\n 11. We accept advance booking only upto 1 month with full tariff advance payment.\n 12. Personal food and beverages are not allowed.\n','Hospitality quotes are powerful and proven distillations of the shared experiences of hoteliers and their staff. Whether it’s a pithy description of a common challenge that everyone should expect and overcome, a brutal hard truth that every hotelier must accept, or an insightful piece of wisdom that can change minds and shine a light on possible solution, there’s a hospitality quote to help any frustrated, uninspired or just curious hotelier make more of the opportunities around their business.',5);
/*!40000 ALTER TABLE `hotel_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `rating` varchar(255) DEFAULT NULL,
  `hotel_admin_id` int DEFAULT NULL,
  `location_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK10ymd8rb9c8wicjrq3t48i45c` (`hotel_admin_id`),
  KEY `FKqs8u4n6x2f5anae9lllt3857p` (`location_id`),
  CONSTRAINT `FK10ymd8rb9c8wicjrq3t48i45c` FOREIGN KEY (`hotel_admin_id`) REFERENCES `hotel_admin` (`id`),
  CONSTRAINT `FKqs8u4n6x2f5anae9lllt3857p` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'G, 1 Minto Rd, Dhaka 1000','1756634338830_inter.jpg','InterContinental Dhaka by IHG','5',1,5),(2,'Airport Rd, Dhaka 1206','1756637994547_readison.jpg','Radisson Blu Water Garden Hotel','5',1,5),(3,'Marine Drive, Road, Cox\'s Bazar','1756640878258_SymanBeach Resort.jpg','Sayeman Beach Resort','4.5',2,1),(4,'Kakra Beach, Marine Drive Road Near Baitus Salam Jame Mosjid, Ramu 4700','1756641748162_SampanHotel.jpg','Sampan Resort & Spa','4.8',2,1),(5,'Malipara - Digirchala Rd,Gazipur','1756642687766_SaraResort.jpg','Sarah Resort Gazipur','4.5',3,2);
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Cox\'s Bazar_d4654071-5ca9-4b56-8ae4-8f10a65be984','Cox\'s Bazar'),(2,'Gazipur_7acdb066-cf9b-475c-8ffa-50896732962d','Gazipur'),(3,'Sylhet_1df5f888-9daf-44e9-9b8e-e89f7cd1604d','Sylhet'),(4,'Rangamati_55518315-0bd6-49e7-9bcb-a894d1091dc3','Rangamati'),(5,'Dhaka_d27d84ae-24ab-4a36-9017-9a2e776c6435','Dhaka'),(6,'Chittagong_85266514-70e5-4d8d-902c-8989942efaec','Chittagong');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `adults` int NOT NULL,
  `available_rooms` int NOT NULL,
  `booked_rooms` int NOT NULL,
  `children` int NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `room_type` varchar(255) DEFAULT NULL,
  `total_rooms` int NOT NULL,
  `hotel_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKp5lufxy0ghq53ugm93hdc941k` (`hotel_id`),
  CONSTRAINT `FKp5lufxy0ghq53ugm93hdc941k` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,2,18,2,2,'Deluxe_d5043e3d-3f94-4db2-baba-e4534ca8bb7f',12000,'Deluxe',20,1),(2,2,17,3,2,'Double Deluxe_e467cbfc-72c8-496d-a6bc-9e5e9b261f33',18000,'Double Deluxe',20,1),(3,2,19,1,2,'Premium_c2d2d048-7972-453c-89d5-05dae99d7d76',25000,'Premium',20,1),(4,2,25,0,2,'Deluxe_1dd5c5a1-fefb-4f8d-90cf-9ce639a9a51b',15000,'Deluxe',25,2),(5,2,29,1,2,'Premium_7bb9d5a0-2a97-4c0e-9e4a-c29bee2d02c6',30000,'Premium',30,2),(6,2,19,1,2,'Single_b6e6211a-fd94-47b2-8cbc-662588e94348',12000,'Single',20,2),(7,2,14,1,2,'Deluxe_2652e2c8-d683-4afd-b48e-53189c6ece47',10000,'Deluxe',15,3),(8,3,9,1,2,'King Size Bed_446dbab9-451f-40b1-beb9-8076c6b09c70',20000,'King Size Bed',10,3),(9,2,18,2,2,'Premium_ae2fc9c9-afc8-4f0d-86a7-957862ed0996',18000,'Premium',20,3),(10,2,14,1,2,'Deluxe_3010d6b2-a2e5-4003-9341-943aa075a35c',7000,'Deluxe',15,4),(11,4,8,2,0,'Double Bed_8df06023-b09e-4d3b-93f5-ea824fd12bee',12000,'Double Bed',10,4),(12,2,19,1,1,'Single_1e7c3e89-5cfd-4fbd-88c0-9eb5d5df48d7',10000,'Single',20,4),(13,2,15,0,2,'Deluxe_b652fabc-300f-4700-b25b-f1203dad0127',10000,'Deluxe',15,5),(14,4,15,0,0,'Double Deluxe_3b8cd96a-9bbb-4b86-a1e3-322f3398db91',12000,'Double Deluxe',15,5),(15,2,15,0,2,'Suite_22adefb0-887a-478c-a722-92cff3990018',15000,'Suite',15,5);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_log_out` bit(1) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2dylsfo39lgjyqml2tbe0b0ss` (`user_id`),
  CONSTRAINT `FK2dylsfo39lgjyqml2tbe0b0ss` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
INSERT INTO `tokens` VALUES (1,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY2MzI0NDIsImV4cCI6MTc1NjcxODg0Mn0.pw7LU105DBsspEr_E0mFDkyeeJoEFgvpJA_KCLplrDY',1),(2,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY2MzI2MDEsImV4cCI6MTc1NjcxOTAwMX0.WqUK_8uCty-WBaHPXlu52N98G8f0EKCHMVNg-rMToFM',1),(3,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY2MzI2MjUsImV4cCI6MTc1NjcxOTAyNX0.BJJp_sWcG71s2yuXyEcW1CDjZC2_2tF7pJp7lwuhs5o',1),(4,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjYzMzMyNywiZXhwIjoxNzU2NzE5NzI3fQ.QP1K6QhiRDDBGxXp9kSpB-LxUEUeMK_w1xoLBxb4SYc',2),(5,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjYzMzM5MywiZXhwIjoxNzU2NzE5NzkzfQ.Y_dIBZzV4Nos0fpW5fJROL9eQU9f7yGpXOcZP2eCqW0',2),(6,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NjM4ODA4LCJleHAiOjE3NTY3MjUyMDh9.0_kQj_ryg1R3cdBdfk1L9_A5Y4SL7b0a0zV6wzbQgjo',3),(7,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NjM4ODQ4LCJleHAiOjE3NTY3MjUyNDh9.3pTzmtDKHK0MzYfDYWritOyzZEgC4dEetAK1tCIRmX0',3),(8,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NjM4ODg1LCJleHAiOjE3NTY3MjUyODV9.McgR0z6GkUV7Hp8Vf2qVjzqb_ZcwHs0EuDq0RD4Oplk',3),(9,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJha2liaXNsYW03NTEyQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjYzOTMwOCwiZXhwIjoxNzU2NzI1NzA4fQ.DlqYqsdLtZQUV92oSTWz2aC1eU_YMSivUTRCPl4UkKM',4),(10,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJha2liaXNsYW03NTEyQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjYzOTM0OSwiZXhwIjoxNzU2NzI1NzQ5fQ.kA43tG4lKiy10HFty8iI0oMIq7tnINlk0MT-24RdQTI',4),(11,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjYzOTQ3MywiZXhwIjoxNzU2NzI1ODczfQ.AJmKdJe6e9yo_az1I5MWHyubBKPLQPoJAQ008uAZzD8',2),(12,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NjM5NjEzLCJleHAiOjE3NTY3MjYwMTN9.oZS9v_3BCkUgp5vYIxErYGwD1n9RHhRlzM3nnMqjgZg',3),(13,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJha2liaXNsYW03NTEyQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MDc5MCwiZXhwIjoxNzU2NzI3MTkwfQ.r3C_oAFnudAdWl9NBHPGWpmsfuGSSbA3aw81m82CA3k',4),(14,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MDk4OCwiZXhwIjoxNzU2NzI3Mzg4fQ.mg4pXme5-RGHpMOE4ulwaUeNv8OOYt3hmP1VPRK_qB8',2),(15,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJha2liaXNsYW03NTEyQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MTAyMiwiZXhwIjoxNzU2NzI3NDIyfQ.nrJz1tM26L4OlK4OeDjFy9BiZWOZDHcCIbhtgroFf18',4),(16,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJha2liaXNsYW03NTEyQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MTMyNiwiZXhwIjoxNzU2NzI3NzI2fQ.wqoiCYg1WFI5dammSUcC3mM_OSkuiNH8wyFFi1oMIr4',4),(17,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY2NDIxNTQsImV4cCI6MTc1NjcyODU1NH0.WpCwhhlM0BhnONVd1cnMyffYoOmy0KPltA787INp6eM',1),(18,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYmR1cnJhaGlta2hhbjIxNGRjQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MjQxNiwiZXhwIjoxNzU2NzI4ODE2fQ.6CIXkO83gLhUCab4lcGLQXfkeH2cj3ZWlDc0nXIvP2g',5),(19,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYmR1cnJhaGlta2hhbjIxNGRjQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MjUyMSwiZXhwIjoxNzU2NzI4OTIxfQ.HS8S63Uby44s5UBCOskdcEuNJw-Q1Nb48jmuxKph3Vs',5),(20,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYmR1cnJhaGlta2hhbjIxNGRjQGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjY0MzE4OCwiZXhwIjoxNzU2NzI5NTg4fQ.El-7435_JAVpCP7q0TOBdUs01VQxir5qYv8mrEiXs-I',5),(21,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NzE1NzMyLCJleHAiOjE3NTY4MDIxMzJ9.PpMphmZCC_lh3Tdldbss61GwX_E6NUk6hG5hr-gU7vk',3),(22,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjcxNTkxMiwiZXhwIjoxNzU2ODAyMzEyfQ.7qkeZIxvU4jc5LM0iBD1vD7ZIh1dNdfdxLxST04yz7E',2),(23,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY3MTYwNDAsImV4cCI6MTc1NjgwMjQ0MH0.kRxPLm6mJJo7TC7zMe2kD-5PSvDHAnOHvhv0mGAqIc8',1),(24,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NzE3NTQ2LCJleHAiOjE3NTY4MDM5NDZ9.aLxdzr-8k22ommxmzv-EHjL2rRL-v69ycEF8PwWyKOo',6),(25,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NzE3NTc2LCJleHAiOjE3NTY4MDM5NzZ9.gHF270enDTGZRKF7bZhGm93uCxuwn-aFPMIn6fsolms',6),(26,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU2NzE4NzI5LCJleHAiOjE3NTY4MDUxMjl9.xphkUL8ifoZ_rbvG8NBGa0F3KsOmTLhIjVv3uLM3aK8',3),(27,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NjcxODgzMSwiZXhwIjoxNzU2ODA1MjMxfQ.ggmfBHKYnBmJjjh9kIIa4_sNwI93pZHXPCpuOsHpnOI',2),(28,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTY3MTg5NTUsImV4cCI6MTc1NjgwNTM1NX0.qW7dPlHM5FamggjATxNn4YTnbVtYH361NFXb3FFUr6A',1),(29,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1Njg5MDI5MiwiZXhwIjoxNzU2OTc2NjkyfQ.elzcd7BFx8DdOpH2WFqGiJzSUc4qOtkYQqQdnqISV7A',2),(30,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1Njg5MDMwNSwiZXhwIjoxNzU2OTc2NzA1fQ.MnUdeklVuR0ir5u_glSBDSpZX28zZ-iWpZzMoTV69sY',2),(31,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzIzNTY0MCwiZXhwIjoxNzU3MzIyMDQwfQ.wbuJbqfgMD_KqUn3q2iozq1JafhwqPA6XFjnXR9FgoA',2),(32,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTczMjI5OTEsImV4cCI6MTc1NzQwOTM5MX0.C8saWhBWKDd1ZjdOxIFVNAJRJIdqR98otNox8HCFTPg',1),(33,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDExOTIzLCJleHAiOjE3NTc0OTgzMjN9.WxSTP9G82ElqzdmXYXfKepeCnPvTTIrx50AHNohGyhw',6),(34,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDExOTU1LCJleHAiOjE3NTc0OTgzNTV9.vWTpZag5ZQ7U5PRsLHUNx1GZ252bL5A1irpvWVjp7aE',6),(35,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDEyMDUyLCJleHAiOjE3NTc0OTg0NTJ9.-C69UWK8esqH1muDpZtoUGtWFA98GczIqS8C7BxZ8ZY',6),(36,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDEyMjIzLCJleHAiOjE3NTc0OTg2MjN9.s6UQWfNiqIrzEMrYDIFryig-XcDx-ZO07SV1XYpJsEs',3),(37,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0MTIzMzgsImV4cCI6MTc1NzQ5ODczOH0.Nyo7-yQd54Py2g7EKsNSxVwFUsRRV3OCHz_G4qPxQiw',1),(38,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDEyNDAwLCJleHAiOjE3NTc0OTg4MDB9.WXuvZ42l54JKi7blx0eFUtHFLRg9fSM647lagb5zH4w',6),(39,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDEyNTE2LCJleHAiOjE3NTc0OTg5MTZ9.KgcQuQzU6R2efrwV7bJshRviWOuIM5CNX0uYUwqr8BM',6),(40,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDE2MzM5LCJleHAiOjE3NTc1MDI3Mzl9.v1z8YSDJ7z9RpoEJLNxbYgBeCaFDMxoPFJF7lzmxsGo',6),(41,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTY5OTEsImV4cCI6MTc1NzU4MzM5MX0.L8X5PdFzY-vO1ErkAOm-pyK4JQwUCorV0fh6OjYYCZY',1),(42,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTcwMDgsImV4cCI6MTc1NzU4MzQwOH0.SOzAjpEZifqyDmpphaPLVZwafgPOi6QdQk-vaH_miTE',1),(43,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDk4MzM3LCJleHAiOjE3NTc1ODQ3Mzd9.wNO_QgljbuHnqhUM5Q969uqWKYWfwJiX553QLNulofA',6),(44,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDk4Mzk2LCJleHAiOjE3NTc1ODQ3OTZ9.B0WBP8NLof6J9JaT5KS6HCUUeJ9PyyxhvHzRxV4Hjmk',6),(45,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDk4Mzk3LCJleHAiOjE3NTc1ODQ3OTd9.7RVvHfNx9E9YJ8t06867OS_F5nG0TvbAxrEO8EECQdY',6),(46,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDk4NDQxLCJleHAiOjE3NTc1ODQ4NDF9.pcP2ZxYKLiJrkUqoRO1U0SEPHJWkFiLLEC7L4io9Kic',6),(47,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTg0NTUsImV4cCI6MTc1NzU4NDg1NX0.os5NHF-CIEo4kLNMNg58h2EmS3s_ks4dibdcV5F2E6Y',1),(48,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTg0NTcsImV4cCI6MTc1NzU4NDg1N30.QHQRRHV5wo9f_xV3qYz3Vv9M53zezJtGClc9UH6hel8',1),(49,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTg0OTYsImV4cCI6MTc1NzU4NDg5Nn0._mi-QXV-5qeeCzPMzq6IUKi2JeN5Z2_Svlrh3Lz49U4',1),(50,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NDk5NDEyLCJleHAiOjE3NTc1ODU4MTJ9.u_zlx4EdurrIFZX1DEo3oc5PrazKkEu9ZLajLxsJMmA',6),(51,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc0OTk5ODEsImV4cCI6MTc1NzU4NjM4MX0.bpVkzZL_xA-hVZtRGEILuYqCw7QI5zV52TX5Yl6fTdo',1),(52,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDAzNjAsImV4cCI6MTc1NzU4Njc2MH0.TXy246WDeyZqIgPTcs3HDGZfXbD3OVTXU3TWvhFzmXk',1),(53,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTAwMzc3LCJleHAiOjE3NTc1ODY3Nzd9.tHbxJxS5EdAzly3tg9axj0Vyr0sxccvlz7mb7yhyBp0',6),(54,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDUzMDQsImV4cCI6MTc1NzU5MTcwNH0.aZeQYB4a_B3uNLjo1b5-e6LsHt_b5TcAVO8AQknOqeo',1),(55,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDUzMjUsImV4cCI6MTc1NzU5MTcyNX0.xRs4kCIQaj0JLzOIpT3Mn-pvF6mvRe734q8udrtPrIU',1),(56,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDU5MjgsImV4cCI6MTc1NzU5MjMyOH0._tmMw0YrazQNhToXCR1NYsQO3ryoI3zvbgiNQ6JQOQQ',1),(57,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDY0NzcsImV4cCI6MTc1NzU5Mjg3N30.BJGcDhUG-oe43ZRJQdTH4s3t6NiuJ4DbmQigNN84zyk',1),(58,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTA5MDkxLCJleHAiOjE3NTc1OTU0OTF9.U0pNQEakD5dS0EQ5EV0_7VcwZNW7ghcetwGs5MtYinY',6),(59,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDkzMzksImV4cCI6MTc1NzU5NTczOX0.741yLAio4iGoVrYGmUu3-vD0MlEJTChl3NiqSzz1a4c',1),(60,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDkzODAsImV4cCI6MTc1NzU5NTc4MH0._tDHHj10_bkglupDWQoXk1GAd1wdEzb7SNjSvwXskcQ',1),(61,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTA5NDE2LCJleHAiOjE3NTc1OTU4MTZ9.wfy8RKzcNM-UgZe3icJFcKDUVoaDzGuD8zjTjdb8kRY',3),(62,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDk0MjksImV4cCI6MTc1NzU5NTgyOX0.65YXqav9K15snBO1fTW2eNB3w7x1ClDYdn3J-KIX5nE',1),(63,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDk0NjgsImV4cCI6MTc1NzU5NTg2OH0.KtmR8r5A2VJdMl9psnDhQekcjmYkCXpLJtv1I3dRudo',1),(64,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDk2MzgsImV4cCI6MTc1NzU5NjAzOH0.dhvKzO7jZTDGVtsHldjn_0CjH5PQdoKchmDD9jmy0Pg',1),(65,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTA5Nzc5LCJleHAiOjE3NTc1OTYxNzl9.e3TcJnM4OoV3UzpHYbvRqobfVliQ2SBOPFyxDTsWCnU',6),(66,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHJhaG1hdHVsbGFoc2hhaHJ1a2hAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTA5Nzg3LCJleHAiOjE3NTc1OTYxODd9.CC06kO3u-ZRqlh-ISydjL9z0STlxCqzgzBYikLP8E_Q',3),(67,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzUwOTgxMiwiZXhwIjoxNzU3NTk2MjEyfQ.-bBILISi8uP2WJpaRFyx7ql0nkC3ELmRY1I4fT6AT3U',2),(68,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1MDk4NDksImV4cCI6MTc1NzU5NjI0OX0.OHNDXa2JroDzdUxNzeWkURmjfvwKiQOOlcYqQkVyMBY',1),(69,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1ODYyMjEsImV4cCI6MTc1NzY3MjYyMX0.7IBuhtW83HlNT-qYdWLO4_hRj5KxS5dbONujJZn5nlo',1),(70,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1ODg4MTYsImV4cCI6MTc1NzY3NTIxNn0.gv83LVpb80kRz7mhM7Gtl0gJvcuTz5Qbd7VG9q_fWIg',1),(71,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTkyOTc4LCJleHAiOjE3NTc2NzkzNzh9.AsaXEJmy4eKAcdjRXldjtUR4uwuWBPtE-nC4vZdiI2I',6),(72,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTMwNTYsImV4cCI6MTc1NzY3OTQ1Nn0.2LFGMxbIA-qHJfLBeLgSjvMwsrdcgGfpft4pbW3QxK0',1),(73,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTMwNzIsImV4cCI6MTc1NzY3OTQ3Mn0.CR3aLGj-hwCPLu7xL_TIb9y7SAM5GqLlmmQCvOyDGuw',1),(74,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTMxNzUsImV4cCI6MTc1NzY3OTU3NX0.tpCX5eFS0oHqVkUTdXwRrObcUPtjcwaXEiIGOTq_o0c',1),(75,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTMyNDksImV4cCI6MTc1NzY3OTY0OX0.nwHtTWLAbQIV-RXxUWpgIROAOKqZzpOYP3WkhYgK7_Y',1),(76,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTMzMTUsImV4cCI6MTc1NzY3OTcxNX0.rxhuKf8vwz9cqVq5y7ifkNz4qhprD6I0_BfgIOfdM7s',1),(77,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTkzMzQxLCJleHAiOjE3NTc2Nzk3NDF9.9YxISp4cZ1iMI01UBKDsrv5kYgPxTQSnmjEGBI2H5hM',6),(78,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5MzUzOSwiZXhwIjoxNzU3Njc5OTM5fQ.mAmlSE4VhNV5oui2zCbNFpRora_Et6kASWbAuFfYXws',2),(79,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5MzkxOCwiZXhwIjoxNzU3NjgwMzE4fQ.cmiG2YhkIkJNHmEPEaYgXwtwv1GpPKYNCWQc3OJ86T4',2),(80,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTM5MzcsImV4cCI6MTc1NzY4MDMzN30.ZBxdcJEVx2YBQKg3_QJzohJwNfbMZQ0tFzDczGEayWY',1),(81,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5NDA3MywiZXhwIjoxNzU3NjgwNDczfQ.dNX_mVN01d3tGLM0bm945PmV9RKFUOYnlkw9y27EvJY',2),(82,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTQwODMsImV4cCI6MTc1NzY4MDQ4M30.xNB663bY5Ggs0iLzAV1FZxRIR7X8yudSNRWmBFCktpQ',1),(83,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTQxMTYsImV4cCI6MTc1NzY4MDUxNn0.c6yL78J2C_I89uiI9yHSwRoNwmdbqkrROU8i6oRFrCc',1),(84,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5NDQ5NSwiZXhwIjoxNzU3NjgwODk1fQ.NooXbQfQfrV1y-QzfLViodSfRd_zpqNVeXauYnmFR5c',2),(85,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5NDUxNywiZXhwIjoxNzU3NjgwOTE3fQ.q_zW_2MDEZ407CcyhCjYZ4_K_bXWOBAGi50_ow5-iEo',2),(86,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTQ1NjEsImV4cCI6MTc1NzY4MDk2MX0.ThDHGgLkx9wYHW9qKsbrHQZTfM1yHYjcoCt-1mFDJG4',1),(87,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5NDYwNiwiZXhwIjoxNzU3NjgxMDA2fQ.v9HtVrhhBvGxUfLrkJksb96itqu7XK1rByLPOSTF-Zk',2),(88,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1NzU5NTMxNCwiZXhwIjoxNzU3NjgxNzE0fQ.PjDrOJ8c4XhKZ_XNdatEMpRrfZ9hKY4-mNobkDAODZA',2),(89,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTUzMjksImV4cCI6MTc1NzY4MTcyOX0._cwtvOHhp3hqhzG5EQvX16TqVAbYcvF5ASPv3BUmhXk',1),(90,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTk1MzkwLCJleHAiOjE3NTc2ODE3OTB9.h8Ms444f4aDWAxZbMTZo-hrNt7Hn7jLdrEcI6ZOJVTc',6),(91,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTU0NTUsImV4cCI6MTc1NzY4MTg1NX0.hO2L2hpLhUT2O-Eg0B0OW6n6U8amZodvgeuxyPMGDA0',1),(92,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc1OTU1MjcsImV4cCI6MTc1NzY4MTkyN30.z0fCqRZueVfRfmCBuXpwo_elNHEUrVAS5CE8_qinxD4',1),(93,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU3NTk1NTUwLCJleHAiOjE3NTc2ODE5NTB9.u4S3JLDQFNw7AjaKVs3lLyqH2-jjfASWYj_4cGBFIVs',6),(94,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc5MjcyNTAsImV4cCI6MTc1ODAxMzY1MH0.HUSXw37Fsieyl_jFINC7_CXUSvEG3mzD_l-hf_QGMF0',1),(95,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTc5Mjc0NDMsImV4cCI6MTc1ODAxMzg0M30.pcJk6nmy9h4o820SsvlnTuq6BYPFpXxoDP0Zw2Prkuw',1),(96,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYmR1bGxhaGphd2FkQGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTc1NzkyNzcwMCwiZXhwIjoxNzU4MDE0MTAwfQ.GkqmSl6itZPU34whM-4J0hacilZnmqvdATRgbcdPmz0',7),(97,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYmR1bGxhaGphd2FkQGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTc1NzkyNzc1NCwiZXhwIjoxNzU4MDE0MTU0fQ.6OoSARiE1glXvzn9B7cQyhUp80MFrW2XplUCGou0Pc8',7),(98,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqdW5heWV0MDNAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MDIwNzY5LCJleHAiOjE3NTgxMDcxNjl9.KesMxNgRTkLFQCNVdUHsiaWDHH2plmkekWkd0lSKmmg',6),(99,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZGF0aXF1bGlzbGFtNTlAZ21haWwuY29tIiwicm9sZSI6IkhPVEVMX0FETUlOIiwiaWF0IjoxNzU4MTAxOTIwLCJleHAiOjE3NTgxODgzMjB9.ReWAm66bkXj9xkpOdDkMT1SEoUs9Zmqpo6o5ZkbScdE',8),(100,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZGF0aXF1bGlzbGFtNTlAZ21haWwuY29tIiwicm9sZSI6IkhPVEVMX0FETUlOIiwiaWF0IjoxNzU4MTAyMDIwLCJleHAiOjE3NTgxODg0MjB9.zX5IYzJKl20HA7Yw98GPPe-evySlcb8h7NcDMKm6pKE',8),(101,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWRpYXJAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MTEzMjUxLCJleHAiOjE3NTgxOTk2NTF9.gNv7tShSYYrfctp5O3g6jYp7kxusWXZcgEb3xAm0IHY',9),(102,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWRpYXJAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MTEzMzAwLCJleHAiOjE3NTgxOTk3MDB9.fHDfTv40oi55IuloztXvapd4Cxz3ucdMPN5fGq5KDSo',9),(103,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWRpYXJAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MTE0ODcwLCJleHAiOjE3NTgyMDEyNzB9.Ae6tb4DQ2LM2K3NamprehzVN1AmICCPk8NpPRw7VB8U',9),(104,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1ODE4NjgxOSwiZXhwIjoxNzU4MjczMjE5fQ.EeFq0KCLVciJ5JCFFMKaNiFkOaCs_vblnZEMnOHcolw',2),(105,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1ODE4NjgzNSwiZXhwIjoxNzU4MjczMjM1fQ.5jh7QWJ8M1x0Lnih6vODYZBPS1UVrkMKyL6ylqF9gWI',2),(106,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWRpYXJAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MTg2OTQyLCJleHAiOjE3NTgyNzMzNDJ9.Jjfh1vHWLTs_2JRUwTrVJwwY3ofgKKL6lAsjVMG5sr0',9),(107,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1ODE4NzAwOCwiZXhwIjoxNzU4MjczNDA4fQ.MAr39gjgFEvbz93TS8Y2k_IxcGD6Y2LfgtM-oDU_Hgo',2),(108,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTgxODcwODAsImV4cCI6MTc1ODI3MzQ4MH0._Vg876aBkQLnCAka2fWwzh4CcI0UoiPV-fX_0uFacio',1),(109,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTgxODcxNjYsImV4cCI6MTc1ODI3MzU2Nn0.SvmG2NbKTF-pI-3EnVRmEQqRMVx1BRyOrXx4bBAYUKY',1),(110,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzYWRpYXJAZ21haWwuY29tIiwicm9sZSI6IkNVU1RPTUVSIiwiaWF0IjoxNzU4MzU3NzQ1LCJleHAiOjE3NTg0NDQxNDV9.E8FA4DyJAA0kR21DiXn-dlw2F1SHn_Nu3-ygrevv2ZA',9),(111,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1ODM1ODE3MCwiZXhwIjoxNzU4NDQ0NTcwfQ.lgDyW0Tywe5bKQUUiHSi0UwCDmDfk6mEEuNrEMGiA_A',2),(112,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZHR1c2hlcmltcmFuMDQ5QGdtYWlsLmNvbSIsInJvbGUiOiJIT1RFTF9BRE1JTiIsImlhdCI6MTc1ODM1OTU1NywiZXhwIjoxNzU4NDQ1OTU3fQ.DoChNashl7RA5kijr_Vf_UaWmMwps91zoI5Mq6vajh4',2),(113,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJpbXJhbmhzc0BnbWFpbC5jb20iLCJyb2xlIjoiQURNSU4iLCJpYXQiOjE3NTgzNTk3ODQsImV4cCI6MTc1ODQ0NjE4NH0.7tGupOItz9n0nWxZuShC3NBxTkSR3V2OEc4puG5RTD4',1),(114,_binary '','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZC50LmltcmFuLmouZGV2QGdtYWlsLmNvbSIsInJvbGUiOiJDVVNUT01FUiIsImlhdCI6MTc1OTY0OTQ1MCwiZXhwIjoxNzU5NzM1ODUwfQ.1SJc_l0NI4f0J97p57OBI02sOD7jMLrfuho7kSkrXL8',10),(115,_binary '\0','eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtZC50LmltcmFuLmouZGV2QGdtYWlsLmNvbSIsInJvbGUiOiJDVVNUT01FUiIsImlhdCI6MTc1OTY0OTc0NywiZXhwIjoxNzU5NzM2MTQ3fQ.RQBswhKk91P398Tw06h3KexOUvkZhCmcIwtxbI2oSLE',10);
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_lock` bit(1) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `role` enum('ADMIN','CUSTOMER','HOTEL_ADMIN') DEFAULT NULL,
  `token_expiry` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,_binary '','imranhss@gmail.com','Muhammad Emran Hossain_3421704a-e63a-4c0a-b804-08212200f1f5',_binary '\0','Muhammad Emran Hossain','$2a$10$qFblimHi0aaEenX/8uuNMeZdpEiNr3wAq63plFaNkAgXV1YzR/mFm','01619192323',NULL,'ADMIN',NULL),(2,_binary '','mdtusherimran049@gmail.com','Md Imran Mia_3da5fb0e-2495-4451-aade-63266002c5ef',_binary '\0','Md Imran Mia','$2a$10$gq/psHzCpbpNuU1xYoNDVuQNnhT6Y0VIYU6lygudqzCJvLcNzxLAO','01571407696',NULL,'HOTEL_ADMIN',NULL),(3,_binary '','mdrahmatullahshahrukh@gmail.com','Md Rahmatullah Sharukh_46b3f6c5-a4f9-4437-b6fe-d0a85b4c4cc1',_binary '\0','Md Rahmatullah Sharukh','$2a$10$GC7NvXRxVAWXjeoFeb/GJe2dsNsedLsurWff2GVjJNTKtlVIJJUEG','01752456540',NULL,'CUSTOMER',NULL),(4,_binary '','mdrakibislam7512@gmail.com','Md Rakib Islam_84eb8cc7-0145-4590-af48-c3f11cc61743',_binary '\0','Md Rakib Islam','$2a$10$QAhEmKTzpCmgDOd5aKV/xu/RKP0rW8MTfCrFj0qn2ETRyNW/cjL1K','01675452525',NULL,'HOTEL_ADMIN',NULL),(5,_binary '','abdurrahimkhan214dc@gmail.com','Md Rahim Khan_c5b4689e-e8fa-4a7d-afa5-d0f88bf68d46',_binary '\0','Md Rahim Khan','$2a$10$JVPStKexUsf6895KK3Ead..Q7GyVAmMXB1N1G7hy2VwvyCV.9D5J6','01546875420',NULL,'HOTEL_ADMIN',NULL),(6,_binary '','junayet03@gmail.com','Md Shamim Junayet Istiaque_4027dac9-17fc-409f-9dbf-559a55f6edac',_binary '\0','Md Shamim Junayet Istiaque','$2a$10$ZOUl1uD6w0K0PdiOeY/3Be.of5kWNK//NZx7WndBCr7T3HmzATi1i','01245879654',NULL,'CUSTOMER',NULL),(7,_binary '','abdullahjawad@gmail.com','Md Abdullah Jawad_d3fff1f1-1545-454c-a669-e7e9bea2bc09',_binary '\0','Md Abdullah Jawad','$2a$10$CWFGZJty4zF0r6EAk52KSOO8C5pWaZXhX7D5LFyGyuYlveql1kuKe','01945025652',NULL,'ADMIN',NULL),(8,_binary '','mdatiqulislam59@gmail.com','Md Atikul Islam_dd387f3e-4e25-437f-8257-d5682da190ed',_binary '\0','Md Atikul Islam','$2a$10$hMS82ZNmRRmng4oLyM9doOYI2/Iz0BA65SYeWKAEmye5dVhi4Dvli','01710072023',NULL,'HOTEL_ADMIN',NULL),(9,_binary '','sadiar@gmail.com','Sadiar Rahman_9e196f4d-09f0-4d77-9cc1-747cce7b037e',_binary '\0','Sadiar Rahman','$2a$10$ELEIZNahqYfqz5p/EVUtkuLd6u4Vn0SXe0hIj06s/1CUUTYxLBAXq','05147521560',NULL,'CUSTOMER',NULL),(10,_binary '','md.t.imran.j.dev@gmail.com','Md imran mia_c34edb01-f212-4db3-845a-a578ff388c16',_binary '\0','Md imran mia','$2a$10$OSCG3qhjXxuDi0x/lCtsTuI0nu7iXF.80oQOQoNlQ8V/qUxbYG2Me','165465465r',NULL,'CUSTOMER',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-05 13:38:10
