
-- Drop DB if exists
DROP DATABASE IF EXISTS BackNinesDB;

-- Create and use DB
CREATE DATABASE IF NOT EXISTS BackNinesDB;
USE BackNinesDB;

-- Create tables --

DROP TABLE IF EXISTS `BackNinesDB`.`Users` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Users` (
  `person_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `user_password` VARCHAR(32) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `cell` VARCHAR(15) NOT NULL,
  `deptName` VARCHAR(45) NOT NULL,
  `fulltimeYorN` VARCHAR(4),
  `positionName` VARCHAR(45),
  `adminYorN` VARCHAR(4),
  `gradYear` VARCHAR(4),
  `birthDate` DATETIME,
  `create_time` DATETIME NOT NULL,
  PRIMARY KEY (person_id),
 CONSTRAINT Users_email_person_id_uk UNIQUE (email, person_id),
 CONSTRAINT Users_user_password_person_id_uk UNIQUE (user_password, person_id),
 CONSTRAINT Users_positionName_person_id_uk UNIQUE (positionName, person_id),
 CONSTRAINT Users_fulltimeYorN_person_id_uk UNIQUE (fulltimeYorN, person_id),
 CONSTRAINT Users_adminYorN_person_id_uk UNIQUE (adminYorN, person_id),
 CONSTRAINT Users_gradYear_person_id_uk UNIQUE (gradYear, person_id),
 CONSTRAINT Users_birthDate_person_id_uk UNIQUE (birthDate, person_id),
 INDEX lastFirst (last_name,first_name)
  )
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;
 
  
DROP TABLE IF EXISTS `BackNinesDB`.`Faculty` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Faculty` (
  `person_id` SMALLINT PRIMARY KEY NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `cell` VARCHAR(15) NOT NULL,
  `deptName` VARCHAR(45) NOT NULL,
  `fulltimeYorN` VARCHAR(4) NOT NULL,
   CONSTRAINT Faculty_person_id_fk FOREIGN KEY (`person_id`) REFERENCES Users (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT Faculty_email_fk FOREIGN KEY (`email`) REFERENCES Users (email) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT Faculty_fulltimeYorN_fk FOREIGN KEY (`fulltimeYorN`) REFERENCES Users (fulltimeYorN) ON DELETE CASCADE ON UPDATE CASCADE,
   INDEX lastFirst (last_name,first_name))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Staff` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Staff` (
  `person_id` SMALLINT PRIMARY KEY NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `cell` VARCHAR(15) NOT NULL,
  `deptName` VARCHAR(45) NOT NULL,
  `positionName` VARCHAR(45) NOT NULL,
  `adminYorN` VARCHAR(4) NOT NULL,
  CONSTRAINT Staff_person_id_fk FOREIGN KEY (`person_id`) REFERENCES Users (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Staff_email_fk FOREIGN KEY (`email`) REFERENCES Users (email) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Staff_adminYorN_fk FOREIGN KEY (`adminYorN`) REFERENCES Users (adminYorN) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Staff_positionName_fk FOREIGN KEY (`positionName`) REFERENCES Users (positionName) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX lastFirst (last_name,first_name))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Student` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Student` (
  `person_id` SMALLINT PRIMARY KEY NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email`  VARCHAR(255) NOT NULL,
  `cell` VARCHAR(15) NOT NULL,
  `deptName` VARCHAR(45) NOT NULL,
  `gradYear` VARCHAR(4) NOT NULL,
  `birthDate` DATETIME,
 CONSTRAINT Student_person_id_fk FOREIGN KEY (`person_id`) REFERENCES Users (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
 CONSTRAINT Student_email_fk FOREIGN KEY (`email`) REFERENCES Users (email) ON DELETE CASCADE ON UPDATE CASCADE,
 CONSTRAINT Student_gradYear_fk FOREIGN KEY (`gradYear`) REFERENCES Users (gradYear) ON DELETE CASCADE ON UPDATE CASCADE,
 CONSTRAINT Student_birthDate_fk FOREIGN KEY (`birthDate`) REFERENCES Users (birthDate) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX lastFirst (last_name,first_name))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Drivers` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Drivers` (
  `licenseNumber` VARCHAR(20) PRIMARY KEY NOT NULL,
  `dateHired` DATE NOT NULL,
  `person_id` SMALLINT,
  `isAvailable` VARCHAR(1),
CONSTRAINT Drivers_person_id_fk FOREIGN KEY (person_id) REFERENCES Users (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX personAvailable (person_id, isAvailable))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Carts` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Carts` (
`cartId` SMALLINT(1) NOT NULL AUTO_INCREMENT,
`make` VARCHAR(45) NOT NULL,
`model` VARCHAR(45) NOT NULL,
`numSeats` VARCHAR(1) NOT NULL,
`isAvailable` VARCHAR(1) NOT NULL,
PRIMARY KEY (`cartId`),
INDEX cartAvaialble (cartId, isAvailable)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Location` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Location` (
`locationId` SMALLINT NOT NULL AUTO_INCREMENT,
`locationName` VARCHAR(255) NOT NULL,
`locationAddress` VARCHAR(255) NOT NULL,
PRIMARY KEY (`locationId`),
INDEX idName(locationId, locationName)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`Ride` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`Ride` (
`rideId` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
`assignedCartId` SMALLINT(1),
`driverId` SMALLINT,
`riderId` SMALLINT,
`startLocationId` SMALLINT,
`endLocationId` SMALLINT,
`startTime` DATETIME NOT NULL,
PRIMARY KEY (`rideId`),
CONSTRAINT Ride_assignedCartId_fk FOREIGN KEY (assignedCartId) REFERENCES Carts (cartId) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Ride_driverId_fk FOREIGN KEY (driverId) REFERENCES Drivers (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Ride_riderId_fk FOREIGN KEY (riderId) REFERENCES Users (person_id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Ride_startLocationId_fk FOREIGN KEY (startLocationId) REFERENCES Location (LocationId) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT Ride_endLocationId_fk FOREIGN KEY (endLocationId) REFERENCES Location (LocationId) ON DELETE CASCADE ON UPDATE CASCADE,
INDEX startEnd (startLocationId, endLocationId)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `BackNinesDB`.`ride_History` ;
CREATE TABLE IF NOT EXISTS `BackNinesDB`.`ride_History` (
`rideId` SMALLINT UNSIGNED NOT NULL,
`assignedCartId` SMALLINT(1),
`driverId` SMALLINT,
`riderId` SMALLINT,
`startLocationId` SMALLINT,
`endLocationId` SMALLINT,
`startTime` DATETIME NOT NULL,
INDEX rideID (rideId)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
 
-- Triggers --

-- Adds users to proper tables when inserted into Users
DROP TRIGGER IF EXISTS loadData;
DELIMITER //
CREATE TRIGGER loadData
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
IF NEW.person_id IN (SELECT person_id FROM Users WHERE fulltimeYorN IS NOT NULL AND positionName IS NULL AND adminYorN IS NULL AND gradYear IS NULL)
THEN
INSERT INTO Faculty
VALUES (NEW.person_id, NEW.first_name, NEW.last_name, NEW.email, NEW.cell, NEW.deptName, NEW.fulltimeYorN);

ELSE IF NEW.person_id IN (SELECT person_id FROM Users WHERE fulltimeYorN IS NULL AND positionName IS NOT NULL AND adminYorN IS NOT NULL AND gradYear IS NULL)
THEN
INSERT INTO Staff 
VALUES (NEW.person_id, NEW.first_name, NEW.last_name, NEW.email, NEW.cell, NEW.deptName, NEW.positionName , NEW.adminYorN);

ELSE IF NEW.person_id IN (SELECT person_id FROM Users WHERE fulltimeYorN IS NULL AND positionName IS NULL AND adminYorN IS NULL AND gradYear IS NOT NULL)
THEN
INSERT INTO Student
VALUES (NEW.person_id, NEW.first_name, NEW.last_name, NEW.email, NEW.cell, NEW.deptName, NEW.gradYear, NEW.birthDate);
END IF;
END IF;
END IF;
END //
DELIMITER ; 
  
-- Trigger to set cart availability to 'Not available' while in use
DROP TRIGGER IF EXISTS cartNotAvailibile;
DELIMITER //
CREATE TRIGGER cartNotAvailibile 
AFTER INSERT ON Ride
FOR EACH ROW 
BEGIN
DECLARE assignedCartId SMALLINT(1);
DECLARE isAvailable SMALLINT(1);
UPDATE Carts
SET Carts.isAvailable = "N"
WHERE Carts.cartId = New.assignedCartId;
END //
DELIMITER ;

-- Trigger to set cart availability to 'Available' when ride is removed
DROP TRIGGER IF EXISTS cartAvailibile;
DELIMITER //
CREATE TRIGGER cartAvailibile 
BEFORE DELETE ON Ride
FOR EACH ROW 
BEGIN
DECLARE assignedCartId SMALLINT(1);
DECLARE isAvailable SMALLINT(1);
UPDATE Carts
SET Carts.isAvailable = "Y"
WHERE Carts.cartId = OLD.assignedCartId;
END //
DELIMITER ;

-- Trigger to set driver availablility to 'Not available' while assigned to a ride
DROP TRIGGER IF EXISTS driverNotAvailibile;
DELIMITER //
CREATE TRIGGER driverNotAvailibile 
AFTER INSERT ON Ride
FOR EACH ROW 
BEGIN
DECLARE driverId SMALLINT(1);
DECLARE isAvailable SMALLINT(1);
UPDATE Drivers
SET Drivers.isAvailable = "N"
WHERE Drivers.person_id = New.driverId;
END //
DELIMITER ;

-- Trigger to set driver availablility to 'Available' when ride is completed or removed
DROP TRIGGER IF EXISTS driverAvailibile;
DELIMITER //
CREATE TRIGGER driverAvailibile 
BEFORE DELETE ON Ride
FOR EACH ROW 
BEGIN
DECLARE driverId SMALLINT(1);
DECLARE isAvailable SMALLINT(1);
UPDATE Drivers
SET Drivers.isAvailable = "Y"
WHERE Drivers.person_id = OLD.driverId;
END //
DELIMITER ;

-- Inserts past/deleted rides into ride_history
DROP TRIGGER IF EXISTS delete_ride_History;
DELIMITER //
CREATE TRIGGER delete_ride_History
AFTER DELETE ON Ride
FOR EACH ROW
BEGIN
	INSERT INTO ride_History (`rideId`, `assignedCartId`, `driverId`,`riderId`, `startLocationId`, `endLocationId`, `startTime`)
    VALUES (old.rideId, old.assignedCartId, old.driverId, old.riderId, old.startLocationId, old.endLocationId, old.startTime);
END //
DELIMITER ;

-- INSERT TEST DATA -- 

-- Disable foreign key contraints for test data insert
SET FOREIGN_KEY_CHECKS=0;
-- Insert test data into Users 
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("adipiscing.Mauris@egetmassa.co.uk","PSQ90RMR5YH","Channing","Fitzgerald","(562) 962-7260","Finances",NULL,"SPECIALIST","N",2030,"1986-06-08 13:49:49","2019-07-19 06:01:44"),("elit.fermentum@Mauris.ca","CRA40MZW1VY","Knox","Meyer","(374) 162-7969","Legal Department",NULL,"ANALYST","N",2023,"1964-05-16 14:49:54","2019-11-10 12:06:45"),("magnis.dis@sodales.com","CAI56IKW3FG","Calista","Shaffer","(132) 718-1542","Sales and Marketing",NULL,"ACCOUNTANT","N",2025,"2000-04-30 17:25:19","2019-04-30 16:13:52"),("hendrerit.a@facilisis.co.uk","ZEY03BLU8GZ","Wallace","Maddox","(730) 900-9903","Human Resources","N","LIBRARIAN","Y",2019,"1970-07-25 04:57:43","2019-10-01 19:33:29"),("tellus.Phasellus.elit@idmollisnec.ca","PID54KMM5MP","Jenna","Johns","(761) 643-7214","Customer Relations",NULL,"ADVISOR","Y",2024,"1965-08-30 00:20:05","2019-03-14 18:49:53"),("ac.mattis.semper@auctorullamcorper.co.uk","KQL42PPH7HV","Jana","Graham","(907) 510-4394","Payroll",NULL,"ANALYST",NULL,2020,"2004-11-02 10:32:22","2019-11-24 17:52:15"),("Pellentesque.tincidunt.tempus@sapiengravida.com","WKJ62GLV1UT","Deirdre","Powell","(785) 240-0870","Quality Assurance","N","SPECIALIST",NULL,2025,"1992-04-20 00:55:00","2019-07-05 01:14:38");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("eros.nec.tellus@orciDonec.co.uk","WMW72DYW0MT","Xena","Wolfe","(598) 870-6466","Research and Development","Y",NULL,NULL,NULL,"1988-04-16 09:05:22","2019-03-21 07:07:47"),("per@quis.org","ROA04VQO2RZ","Rooney","Kelly","(359) 489-1805","Public Relations",NULL,"SUPPORT STAFF","N",NULL,"1999-10-04 04:36:24","2019-12-02 12:32:31"),("Sed.dictum.Proin@etliberoProin.ca","NKP78KTT5AK","Malachi","Kaufman","(484) 101-8574","Research and Development","Y",NULL,NULL,NULL,"1995-05-12 23:16:19","2018-07-06 16:09:08"),("iaculis.quis@nequeNullam.com","ISI17XEI5GR","Tasha","Griffith","(156) 287-2656","Sales and Marketing",NULL,"COACH","N",NULL,"1954-07-29 07:45:30","2018-07-17 01:03:28"),("orci.in.consequat@eu.ca","VQI45OXJ3TR","Neil","Barry","(914) 680-5338","Public Relations",NULL,NULL,NULL,2025,"1954-08-29 19:05:13","2019-07-11 08:10:38"),("mi.Aliquam@necurnaet.com","PWY14QNF1PB","Keane","James","(295) 847-2828","Quality Assurance","Y",NULL,NULL,NULL,"1969-10-02 15:36:03","2020-01-15 11:47:56"),("ultricies@lectusCumsociis.org","TBM39NIF8ZM","Craig","Mays","(298) 372-5743","Customer Service",NULL,NULL,NULL,2028,"1994-10-15 19:21:25","2019-05-28 10:55:38"),("erat@velit.net","SUN27VCC4ZW","Ashton","Arnold","(955) 864-8167","Customer Relations","N",NULL,NULL,NULL,"2000-04-12 17:15:38","2020-02-14 15:19:03"),("Vivamus.nisi.Mauris@nonummyFusce.com","SVE25GBW1ZY","Calista","Wise","(234) 382-8526","Research and Development",NULL,"LIBRARIAN","Y",NULL,"1975-11-23 19:15:15","2018-04-10 07:40:54"),("magna.Praesent.interdum@lacusMaurisnon.ca","ROE20XKD6QA","Allen","Lott","(559) 410-5752","Accounting","N",NULL,NULL,NULL,"1962-09-19 07:08:27","2018-05-26 00:45:35");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("sapien.Cras@nibh.org","YOS95PEF3IG","Malachi","Tyson","(261) 636-9026","Quality Assurance",NULL,"ANALYST","N",NULL,"1957-09-10 20:55:56","2019-06-25 22:02:56"),("risus.In@a.org","TLZ08RWH8NY","Malcolm","Walters","(929) 413-0486","Research and Development",NULL,NULL,NULL,2021,"1965-08-26 02:34:04","2020-01-06 03:39:44"),("lectus@ligula.ca","BLK55HCN3WK","Ivor","Tanner","(297) 620-1381","Advertising","Y",NULL,NULL,NULL,"1984-05-17 04:55:43","2019-04-14 11:33:53"),("fringilla.Donec@anteipsum.co.uk","NOM57LNN1HG","Zeus","Andrews","(840) 426-2658","Customer Service","N",NULL,NULL,NULL,"1975-01-12 17:21:59","2019-01-07 20:00:34"),("Nam@feugiatplaceratvelit.ca","RWX73WGH9WQ","Carson","Barron","(295) 273-5900","Customer Relations","Y",NULL,NULL,NULL,"1980-03-07 05:11:27","2019-06-20 02:05:41"),("odio.Phasellus.at@a.com","BEB37JIM6IS","Hector","Silva","(107) 604-2172","Asset Management",NULL,"OFFICER","Y",NULL,"1990-07-08 15:03:48","2018-12-21 04:50:04"),("ultricies@vestibulum.edu","ARD91KYQ2ZV","Ifeoma","Moore","(897) 779-7483","Quality Assurance","Y",NULL,NULL,NULL,"1961-01-20 19:07:46","2018-08-14 11:12:43"),("justo.nec.ante@lobortis.edu","SBE18MJE1YT","Octavius","Camacho","(622) 371-3611","Legal Department",NULL,NULL,NULL,2027,"1978-10-21 19:13:57","2019-08-01 20:58:27"),("Ut@ligulaNullam.co.uk","FFN80LFT7XP","Todd","Nielsen","(836) 611-2721","Human Resources","Y",NULL,NULL,NULL,"1994-05-22 23:57:18","2018-06-21 18:06:32"),("malesuada@euodiotristique.org","GNT93NON3MQ","Nero","Harding","(564) 710-1290","Payroll","Y",NULL,NULL,2028,"1976-02-28 06:00:44","2020-01-05 12:18:01");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("orci.adipiscing@diam.net","YTL78EIE6WA","Erich","David","(357) 481-5011","Public Relations",NULL,NULL,NULL,2027,"1998-10-13 04:25:02","2018-12-03 15:54:02"),("odio.vel.est@Vivamusnon.edu","YZW41QRY3KN","Deacon","Wagner","(659) 515-4294","Customer Relations",NULL,"PROGRAM ASSISTANT","Y",NULL,"1989-09-23 04:49:27","2018-06-08 04:54:06"),("vitae.sodales@semperetlacinia.ca","OLM75ANY7MA","Harding","Weber","(809) 116-1650","Research and Development",NULL,"INSTRUCTOR","Y",NULL,"1992-01-19 14:16:20","2019-12-09 11:20:12"),("ipsum.Donec.sollicitudin@nisl.org","LYN37ZQS4FO","Mary","Randall","(702) 311-9974","Finances",NULL,NULL,NULL,2027,"1984-09-15 17:11:41","2019-09-14 13:23:49"),("ligula.Aliquam@ametultriciessem.edu","RUX90NOS3OV","Serena","Castillo","(116) 195-0319","Tech Support",NULL,"ADMINISTRATIVE ASSISTANT","N",NULL,"1962-10-10 01:12:46","2018-05-17 11:35:26"),("neque.sed@dignissim.com","EHX59WDW5SV","Devin","Camacho","(722) 274-9897","Tech Support",NULL,NULL,NULL,2029,"1953-04-27 03:59:12","2018-04-21 03:57:21"),("Etiam.gravida.molestie@feugiatLorem.org","SJO87OVD3PE","Jada","Grant","(522) 861-1970","Tech Support",NULL,"INSTRUCTOR","Y",NULL,"2004-06-29 09:50:44","2019-07-13 00:54:29"),("odio.tristique@tellus.net","PMC01IAZ2FF","Chaim","Day","(695) 101-3814","Public Relations","Y",NULL,NULL,NULL,"1995-11-07 14:40:04","2018-10-13 04:42:41"),("sit.amet.lorem@tempor.org","FGX66QSN6NW","Rooney","Dickerson","(571) 119-7518","Quality Assurance",NULL,NULL,NULL,2030,"1961-03-17 22:35:30","2019-06-09 16:58:04"),("Integer.in.magna@diamlorem.com","EZZ30ATC5PT","Darius","Davis","(419) 642-6618","Advertising",NULL,NULL,NULL,2027,"1987-02-22 09:31:14","2019-02-09 22:46:07");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("arcu.Sed@ut.co.uk","EFM08LGL2OE","Helen","Armstrong","(478) 178-4622","Customer Relations",NULL,NULL,NULL,2025,"1992-03-08 02:20:01","2019-08-21 18:03:23"),("Praesent.eu.nulla@adipiscingelitCurabitur.com","FGV31BBX5KU","Keiko","Compton","(108) 122-9043","Asset Management","N",NULL,NULL,NULL,"1976-07-01 06:51:11","2019-09-29 18:17:30"),("sollicitudin.commodo.ipsum@fringillapurusmauris.org","DAV26TGN8GM","Knox","Huber","(197) 289-2385","Asset Management",NULL,"ACCOUNTANT","Y",NULL,"1994-11-30 16:44:00","2019-09-29 23:06:23"),("tellus.non.magna@fames.edu","BSO09WXB2IU","Kyle","Parrish","(316) 498-1449","Human Resources",NULL,"OFFICER","N",NULL,"1950-01-28 03:26:07","2019-04-26 11:04:21"),("risus@convallis.edu","FWZ44VDN9XL","Quentin","Gilliam","(287) 387-6939","Research and Development",NULL,NULL,NULL,2027,"1959-09-29 07:10:55","2019-07-26 12:39:40"),("enim.consequat.purus@Donectempus.co.uk","LKV47YPG5HX","Gil","Boyd","(160) 272-1662","Finances","Y",NULL,NULL,NULL,"1950-10-02 00:41:56","2019-08-01 02:56:04"),("ornare.lectus.justo@magna.co.uk","WDM08ICD7CY","Sebastian","Hurst","(299) 718-1760","Finances",NULL,NULL,NULL,2023,"1976-05-30 23:14:50","2018-07-07 03:10:11"),("rhoncus.Proin.nisl@euismodest.com","BPO03JWC0UA","Scott","Vincent","(274) 696-5426","Quality Assurance",NULL,NULL,NULL,2022,"1990-11-07 10:59:46","2019-10-22 20:27:41"),("Curabitur.sed@maurisrhoncusid.edu","HWT37BOJ7LI","Dennis","Bowen","(930) 988-6380","Quality Assurance","N",NULL,NULL,NULL,"1977-01-30 05:26:00","2018-12-04 21:36:39"),("in.faucibus@Integer.com","TXC97PMC4KX","Duncan","Haley","(152) 802-0706","Finances",NULL,"ACCOUNTANT","N",NULL,"1997-05-17 13:44:28","2018-05-29 16:46:33");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("habitant.morbi.tristique@mattis.org","CNM52ULI3LE","Amir","Leonard","(572) 393-0423","Payroll","Y",NULL,NULL,NULL,"1982-06-09 03:14:13","2019-07-03 06:55:36"),("Nunc@Loremipsum.edu","EPS43ETQ3QI","Nevada","Madden","(313) 472-5720","Customer Relations",NULL,NULL,NULL,2019,"1995-05-22 08:34:18","2018-09-06 03:24:37"),("purus@ultriciesornare.co.uk","SID40OLP5NU","Joel","Morgan","(361) 160-7442","Research and Development",NULL,"OFFICER","Y",NULL,"1967-04-27 19:01:46","2019-07-13 16:08:22"),("Fusce@nullaIntincidunt.edu","IGG20FCQ8JW","Piper","Summers","(417) 137-5248","Human Resources",NULL,"ANALYST","N",NULL,"1978-05-20 23:22:29","2018-10-13 02:21:27"),("consectetuer.adipiscing.elit@dis.ca","LKS39VUG2EL","Yen","Douglas","(183) 476-6403","Customer Relations",NULL,"ACCOUNTANT","N",NULL,"1989-03-11 09:13:06","2018-04-09 03:07:08"),("Suspendisse@tellusjusto.org","ASE85UOP2ET","Kirk","Baker","(534) 319-1913","Public Relations",NULL,"ACCOUNTANT","Y",NULL,"1976-09-04 19:35:37","2019-02-23 08:27:39"),("natoque.penatibus@Sedauctor.com","RKW94YCG8LO","Roanna","Brady","(322) 114-6260","Public Relations",NULL,NULL,NULL,2025,"1979-08-23 03:14:25","2018-05-24 09:45:10"),("eu.dui.Cum@liberoettristique.co.uk","SHL46HRC6SM","Lewis","Heath","(848) 384-7381","Customer Relations",NULL,"ANALYST","Y",NULL,"1966-09-09 04:32:57","2019-07-11 17:06:48"),("aliquam.enim@Duisvolutpat.co.uk","ZOA11MQU5NY","Eliana","Shaw","(102) 386-3321","Human Resources",NULL,NULL,NULL,2024,"1956-02-03 11:18:41","2019-02-16 17:21:43"),("tempus@dictum.com","WBT78SEK5PV","Chaney","Lindsey","(276) 548-2440","Legal Department",NULL,"STAFF NURSE","Y",NULL,"1995-08-16 09:19:45","2019-10-19 14:22:30");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("scelerisque.mollis.Phasellus@laoreet.net","IJL56VZE1PD","Madaline","Bell","(935) 204-0735","Legal Department",NULL,NULL,NULL,2030,"1977-07-12 10:52:40","2018-05-02 05:00:04"),("euismod@idrisus.com","VEW69RXK0ZR","Claire","Marks","(331) 486-5816","Media Relations",NULL,"ANALYST","N",NULL,"1961-06-25 02:19:52","2019-08-05 21:41:04"),("lorem.eget@mi.com","TJS64CAK1KR","Geoffrey","Mcdaniel","(947) 647-8060","Quality Assurance",NULL,NULL,NULL,2021,"1965-08-24 11:42:18","2019-06-04 15:08:26"),("Quisque.ornare@Sed.org","MSX08VCK5SS","Madison","Walter","(470) 744-6884","Legal Department","Y",NULL,NULL,NULL,"1975-05-28 18:15:40","2019-03-02 03:12:00"),("torquent.per@Proin.org","UOC75WEW4GD","Meghan","Knowles","(995) 418-8093","Customer Service",NULL,"INSTRUCTOR","N",NULL,"1955-04-10 12:45:10","2018-09-21 22:00:33"),("morbi.tristique@luctusfelis.com","NIF04EBA2IK","Maryam","Buchanan","(236) 656-0975","Legal Department",NULL,NULL,NULL,2018,"1970-11-21 05:52:04","2019-01-21 15:50:07"),("lobortis.quis@lobortis.com","MXL98HBU8ZX","Roanna","Webster","(507) 889-3935","Finances","Y",NULL,NULL,NULL,"1994-09-05 03:53:26","2019-07-22 05:05:56"),("imperdiet@pedeCrasvulputate.com","OIP94CGY5XT","Germane","Bond","(981) 837-3873","Customer Service",NULL,"SUPPORT STAFF","Y",NULL,"1977-12-01 09:11:16","2019-05-27 12:13:38"),("tristique@SednequeSed.com","TMV03KFI7SH","Margaret","Frye","(994) 277-3587","Customer Relations",NULL,"OFFICER","N",NULL,"1964-09-01 08:27:10","2018-11-02 08:41:03"),("netus@Duisami.co.uk","OXS75DNJ1TS","Giselle","Lott","(769) 799-9255","Accounting",NULL,NULL,NULL,2027,"1950-04-25 11:25:58","2019-05-31 23:46:51");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("fringilla.ornare@eros.com","BIW25NOH5AX","Melyssa","Henry","(160) 365-2738","Quality Assurance","N",NULL,NULL,NULL,"1991-05-15 05:36:49","2019-03-04 16:31:57"),("diam@Cras.org","YVD49CVM4XL","Claire","Hodges","(243) 768-2391","Accounting",NULL,NULL,NULL,2028,"1997-07-30 14:04:48","2019-12-18 02:30:04"),("volutpat@Ut.co.uk","FRV03XXL6DW","Shellie","Crawford","(656) 592-8031","Finances",NULL,NULL,NULL,2028,"1999-05-22 05:20:44","2018-11-02 06:33:04"),("sagittis.Nullam.vitae@rhoncusProin.co.uk","ITQ01XEX1NI","Lewis","Johns","(971) 130-6151","Tech Support","N",NULL,NULL,NULL,"1958-04-03 04:58:08","2019-11-18 10:12:38"),("eget.varius@blandit.edu","ZUN67MBO7MY","Bethany","Battle","(155) 174-5403","Legal Department","Y",NULL,NULL,NULL,"1993-03-04 13:36:56","2020-01-21 05:34:53"),("ut.erat@facilisisvitaeorci.ca","YBP67DNC2KT","Aubrey","Larson","(206) 827-5760","Accounting",NULL,"ADJUNCT","N",NULL,"1983-12-01 13:12:07","2018-09-11 06:31:09"),("dui@nibh.org","CUT99RER5VG","Kieran","Cherry","(872) 236-3329","Customer Relations",NULL,"INSTRUCTOR","Y",NULL,"1954-06-03 01:32:05","2018-09-22 00:21:22"),("vulputate.eu.odio@dolordapibusgravida.org","IIR55OCR6IP","Laith","Walton","(752) 884-8120","Finances","N",NULL,NULL,NULL,"2004-05-07 20:49:07","2018-11-13 19:22:44"),("pulvinar@a.net","AVE69EFR2QJ","Chester","Harper","(730) 941-1392","Quality Assurance","N",NULL,NULL,NULL,"1981-02-04 17:40:11","2018-05-05 05:37:22"),("nunc.In.at@lobortisultrices.net","LCU07XAJ5EX","Robert","House","(429) 117-3833","Sales and Marketing",NULL,"INSTRUCTOR","N",NULL,"1953-05-02 13:51:54","2020-03-17 12:47:06");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("consectetuer.ipsum.nunc@purusNullam.com","NIC51LDT3BT","Paki","Trujillo","(408) 632-4082","Asset Management",NULL,"CUSTODIAL","N",NULL,"1964-11-25 03:34:20","2018-07-19 21:53:30"),("parturient.montes.nascetur@mauris.net","DXZ52RKU2SW","Quemby","Barr","(998) 153-9125","Asset Management",NULL,NULL,NULL,2020,"1972-01-15 08:12:58","2020-01-01 11:08:58"),("magnis@quispedePraesent.edu","FFD96RMI9SG","Wylie","Alston","(516) 342-0151","Legal Department",NULL,NULL,NULL,2020,"1998-01-09 02:33:54","2019-07-11 19:14:39"),("faucibus.ut.nulla@Curabitur.com","GIE11KCM9CR","Madison","Griffith","(339) 465-7843","Payroll",NULL,NULL,NULL,2028,"1982-05-02 13:10:55","2018-10-12 17:34:09"),("a.dui@uteratSed.edu","FYH08UEV7SA","Mallory","Mccullough","(600) 489-0906","Research and Development",NULL,NULL,NULL,2022,"1998-07-25 02:44:20","2019-12-27 09:52:35"),("semper.egestas@acfacilisis.net","VGU87YWW9CB","Ishmael","Bennett","(669) 926-6969","Accounting",NULL,NULL,NULL,2030,"1977-05-28 22:34:06","2019-02-04 03:57:14"),("euismod.ac@orci.net","HID31XDE4NK","Cullen","Cote","(957) 764-1339","Media Relations",NULL,"COACH","Y",NULL,"1982-10-15 21:22:38","2019-03-06 20:23:32"),("commodo.hendrerit.Donec@Loremipsumdolor.edu","WYG20ERS1SX","Brennan","Price","(521) 285-3684","Research and Development",NULL,"LIBRARIAN","N",NULL,"1977-02-15 11:26:01","2018-12-10 04:04:00"),("ultrices.Duis.volutpat@acurnaUt.com","ELQ40CYR7XM","Hayfa","Day","(967) 725-6431","Research and Development",NULL,NULL,NULL,2022,"1950-12-20 15:24:27","2019-12-04 02:35:37"),("in.felis.Nulla@Ut.com","VMI47HDY9PX","Calvin","Navarro","(110) 241-9713","Legal Department",NULL,NULL,NULL,2023,"1963-08-11 01:37:10","2018-11-22 04:18:15");
INSERT INTO `Users` (`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`) VALUES ("nunc.nulla.vulputate@Donecporttitortellus.com","YDP44DWT3KM","Nadine","Reynolds","(939) 418-8384","Asset Management",NULL,NULL,NULL,2019,"1996-09-04 20:26:57","2018-07-14 05:02:58"),("ipsum.nunc@acmattisornare.com","PQO51FEO4NV","Hedwig","Orr","(770) 825-4347","Asset Management",NULL,"ANALYST","Y",NULL,"1954-10-27 15:19:17","2018-04-18 21:18:13"),("magna@Aliquam.co.uk","NTZ40YNQ0VL","Tad","Watkins","(773) 255-9474","Media Relations","N","SUPPORT STAFF","N",NULL,"1969-01-28 13:41:33","2018-09-11 05:24:51"),("Cum.sociis.natoque@rutrumurna.net","EWD47SLK5VB","Tarik","Shelton","(466) 789-1784","Payroll","Y",NULL,NULL,NULL,"1970-03-05 12:40:36","2018-08-02 11:13:35"),("nisi.magna.sed@massaInteger.org","PHC62IDX0WL","Ferris","Chandler","(718) 644-2587","Research and Development",NULL,"ADVISOR","Y",NULL,"1996-10-31 20:41:43","2018-08-14 06:17:59"),("erat.Vivamus@cubilia.net","GND12RXQ8LE","Callie","Vega","(311) 372-7592","Sales and Marketing","Y",NULL,NULL,NULL,"1962-06-10 02:08:02","2018-12-30 06:41:51"),("auctor.velit.eget@urnanecluctus.ca","DMG57FJV3UD","Nasim","Nelson","(567) 806-3356","Media Relations",NULL,"INSTRUCTOR","Y",NULL,"1975-10-10 17:36:02","2020-02-13 04:58:55"),("interdum.ligula.eu@adipiscingnonluctus.co.uk","LKM42EAM6SY","Diana","Oconnor","(408) 342-4528","Research and Development",NULL,NULL,NULL,2018,"1962-04-17 04:54:58","2019-06-27 11:09:42"),("mi.eleifend.egestas@Loremipsum.co.uk","CLJ59GRY9AC","Malachi","Hudson","(160) 245-3120","Human Resources",NULL,NULL,NULL,2019,"1960-07-25 20:15:28","2019-03-01 11:47:24"),("enim@primis.ca","MJD52ERJ3FT","Jescie","Hickman","(421) 377-0701","Quality Assurance",NULL,"SUPPORT STAFF","N",NULL,"1971-05-02 03:34:57","2018-10-14 10:18:37");

-- Insert test data into Drivers
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1680110872499","2019-09-09",1,"Y"),("1679102924799","2019-12-05",2,"N"),("1691061242399","2019-02-05",3,"Y"),("1623091978899","2020-04-05",4,"Y"),("1696051704799","2018-05-19",5,"Y"),("1639021175699","2018-05-04",6,"Y"),("1677081970699","2018-04-28",7,"Y"),("1619041632499","2018-07-09",8,"Y"),("1650052607099","2020-01-23",9,"Y"),("1621063013099","2019-01-09",10,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1609120875199","2018-08-29",11,"Y"),("1643073041699","2018-11-18",12,"Y"),("1649042402199","2019-09-22",13,"Y"),("1678032881999","2019-01-12",14,"Y"),("1606090356299","2019-04-04",15,"Y"),("1663041018099","2020-01-28",16,"Y"),("1617122277599","2018-12-19",17,"Y"),("1633112024599","2019-10-14",18,"Y"),("1621101647499","2019-02-15",19,"Y"),("1618072518399","2018-06-03",20,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1614092509099","2018-06-25",21,"Y"),("1615101466799","2018-06-30",22,"Y"),("1672050323299","2019-04-01",23,"Y"),("1673110936099","2019-12-15",24,"Y"),("1663012619099","2019-11-01",25,"Y"),("1630031356699","2018-09-06",26,"Y"),("1616122136699","2018-10-06",27,"Y"),("1617071339499","2018-09-17",28,"Y"),("1643010889999","2018-08-30",29,"Y"),("1673030624799","2020-01-24",30,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1613031021899","2019-07-17",31,"Y"),("1605080535699","2019-10-03",32,"Y"),("1606040637299","2018-06-12",33,"Y"),("1604030579299","2019-10-28",34,"Y"),("1635062943699","2018-08-21",35,"Y"),("1697082912499","2019-07-22",36,"Y"),("1634021561399","2019-03-18",37,"Y"),("1632082084799","2019-12-05",38,"Y"),("1657092294499","2020-01-10",39,"Y"),("1691043084499","2019-10-08",40,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1627072645899","2019-03-24",41,"N"),("1644012776999","2019-09-14",42,"N"),("1685052562599","2019-04-08",43,"N"),("1629010687399","2018-05-02",44,"N"),("1626090770599","2020-02-27",45,"N"),("1692112722499","2018-09-21",46,"N"),("1669010807899","2020-02-18",47,"N"),("1680101053299","2019-10-14",48,"N"),("1692120651099","2018-10-02",49,"N"),("1683061923499","2018-06-27",50,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1693011728699","2018-07-03",51,"N"),("1685062951299","2018-11-18",52,"N"),("1665100187099","2019-06-30",53,"N"),("1647110613199","2019-10-07",54,"N"),("1661032492999","2019-08-11",55,"N"),("1611042509499","2019-02-13",56,"N"),("1607010237399","2019-02-23",57,"N"),("1675090310099","2019-09-19",58,"N"),("1650102379599","2019-04-24",59,"N"),("1668041491099","2019-05-08",60,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1638122548699","2019-10-06",61,"N"),("1663073034099","2019-07-16",62,"N"),("1677090492099","2019-09-15",63,"N"),("1685051819399","2018-12-12",64,"N"),("1696020797199","2019-05-14",65,"N"),("1656072269699","2020-01-15",66,"N"),("1664062386099","2018-06-30",67,"N"),("1685061862799","2019-11-11",68,"N"),("1647101170399","2019-02-13",69,"N"),("1608022908399","2019-03-15",70,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1600080689999","2020-02-09",71,"N"),("1616122928399","2018-04-25",72,"N"),("1605012627999","2020-03-30",73,"N"),("1636121519199","2018-08-01",74,"N"),("1669070963599","2019-11-22",75,"N"),("1630020759199","2019-07-30",76,"N"),("1644080993499","2020-01-15",77,"N"),("1661101170899","2018-07-07",78,"N"),("1629051698599","2019-09-01",79,"N"),("1665042290299","2018-10-30",80,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1620012400999","2019-05-05",81,"N"),("1675080132699","2019-05-25",82,"N"),("1669012802599","2019-08-14",83,"N"),("1656042154799","2019-11-11",84,"N"),("1622102936699","2020-01-18",85,"N"),("1619122193099","2020-01-02",86,"N"),("1677092883299","2019-10-06",87,"N"),("1628051843299","2020-03-27",88,"N"),("1627100259399","2018-09-02",89,"N"),("1660101994699","2019-09-11",90,"N");
INSERT INTO `Drivers` (`licenseNumber`,`dateHired`,`person_id`,`isAvailable`) VALUES ("1614032921899","2018-09-17",91,"N"),("1692082462899","2018-09-12",92,"N"),("1671032700099","2018-09-08",93,"N"),("1609050414099","2020-02-19",94,"N"),("1664111490899","2019-01-19",95,"N"),("1689072980799","2019-04-27",96,"N"),("1696121518399","2018-04-23",97,"N"),("1612051355999","2018-12-24",98,"N"),("1625042282899","2019-02-04",99,"N"),("1607010597699","2019-01-26",100,"N");
-- Insert test data into Carts
INSERT INTO `Carts` (`cartId`,`make`,`model`,`numSeats`,`isAvailable`) VALUES (1,"Nissan","Precedent Gas",3, "Y"),(2,"Seat","Precedent Electric",3, "N"),(3,"Mahindra and Mahindra","DS Gas",2, "Y"),(4,"Volvo","DS Electric",2, "Y"),(5,"RAM Trucks","Precedent Gas",3, "N"),(6,"FAW","Precedent Electric",3, "N"),(7,"Infiniti","DS Electric",3, "N"),(8,"Mercedes-Benz","DS Gas",2, "Y");
-- Insert test data into Location
INSERT INTO `Location` (`locationId`,`locationName`,`locationAddress`) VALUES (3,"Winningham","P.O. Box 329, 1535 In Rd."),(4,"Duke Centennial Hall","632-9923 Tortor Road"),(5,"Fretwell","P.O. Box 827, 2697 Maecenas Street"),(10,"Friday","854-3519 Dapibus Av.");
INSERT INTO `Location` (`LocationId`,`locationName`,`LocationAddress`) VALUES (11,"Health and Human Services","9318 Vel, Rd."),(13,"Rowe","Ap #996-3883 Non Av."),(14,"Witherspoon Hall","Ap #297-7025 Dolor Avenue");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (23,"Cameron Hall","2192 Imperdiet Rd."),(24,"McEniry","P.O. Box 606, 5285 Nunc, Avenue"),(27,"Sanford Hall","Ap #776-3371 Vel, Road"),(29,"Hickory Hall","869-3749 Lacus Road");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (32,"Garinger","8778 Eu St."),(33,"Kulwicki Laboratory","305-6833 Massa. Avenue"),(37,"Denny","208-3712 Diam. Ave"),(39,"Colvard","241-2228 Gravida Ave");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (41,"Woodward Hall","P.O. Box 575, 2364 Sit Road"),(44,"Facilities Operations","3690 Etiam Rd."),(46,"Facilities Management","Ap #158-3528 Ac St."),(47,"Police","7771 Eu St.");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (51,"Wallis Hall","P.O. Box 252, 1035 Dis St."),(55,"Cedar Hall","Ap #639-106 Integer Road"),(49,"Cato College of Education","950-1800 Tortor Ave");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (61,"Greek Village","2210 Felis Av."),(66,"Maple Hall","P.O. Box 481, 2853 Neque. Avenue"),(40,"Holshouser Hall","Ap #516-1430 Aliquam Rd.");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (71,"Smith","983-7149 Ut Street"),(75,"PORTAL","885-3197 Laoreet, Avenue"),(88,"Parking Services","2006 Metus. Ave"),(90,"Barnard","P.O. Box 316, 5873 Facilisis Street");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (82,"Belk Hall","552-9906 Adipiscing St."),(83,"Martin Village","424-6678 Molestie Street"),(86,"Student Counseling Center ","P.O. Box 270, 8120 Sed Rd.");
INSERT INTO `Location` (`LocationId`,`LocationName`,`LocationAddress`) VALUES (97,"Sycamore Hall","P.O. Box 902, 3710 Interdum Road"),(98,"Levine Hall","P.O. Box 765, 9529 Nisi Rd.");
-- Insert test data into Ride
INSERT INTO `Ride` (`driverId`,`assignedCartId`,`riderId`,`startLocationId`,`endLocationId`,`startTime`) VALUES (10,7,41,4,13,"2019-01-10 22:46:00"), (13,2,17,44,32,"2019-02-04 08:24:41"), (16,5,53,23,97,"2019-01-31 05:32:39"), (19,3,81,86,4,"2019-06-30 13:48:22"), (22,8,72,5,88,"2019-07-30 12:07:03"), (34,6,39,86,47,"2019-02-21 01:40:58");
-- Resets Foreign Key contraints after test data insert
SET FOREIGN_KEY_CHECKS=1;

-- Views --

-- Pulls available cart data
CREATE OR REPLACE VIEW avaiableCarts AS
	SELECT * FROM Carts WHERE isAvailable = "Y";
    
-- Pulls available driver data
CREATE OR REPLACE VIEW availableDrivers AS
	SELECT person_Id AS driverId FROM Drivers WHERE isAvailable = "Y";
    
-- Pulls location Names from location and matches with locationId in Ride for user readability
CREATE OR REPLACE VIEW locationNames AS
SELECT DISTINCT aLocationID, startLocationName, bLocationID, endLocationName FROM 
(SELECT rideId, locationId AS aLocationId, locationName AS startLocationName 
FROM Location a, Ride b
WHERE a.locationId = b.startLocationId) a
JOIN
(SELECT rideID, locationId AS bLocationId, locationName AS endLocationName 
FROM Location a, Ride b
WHERE a.locationId = b.endLocationId) b
ON a.rideID = b.rideID;
-- SELECT * FROM locationNames;

-- Pulls User/Ride data from the Users table joined with Ride, joined with view- locationNames in order to make the rides more readable/recognizable by user  
CREATE OR REPLACE VIEW view_userRide 	
AS SELECT DISTINCT A.rideID, A.first_name, A.last_name, B.startLocationName, B.endLocationName, A.startTime FROM
(SELECT *       
FROM Users a, Ride b
WHERE a.person_id=b.riderId) A
JOIN
(SELECT * FROM locationNames) B
ON A.startLocationId = B.AlocationId OR A.endLocationId = B.blocationID;

-- Pulls Driver/Ride data from Users table joined with Ride
CREATE OR REPLACE VIEW view_driverRide AS
SELECT A.rideID, A.driverId, B.startLocationName, B.endLocationName, A.startTime FROM
(SELECT *       
FROM Drivers a, Ride b
WHERE a.person_id=b.driverId) A
JOIN
(SELECT * FROM locationNames) B
ON A.startLocationId = B.AlocationId OR A.endLocationId = B.blocationID;

-- Create DB Users
-- Creates Admin user with with All rights and grant access
DROP USER IF EXISTS backNinesadmin@localhost;
    CREATE USER backNinesadmin@localhost IDENTIFIED BY 'admin';
    
    GRANT ALL
    ON BackNinesDB.*
    TO backNinesadmin@localhost
	WITH GRANT OPTION;
 
 -- Creates Driver user with limited access to tables 
 DROP USER IF EXISTS driver@localhost;
 CREATE USER driver@localhost IDENTIFIED BY 'driver';
    
	GRANT SELECT, INSERT, UPDATE
    ON BackNinesDB.Drivers
    TO driver@localhost;
    
    GRANT SELECT, INSERT, UPDATE
    ON BackNinesDB.Users
    TO driver@localhost;
    
    GRANT SELECT
    ON BackNinesDB.Carts
    TO driver@localhost;
    
    GRANT SELECT
    ON BackNinesDB.view_driverRide
    TO driver@localhost;
    
    GRANT SELECT
    ON BackNinesDB.locationNames
    TO driver@localhost;
    
-- Creates Users user with limited access to tables 
 DROP USER IF EXISTS users@localhost;
 CREATE USER users@localhost IDENTIFIED BY 'users';
    
	GRANT SELECT, INSERT, UPDATE
    ON BackNinesDB.Users
    TO users@localhost;
    
    GRANT SELECT, Update
    ON BackNinesDB.Carts
    TO users@localhost;
    
	GRANT SELECT, UPDATE
    ON BackNinesDB.Drivers
    TO users@localhost;
    
    GRANT SELECT
    ON BackNinesDB.view_userRide
    TO users@localhost;
    
    GRANT SELECT
    ON BackNinesDB.locationNames
    TO users@localhost; 


-- Procedures --

-- Creates Procedure to register new users 
DROP PROCEDURE IF EXISTS registerUser;
DELIMITER //
CREATE PROCEDURE registerUser (
IN email VARCHAR(255),
IN user_password VARCHAR(32),
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN cell VARCHAR(15),
IN deptName VARCHAR(45),
IN fulltimeYorN VARCHAR(4),
IN positionName VARCHAR(45),
IN adminYorN VARCHAR(4),
IN gradYear VARCHAR(4),
IN birdate DATETIME,
IN create_time DATETIME)
BEGIN
DECLARE person_id SMALLINT;
IF person_id IS NULL
THEN 
INSERT INTO Users
VALUES (`person_id`,`email`,`user_password`,`first_name`,`last_name`,`cell`,`deptName`,`fulltimeYorN`,`positionName`,`adminYorN`,`gradYear`,`birthDate`,`create_time`);
END IF;
END //
DELIMITER ;

-- Example of stored procedure use:
call registerUser ("sed@egestas.co.uk","FVV81ANT3YK","Kamal","Kinney","(240) 154-9684","Tech Support",NULL,NULL,NULL,2022,"1974-02-11 05:44:19","2020-03-21 17:51:35");
call registerUser ("Curabitur.vel@nuncQuisqueornare.com","LJM56KEB2MI","Kato","Lewis","(545) 496-4276","Sales and Marketing",NULL,"COACH","Y",NULL,"1961-03-22 04:17:54","2019-10-06 10:28:36");
call registerUser ("nunc.interdum.feugiat@et.org","UUJ49UWH8BM","Cassidy","Ramos","(568) 421-0175","Legal Department","Y",NULL,NULL,NULL,"1971-03-31 07:39:57","2019-06-19 07:57:11");
-- SELECT * FROM Users;

-- Creates procedure which schedules a ride
DROP PROCEDURE IF EXISTS createRide;
DELIMITER //
CREATE PROCEDURE createRide (
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN email VARCHAR(255),
IN cell VARCHAR(15),
IN startLocationName VARCHAR(255),
IN endLocationName VARCHAR(255),
IN StartTime DATETIME)
BEGIN
DECLARE rideId SMALLINT;
DECLARE riderId SMALLINT;
DECLARE startLocationId SMALLINT;
DECLARE endLocationId SMALLINT;
DECLARE driverId SMALLINT;
DECLARE assignedCartId SMALLINT(1);
IF rideId IS NULL
THEN 
SELECT cartId INTO assignedCartId FROM Carts WHERE isAvailable = "Y" LIMIT 1;
SELECT person_id INTO driverId FROM Drivers WHERE isAvailable = "Y" LIMIT 1;
SELECT person_id INTO riderId FROM Users WHERE first_name = Users.first_name AND last_name = Users.last_name AND email = Users.email;
SELECT LocationId INTO startLocationId FROM Location WHERE startLocationName = Location.LocationName;
SELECT LocationId INTO endLocationId FROM Location WHERE endLocationName = Location.LocationName;
INSERT INTO Ride
VALUES (`rideId`, `assignedCartId`, `driverId`,`riderId`, `startLocationId`, `endLocationId`, `startTime`);
END IF;
END //
DELIMITER ; 

-- Finds all rides scheduled for a user                      
DROP PROCEDURE IF EXISTS finduserRide;
DELIMITER //
CREATE PROCEDURE finduserRide (
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN email VARCHAR(255),
IN user_password VARCHAR(32))
BEGIN
IF user_password IN (SELECT user_password FROM Users WHERE first_name = first_name AND last_name = last_name AND email = email)
THEN
SELECT DISTINCT rideID, first_name, last_name, startLocationName, endLocationName, startTime 
FROM view_userRide 
WHERE rideID IN(SELECT rideId FROM view_userRide WHERE  first_name = view_userRide.first_name AND  last_name = view_userRide.last_name);
END IF;
END //
DELIMITER ;

-- Creates Procedure to update/alter a ride with new startlocation, endlocation, and/or start time
DROP PROCEDURE IF EXISTS updateRide;
DELIMITER //
CREATE PROCEDURE updateRide (
IN rideID SMALLINT,
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN startLocationName VARCHAR(255),
IN endLocationName VARCHAR(255),
IN startTime DATETIME)
BEGIN
IF rideID IN (SELECT rideId FROM view_userRide)
THEN
UPDATE Ride 
SET
startLocationID = (SELECT locationId FROM location WHERE startlocationName = location.locationName),
endLocationID = (SELECT locationId FROM location WHERE endlocationName = location.locationName),
startTime = startTime
WHERE rideId = Ride.rideId;
END IF;
END //
DELIMITER ;

-- Creates procedure which deletes a ride when user needs to cancel
DROP PROCEDURE IF EXISTS deleteRide;
DELIMITER //
CREATE PROCEDURE deleteRide (
IN rideID SMALLINT,
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN startLocationName VARCHAR(255),
IN endLocationName VARCHAR(255),
IN startTime DATETIME)
BEGIN
IF rideID IN (SELECT rideId FROM view_userRide)
THEN
DELETE FROM Ride WHERE rideId = Ride.rideId;
END IF;
END //
DELIMITER ;

-- Deletes users (for admin use only)
DROP PROCEDURE IF EXISTS deleteUser;
DELIMITER //
CREATE PROCEDURE deleteUser (
IN person_id SMALLINT,
IN email VARCHAR(255),
IN user_password VARCHAR(32),
IN first_name VARCHAR(45),
IN last_name VARCHAR(45),
IN cell VARCHAR(15),
IN deptName VARCHAR(45),
IN fulltimeYorN VARCHAR(4),
IN positionName VARCHAR(45),
IN adminYorN VARCHAR(4),
IN gradYear VARCHAR(4),
IN birdate DATETIME,
IN create_time DATETIME)
BEGIN
IF person_id IN (SELECT person_id FROM Users WHERE first_name = Users.first_name) 
THEN 
DELETE FROM Users WHERE person_id = Users.person_id;
END IF;
END //
DELIMITER ;

