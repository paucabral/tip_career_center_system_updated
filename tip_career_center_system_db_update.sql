-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tip_career_center_system_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tip_career_center_system_db` ;

-- -----------------------------------------------------
-- Schema tip_career_center_system_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tip_career_center_system_db` DEFAULT CHARACTER SET utf8 ;
USE `tip_career_center_system_db` ;

-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Level_of_engagement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Level_of_engagement` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Level_of_engagement` (
  `level_of_engagement_id` INT NOT NULL AUTO_INCREMENT,
  `level_of_engagement_name` VARCHAR(45) NULL,
  `level_of_engagement_required_score` INT NULL,
  PRIMARY KEY (`level_of_engagement_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Industry_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Industry_Type` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Industry_Type` (
  `industry_type_id` INT NOT NULL AUTO_INCREMENT,
  `industry_type_name` VARCHAR(100) NULL,
  PRIMARY KEY (`industry_type_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`activity_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`activity_log` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`activity_log` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(20) NULL,
  `activity_name` VARCHAR(15) NULL,
  `dateTimeOccurred` datetime NULL,
  `user` VARCHAR(50) NULL,
  PRIMARY KEY (`activity_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Company` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Company` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `company_name` VARCHAR(45) NULL,
  `company_engagement_score` INT NULL,
  `company_address` VARCHAR(100) NULL,
  `Level_of_engagement_level_of_engagement_id` INT NULL,
  `Industry_Type_industry_type_id` INT NOT NULL,
  `profile_image` VARCHAR(100) NULL,
  `banner_image` VARCHAR(100) NULL,
  `company_attachment` VARCHAR(100) NULL,
  PRIMARY KEY (`company_id`),
  CONSTRAINT `fk_Company_Level_of_engagement1`
    FOREIGN KEY (`Level_of_engagement_level_of_engagement_id`)
    REFERENCES `tip_career_center_system_db`.`Level_of_engagement` (`level_of_engagement_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Company_Industry_Type1`
    FOREIGN KEY (`Industry_Type_industry_type_id`)
    REFERENCES `tip_career_center_system_db`.`Industry_Type` (`industry_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Activity` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Activity` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `activity_name` VARCHAR(45) NULL,
  PRIMARY KEY (`activity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Company_has_Activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Company_has_Activity` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Company_has_Activity` (
  `Company_company_id` INT NOT NULL,
  `Activity_activity_id` INT NOT NULL,
  `quantity` INT NULL,
  CONSTRAINT `fk_Company_has_Activity_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Company_has_Activity_Activity1`
    FOREIGN KEY (`Activity_activity_id`)
    REFERENCES `tip_career_center_system_db`.`Activity` (`activity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Intership`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Intership` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Intership` (
  `internship_id` INT NOT NULL AUTO_INCREMENT,
  `internship_student_name` VARCHAR(45) NULL,
  `intership_program` VARCHAR(45) NULL,
  `intership_school_year` VARCHAR(45) NULL,
  `internship_semester` VARCHAR(45) NULL,
  `Company_company_id` INT NOT NULL,
  `internship_date_added` DATE NULL,
  PRIMARY KEY (`internship_id`),
  CONSTRAINT `fk_Intership_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Externship`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Externship` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Externship` (
  `externship_id` INT NOT NULL AUTO_INCREMENT,
  `externship_student_name` VARCHAR(45) NULL,
  `externship_program` VARCHAR(45) NULL,
  `externship_school_year` VARCHAR(45) NULL,
  `externship_semester` VARCHAR(45) NULL,
  `Company_company_id` INT NOT NULL,
  `externship_date_added` DATE NULL,
  PRIMARY KEY (`externship_id`),
  CONSTRAINT `fk_Externship_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Scholarship`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Scholarship` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Scholarship` (
  `scholarship_id` INT NOT NULL AUTO_INCREMENT,
  `scholarship_student_name` VARCHAR(45) NULL,
  `sholarship_program` VARCHAR(45) NULL,
  `scholarship_school_year` VARCHAR(45) NULL,
  `scholarship_semester` VARCHAR(45) NULL,
  `scholarship_amount` FLOAT NULL,
  `Company_company_id` INT NOT NULL,
  `scholarship_date_added` DATE NULL,
  PRIMARY KEY (`scholarship_id`),
  CONSTRAINT `fk_Scholarship_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Career_Fair`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Career_Fair` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Career_Fair` (
  `career_fair_id` INT NOT NULL AUTO_INCREMENT,
  `career_fair_title` VARCHAR(45) NULL,
  `career_fair_date` DATE NULL,
  `career_fair_participants` INT NULL,
  `career_fair_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `career_fair_date_added` DATE NULL,
  PRIMARY KEY (`career_fair_id`),
  CONSTRAINT `fk_Career_Fair_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`On_Campus_Recruitment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`On_Campus_Recruitment` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`On_Campus_Recruitment` (
  `on_campus_recruitment_id` INT NOT NULL AUTO_INCREMENT,
  `on_campus_recruitment_name` VARCHAR(45) NULL,
  `on_campus_recruitment_date` DATE NULL,
  `on_campus_recruitment_participants` INT NULL,
  `on_campus_recruitment_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `on_campus_recruitment_date_added` DATE NULL,
  PRIMARY KEY (`on_campus_recruitment_id`),
  CONSTRAINT `fk_On_Campus_Recruitment_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`career_development_training`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`career_development_training` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`career_development_training` (
  `career_development_training_id` INT NOT NULL AUTO_INCREMENT,
  `career_development_training_name` VARCHAR(45) NULL,
  `career_development_training_date` DATE NULL,
  `career_development_training_participants` INT NULL,
  `career_development_training_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `career_development_training_date_added` DATE NULL,
  PRIMARY KEY (`career_development_training_id`),
  CONSTRAINT `fk_career_development_training_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`mock_job_interview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`mock_job_interview` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`mock_job_interview` (
  `mock_job_interview_id` INT NOT NULL AUTO_INCREMENT,
  `mock_job_interview_date` DATE NULL,
  `mock_job_interview_participants` INT NULL,
  `Company_company_id` INT NOT NULL,
  `mock_job_interviewcol_date_added` DATE NULL,
  PRIMARY KEY (`mock_job_interview_id`),
  CONSTRAINT `fk_mock_job_interview_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Contact_Person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Contact_Person` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Contact_Person` (
  `contact_person_id` INT NOT NULL AUTO_INCREMENT,
  `contact_person_fname` VARCHAR(45) NULL,
  `contact_person_lname` VARCHAR(45) NULL,
  `contact_person_email` VARCHAR(45) NULL,
  `contact_person_no` VARCHAR(20) NULL,
  `contact_person_priority` ENUM('PRIMARY', 'SECONDARY') NULL,
  `Company_company_id` INT NOT NULL,
  `contact_person_position` VARCHAR(45) NULL,
  PRIMARY KEY (`contact_person_id`),
  CONSTRAINT `fk_Contact_Person_Company1`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Data for table `tip_career_center_system_db`.`industry_type`
-- -----------------------------------------------------
START TRANSACTION;
USE `tip_career_center_system_db`;

INSERT INTO `tip_career_center_system_db`.`level_of_engagement` VALUES(1,'Confederate Partner',5);
INSERT INTO `tip_career_center_system_db`.`level_of_engagement` VALUES(2,'Associate Partner',26);
INSERT INTO `tip_career_center_system_db`.`level_of_engagement` VALUES(3,'Executive Partner',47);


INSERT INTO `tip_career_center_system_db`.`activity` VALUES(1,'Internship');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(2,'Externship');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(3,'Scholarship');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(4,'Career Fair');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(5,'On-Campus Recruitment');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(6,'Career Development Training');
INSERT INTO `tip_career_center_system_db`.`activity` VALUES(7,'Mock Job Interview');


INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (1, 'Agricultural Production-Crops');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (2, 'Agricultural Prod-Livestock  Animal Specialties');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (3, 'Agricultural Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (4, 'Forestry');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (5, 'Fishing Hunting and Trapping');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (6, 'Metal Mining');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (7, 'Gold and Silver Ores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (8, 'Miscellaneous Metal Ores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (9, 'Bituminous Coal  Lignite Mining');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (10, 'Bituminous Coal  Lignite Surface Mining');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (11, 'Crude Petroleum  Natural Gas');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (12, 'Drilling Oil  Gas Wells');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (13, 'Oil  Gas Field Exploration Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (14, 'Oil  Gas Field Services NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (15, 'Mining  Quarrying of Nonmetallic Minerals (No Fuels)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (16, 'General Bldg Contractors - Residential Bldgs');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (17, 'Operative Builders');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (18, 'General Bldg Contractors - Nonresidential Bldgs');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (19, 'Heavy Construction Other Than Bldg Const - Contractors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (20, 'Water Sewer Pipeline Comm  Power Line Construction');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (21, 'Heavy Construction Not Elsewhere Classified [8]');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (22, 'Construction - Special Trade Contractors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (23, 'Electrical Work');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (24, 'Food and Kindred Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (25, 'Meat Packing Plants');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (26, 'Sausages  Other Prepared Meat Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (27, 'Poultry Slaughtering and Processing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (28, 'Dairy Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (29, 'Ice Cream  Frozen Desserts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (30, 'Canned Frozen  Preserved Fruit Veg  Food Specialties');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (31, 'Canned Fruits Veg Preserves Jams  Jellies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (32, 'Grain Mill Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (33, 'Bakery Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (34, 'Cookies  Crackers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (35, 'Sugar  Confectionery Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (37, 'Fats  Oils');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (38, 'Beverages');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (39, 'Malt Beverages');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (40, 'Bottled  Canned Soft Drinks  Carbonated Waters');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (41, 'Miscellaneous Food Preparations  Kindred Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (42, 'Prepared Fresh or Frozen Fish  Seafood');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (43, 'Tobacco Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (44, 'Cigarettes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (45, 'Textile Mill Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (46, 'Broadwoven Fabric Mills Cotton');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (47, 'Broadwoven Fabric Mills Man Made Fiber  Silk');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (48, 'Knitting Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (49, 'Knit Outerwear Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (50, 'Carpets  Rugs');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (51, 'Apparel  Other Finished Prods of Fabrics  Similar Matl');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (52, 'Men\'s  Boys\' Furnishings Work Clothing  Allied Garments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (53, 'Women\'s Misses\' and Juniors Outerwear');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (54, 'Women\'s Misses\' Children\'s  Infant\'s Undergarments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (55, 'Miscellaneous Fabricated Textile Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (56, 'Lumber  Wood Products (No Furniture)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (57, 'Sawmills  Planing Mills General');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (58, 'Millwood Veneer Plywood  Structural Wood Members');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (59, 'Mobile Homes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (60, 'Prefabricated Wood Bldgs  Components');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (61, 'Household Furniture');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (62, 'Wood Household Furniture (No Upholstered)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (63, 'Office Furniture');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (64, 'Office Furniture (No Wood)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (65, 'Public Bldg  Related Furniture');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (66, 'Partitions Shelvg Lockers  office  Store Fixtures');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (67, 'Miscellaneous Furniture  Fixtures');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (68, 'Papers  Allied Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (69, 'Pulp Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (70, 'Paper Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (71, 'Paperboard Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (72, 'Paperboard Containers  Boxes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (73, 'Converted Paper  Paperboard Prods (No Containers/Boxes)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (74, 'Plastics Foil  Coated Paper Bags');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (76, 'Newspapers: Publishing or Publishing  Printing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (77, 'Periodicals: Publishing or Publishing  Printing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (78, 'Books: Publishing or Publishing  Printing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (79, 'Book Printing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (80, 'Miscellaneous Publishing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (81, 'Commercial Printing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (82, 'Manifold Business Forms');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (83, 'Greeting Cards');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (84, 'Blankbooks Looseleaf Binders  Bookbinding  Related Work');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (85, 'Service Industries For The Printing Trade');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (86, 'Chemicals  Allied Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (87, 'Industrial Inorganic Chemicals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (88, 'Plastic Material Synth Resin/Rubber Cellulos (No Glass)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (89, 'Plastic Materials Synth Resins  Nonvulcan Elastomers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (90, 'Medicinal Chemicals  Botanical Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (91, 'Pharmaceutical Preparations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (92, 'In Vitro  In Vivo Diagnostic Substances');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (93, 'Biological Products (No Diagnostic Substances)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (94, 'Soap Detergents Cleaning Preparations Perfumes Cosmetics');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (95, 'Specialty Cleaning Polishing and Sanitation Preparations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (96, 'Perfumes Cosmetics  Other Toilet Preparations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (97, 'Paints Varnishes Lacquers Enamels  Allied Prods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (98, 'Industrial Organic Chemicals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (99, 'Agricultural Chemicals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (100, 'Miscellaneous Chemical Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (101, 'Adhesives  Sealants');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (102, 'Petroleum Refining');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (103, 'Asphalt Paving  Roofing Materials');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (104, 'Miscellaneous Products of Petroleum  Coal');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (105, 'Tires  Inner Tubes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (106, 'Rubber  Plastics Footwear');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (107, 'Gaskets Packg  Sealg Devices  Rubber  Plastics Hose');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (108, 'Fabricated Rubber Products NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (109, 'Miscellaneous Plastics Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (110, 'Unsupported Plastics Film  Sheet');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (111, 'Plastics Foam Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (112, 'Plastics Products NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (113, 'Leather  ');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (114, 'Leather Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (115, 'Footwear (No Rubber)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (116, 'Flat Glass');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (117, 'Glass  Glassware Pressed or Blown');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (118, 'Glass Containers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (119, 'Glass Products Made of Purchased Glass');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (120, 'Cement Hydraulic');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (121, 'Structural Clay Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (122, 'Pottery  Related Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (123, 'Concrete Gypsum  Plaster Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (124, 'Concrete Products Except Block  Brick');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (125, 'Cut Stone  Stone Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (126, 'Abrasive Asbestos  Misc Nonmetallic Mineral Prods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (127, 'Steel Works Blast Furnaces  Rolling  Finishing Mills');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (128, 'Steel Works Blast Furnaces  Rolling Mills (Coke Ovens)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (129, 'Steel Pipe  Tubes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (130, 'Iron  Steel Foundries');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (131, 'Primary Smelting  Refining of Nonferrous Metals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (132, 'Primary Production of Aluminum');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (133, 'Secondary Smelting  Refining of Nonferrous Metals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (134, 'Rolling Drawing  Extruding of Nonferrous Metals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (135, 'Drawing  Insulating of Nonferrous Wire');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (136, 'Nonferrous Foundries (Castings)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (137, 'Miscellaneous Primary Metal Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (138, 'Metal Cans');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (139, 'Metal Shipping Barrels Drums Kegs  Pails');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (140, 'Cutlery Handtools  General Hardware');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (141, 'Heating Equip Except Elec  Warm Air;  Plumbing Fixtures');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (142, 'Heating Equipment Except Electric  Warm Air Furnaces');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (143, 'Fabricated Structural Metal Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (144, 'Metal Doors Sash Frames Moldings  Trim');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (145, 'Fabricated Plate Work (Boiler Shops)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (146, 'Sheet Metal Work');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (147, 'Prefabricated Metal Buildings  Components');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (148, 'Screw Machine Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (149, 'Bolts Nuts Screws Rivets  Washers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (150, 'Metal Forgings  Stampings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (151, 'Coating Engraving  Allied Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (152, 'Ordnance  Accessories (No Vehicles/Guided Missiles)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (154, 'Miscellaneous Fabricated Metal Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (155, 'Engines  Turbines');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (156, 'Farm Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (157, 'Lawn  Garden Tractors  Home Lawn  Gardens Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (158, 'Construction Mining  Materials Handling Machinery  Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (159, 'Construction Machinery  Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (160, 'Mining Machinery  Equip (No Oil  Gas Field Mach  Equip)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (161, 'Oil  Gas Field Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (162, 'Industrial Trucks Tractors Trailers  Stackers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (163, 'Metalworkg Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (164, 'Machine Tools Metal Cutting Types');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (165, 'Special Industry Machinery (No Metalworking Machinery)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (166, 'Printing Trades Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (167, 'Special Industry Machinery NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (168, 'General Industrial Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (169, 'Pumps  Pumping Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (170, 'Ball  Roller Bearings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (171, 'Industrial  Commercial Fans  Blowers  Air Purifying Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (172, 'Industrial Process Furnaces  Ovens');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (173, 'General Industrial Machinery  Equipment NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (174, 'Computer  office Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (175, 'Electronic Computers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (176, 'Computer Storage Devices');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (177, 'Computer Terminals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (178, 'Computer Communications Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (179, 'Computer Peripheral Equipment NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (180, 'Calculating  Accounting Machines (No Electronic Computers)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (181, 'Office Machines NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (182, 'Refrigeration  Service Industry Machinery');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (183, 'Air-Cond  Warm Air Heatg Equip  Comm  Indl Refrig Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (184, 'Misc Industrial  Commercial Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (185, 'Electronic  Other Electrical Equipment (No Computer Equip)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (186, 'Power Distribution  Specialty Transformers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (187, 'Switchgear  Switchboard Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (188, 'Electrical Industrial Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (189, 'Motors  Generators');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (190, 'Household Appliances');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (191, 'Electric Housewares  Fans');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (193, 'Electric Lighting  Wiring Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (194, 'Household Audio  Video Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (195, 'Phonograph Records  Prerecorded Audio Tapes  Disks');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (196, 'Telephone  Telegraph Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (197, 'Radio  TV Broadcasting  Communications Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (198, 'Communications Equipment NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (199, 'Electronic Components  Accessories');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (200, 'Printed Circuit Boards');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (201, 'Semiconductors  Related Devices');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (202, 'Electronic Coils Transformers  Other Inductors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (203, 'Electronic Connectors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (204, 'Electronic Components NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (205, 'Miscellaneous Electrical Machinery Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (206, 'Magnetic  Optical Recording Media');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (207, 'Motor Vehicles  Passenger Car Bodies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (208, 'Truck  Bus Bodies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (209, 'Motor Vehicle Parts  Accessories');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (210, 'Truck Trailers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (211, 'Motor Homes');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (212, 'Aircraft  Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (213, 'Aircraft');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (214, 'Aircraft Engines  Engine Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (215, 'Aircraft Parts  Auxiliary Equipment NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (216, 'Ship  Boat Building  Repairing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (217, 'Railroad Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (218, 'Motorcycles Bicycles  Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (219, 'Guided Missiles  Space Vehicles  Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (220, 'Miscellaneous Transportation Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (221, 'Search Detection Navigation Guidance Aeronautical Sys');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (222, 'Laboratory Apparatus  Furniture');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (223, 'Auto Controls For Regulating Residential  Comml Environments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (224, 'Industrial Instruments For Measurement Display and Control');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (225, 'Totalizing Fluid Meters  Counting Devices');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (226, 'Instruments For Meas  Testing of Electricity  Elec Signals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (227, 'Laboratory Analytical Instruments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (228, 'Optical Instruments  Lenses');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (229, 'Measuring  Controlling Devices NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (230, 'Surgical  Medical Instruments  Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (232, 'Orthopedic Prosthetic  Surgical Appliances  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (233, 'Dental Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (234, 'X-Ray Apparatus  Tubes  Related Irradiation Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (235, 'Electromedical  Electrotherapeutic Apparatus');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (236, 'Ophthalmic Goods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (237, 'Photographic Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (238, 'Watches Clocks Clockwork Operated Devices/Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (239, 'Jewelry Silverware  Plated Ware');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (240, 'Jewelry Precious Metal');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (241, 'Musical Instruments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (242, 'Dolls  Stuffed Toys');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (243, 'Games Toys  Children\'s Vehicles (No Dolls  Bicycles)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (244, 'Sporting  Athletic Goods NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (245, 'Pens Pencils  Other Artists\' Materials');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (246, 'Costume Jewelry  Novelties');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (247, 'Miscellaneous Manufacturing Industries');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (248, 'Railroads Line-Haul Operating');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (249, 'Railroad Switching  Terminal Establishments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (250, 'Local  Suburban Transit  Interurban Hwy Passenger Trans');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (251, 'Trucking  Courier Services (No Air)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (252, 'Trucking (No Local)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (253, 'Public Warehousing  Storage');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (254, 'Terminal Maintenance Facilities For Motor Freight Transport');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (255, 'Water Transportation');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (256, 'Deep Sea Foreign Transportation of Freight');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (257, 'Air Transportation Scheduled');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (258, 'Air Courier Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (259, 'Air Transportation Nonscheduled');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (260, 'Airports Flying Fields  Airport Terminal Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (261, 'Pipe Lines (No Natural Gas)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (262, 'Transportation Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (263, 'Arrangement of Transportation of Freight  Cargo');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (264, 'Radiotelephone Communications');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (265, 'Telephone Communications (No Radiotelephone)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (266, 'Telegraph  Other Message Communications');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (267, 'Radio Broadcasting Stations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (268, 'Television Broadcasting Stations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (269, 'Cable  Other Pay Television Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (271, 'Communications Services NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (272, 'Electric Gas  Sanitary Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (273, 'Electric Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (274, 'Natural Gas Transmission');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (275, 'Natural Gas Transmission  Distribution');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (276, 'Natural Gas Distribution');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (277, 'Electric  Other Services Combined');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (278, 'Gas  Other Services Combined');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (279, 'Water Supply');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (280, 'Sanitary Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (281, 'Refuse Systems');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (282, 'Hazardous Waste Management');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (283, 'Steam  Air-Conditioning Supply');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (284, 'Co-generation Services  Small Power Producers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (285, 'Wholesale-Durable Goods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (286, 'Wholesale-Motor Vehicles  Motor Vehicle Parts  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (287, 'Wholesale-Motor Vehicle Supplies  New Parts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (288, 'Wholesale-Furniture  Home Furnishings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (289, 'Wholesale-Lumber  Other Construction Materials');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (290, 'Wholesale-Lumber Plywood millwork  Wood Panels');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (291, 'Wholesale-Professional  Commercial Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (292, 'Wholesale-Computers  Peripheral Equipment  Software');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (293, 'Wholesale-Medical Dental  Hospital Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (294, 'Wholesale-Metals  Minerals (No Petroleum)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (295, 'Wholesale-Metals Service Centers  Offices');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (296, 'Wholesale-Electrical Apparatus  Equipment Wiring Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (297, 'Wholesale-Electrical Appliances TV  Radio Sets');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (298, 'Wholesale-Electronic Parts  Equipment NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (299, 'Wholesale-Hardware  Plumbing  Heating Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (300, 'Wholesale-Hardware');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (301, 'Wholesale-Machinery Equipment  Supplies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (302, 'Wholesale-Construction  Mining (No Petro) Machinery  Equip');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (303, 'Wholesale-Industrial Machinery  Equipment');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (304, 'Wholesale-Misc Durable Goods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (305, 'Wholesale-Jewelry Watches Precious Stones  Metals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (306, 'Wholesale-Durable Goods NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (307, 'Wholesale-Paper  Paper Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (308, 'Wholesale-Drugs Proprietaries  Druggists\' Sundries');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (310, 'Wholesale-Apparel Piece Goods  Notions');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (311, 'Wholesale-Groceries  Related Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (312, 'Wholesale-Groceries General Line (merchandise)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (313, 'Wholesale-Farm Product Raw Materials');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (314, 'Wholesale-Chemicals  Allied Products');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (315, 'Wholesale-Petroleum Bulk Stations  Terminals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (316, 'Wholesale-Petroleum  Petroleum Products (No Bulk Stations)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (317, 'Wholesale-Beer Wine  Distilled Alcoholic Beverages');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (318, 'Wholesale-Miscellaneous Non-durable Goods');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (319, 'Retail-Building Materials Hardware Garden Supply');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (320, 'Retail-Lumber  Other Building Materials Dealers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (321, 'Retail-Mobile Home Dealers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (322, 'Retail-Department Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (323, 'Retail-Variety Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (324, 'Retail-Misc General Merchandise Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (325, 'Retail-Food Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (326, 'Retail-Grocery Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (327, 'Retail-Convenience Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (328, 'Retail-Auto Dealers  Gasoline Stations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (329, 'Retail-Auto  Home Supply Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (330, 'Boat Dealers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (331, 'Retail-Apparel  Accessory Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (332, 'Retail-Women\'s Clothing Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (333, 'Retail-Family Clothing Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (334, 'Retail-Shoe Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (335, 'Retail-Home Furniture Furnishings  Equipment Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (336, 'Retail-Furniture Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (337, 'Retail-Radio TV  Consumer Electronics Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (338, 'Retail-Computer  Computer Software Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (339, 'Retail-Record  Prerecorded Tape Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (340, 'Retail-Eating  Drinking Places');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (341, 'Retail-Eating Places');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (342, 'Retail-Miscellaneous Retail');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (343, 'Retail-Drug Stores and Proprietary Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (344, 'Retail-Miscellaneous Shopping Goods Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (345, 'Retail-Jewelry Stores');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (346, 'Retail-Hobby Toy  Game Shops');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (347, 'Retail-Nonstore Retailers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (348, '');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (349, 'Retail-Catalog  Mail-Order Houses');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (350, 'Retail-Retail Stores NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (351, 'Pay Day Lenders');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (352, 'National Commercial Banks');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (353, 'State Commercial Banks');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (354, 'Commercial Banks NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (355, 'Savings Institution Federally Chartered');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (356, 'Savings Institutions Not Federally Chartered');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (357, 'Functions Related To Depository Banking NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (358, 'Federal  Federally Sponsored Credit Agencies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (359, 'Personal Credit Institutions');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (360, 'Short-Term Business Credit Institutions');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (361, 'Miscellaneous Business Credit Institution');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (362, 'Mortgage Bankers  Loan Correspondents');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (363, 'Loan Brokers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (364, 'Finance Lessors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (365, 'Asset-Backed Securities');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (366, 'Finance Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (367, 'Security  Commodity Brokers Dealers Exchanges  Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (368, 'Security Brokers Dealers  Flotation Companies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (369, 'Commodity Contracts Brokers  Dealers');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (370, 'Investment Advice');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (371, 'Life Insurance');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (372, 'Accident  Health Insurance');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (373, 'Hospital  Medical Service Plans');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (374, 'Fire Marine  Casualty Insurance');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (375, 'Surety Insurance');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (376, 'Title Insurance');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (377, 'Insurance Carriers NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (378, 'Insurance Agents Brokers  Service');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (379, 'Real Estate');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (380, 'Real Estate Operators (No Developers)  Lessors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (381, 'Operators of Nonresidential Buildings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (382, 'Operators of Apartment Buildings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (383, 'Lessors of Real Property NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (384, 'Real Estate Agents  Managers (For Others)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (385, 'Real Estate Dealers (For Their Own Account)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (386, 'Land Subdividers  Developers (No Cemeteries)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (388, 'Blank Checks');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (389, 'Oil Royalty Traders');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (390, 'Patent Owners  Lessors');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (391, 'Mineral Royalty Traders');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (392, 'Real Estate Investment Trusts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (393, 'Investors NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (394, 'Hotels Rooming Houses Camps  Other Lodging Places');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (395, 'Hotels  Motels');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (396, 'Services-Personal Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (397, 'Services-Advertising');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (398, 'Services-Advertising Agencies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (399, 'Services-Consumer Credit Reporting Collection Agencies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (400, 'Services-Mailing Reproduction Commercial Art  Photography');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (401, 'Services-Direct Mail Advertising Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (402, 'Services-Photocopying and Duplicating Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (403, 'Services-To Dwellings  Other Buildings');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (404, 'Services-Miscellaneous Equipment Rental  Leasing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (405, 'Services-Equipment Rental  Leasing NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (406, 'Services-Employment Agencies');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (407, 'Services-Help Supply Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (408, 'Services-Computer Programming Data Processing Etc.');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (409, 'Services-Computer Programming Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (410, 'Services-Prepackaged Software');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (411, 'Services-Computer Integrated Systems Design');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (412, 'Services-Computer Processing  Data Preparation');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (413, 'Services-Computer Rental  Leasing');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (414, 'Services-Miscellaneous Business Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (415, 'Services-Detective Guard  Armored Car Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (416, 'Services-Photofinishing Laboratories');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (417, 'Services-Telephone Interconnect Systems');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (418, 'Services-Business Services NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (419, 'Services-Automotive Repair Services  Parking');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (420, 'Services-Auto Rental  Leasing (No Drivers)');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (421, 'Services-Miscellaneous Repair Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (422, 'Services-Motion Picture  Video Tape Production');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (423, 'Services-Allied To Motion Picture Production');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (424, 'Services-Motion Picture  Video Tape Distribution');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (425, 'Services-Allied To Motion Picture Distribution');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (427, 'Services-Motion Picture Theaters');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (428, 'Services-Video Tape Rental');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (429, 'Services-Amusement  Recreation Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (430, 'Services-Racing Including Track Operation');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (431, 'Services-Miscellaneous Amusement  Recreation');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (432, 'Services-Video Game Arcades');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (433, 'Services-Gambling Transactions');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (434, 'Services-Amusement Parks');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (435, 'Services-Membership Sports  Recreation Clubs');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (436, 'Services-Health Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (437, 'Services-Offices  Clinics of Doctors of Medicine');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (438, 'Services-Nursing  Personal Care Facilities');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (439, 'Services-Skilled Nursing Care Facilities');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (440, 'Services-Hospitals');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (441, 'Services-General Medical  Surgical Hospitals NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (442, 'Services-Medical Laboratories');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (443, 'Services-Home Health Care Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (444, 'Services-Misc Health  Allied Services NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (445, 'Services-Specialty Outpatient Facilities NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (446, 'Services-Legal Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (447, 'Services-Educational Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (448, 'Services-Social Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (449, 'Services-Child Day Care Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (450, 'Services-Membership organizations');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (451, 'Services-Engineering Accounting Research Management');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (452, 'Services-Engineering Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (453, 'Services-Commercial Physical  Biological Research');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (454, 'Services-Testing Laboratories');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (455, 'Services-Management Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (456, 'Services-Management Consulting Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (457, 'Services-Facilities Support Management Services');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (458, 'Business Consulting Services Not Elsewhere Classified');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (459, 'American Depositary Receipts');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (460, 'Foreign Governments');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (461, 'Services-Services NEC');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (462, 'International Affairs');
INSERT INTO `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) VALUES (463, 'Non-Operating Establishments');

COMMIT;
/*
-- Additional Code
CREATE TABLE Accounts(id INT PRIMARY KEY AUTO_INCREMENT, first_name VARCHAR(50), last_name VARCHAR(50), username VARCHAR(50) UNIQUE NOT NULL, email VARCHAR(50), password TEXT NOT NULL, isAdmin tinyint(1), datecreated DATETIME default NOW(), session_id varchar(40));

COMMIT;*/


-- Additional Code
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Accounts` ;
CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Accounts`(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, first_name VARCHAR(50), last_name VARCHAR(50), username VARCHAR(50) UNIQUE NOT NULL, email VARCHAR(50), password TEXT NOT NULL, isAdmin tinyint(1), datecreated DATETIME default NOW(), session_id varchar(40));

COMMIT;

DROP TABLE IF EXISTS `tip_career_center_system_db`.`Temp_logs` ;
CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Temp_logs`(id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, temp_username VARCHAR(50) NOT NULL);

COMMIT;

-- STORED PROC
DELIMITER //
CREATE PROCEDURE uspAddtoTemplog(IN Qtemp_username varchar(50))
BEGIN
INSERT INTO Temp_logs(temp_username) 
VALUES(Qtemp_username);
END//
COMMIT//

CREATE PROCEDURE uspAddCompany(IN Qcompany_name varchar(45), IN Qcompany_address varchar(100), IN QIndustry_Type_industry_type_id int, IN QpictureFileName varchar(100), IN QbannerFileName varchar(100), IN QmoaFileName varchar(100))
BEGIN
INSERT INTO company(company_engagement_score,company_name, company_address, Industry_Type_industry_type_id, profile_image, banner_image, company_attachment)
VALUES(0,Qcompany_name, Qcompany_address, QIndustry_Type_industry_type_id, QpictureFileName, QbannerFileName, QmoaFileName);
END //
COMMIT//

CREATE PROCEDURE uspInsertContact(IN Qcontact_person_fname varchar(45) , IN Qcontact_person_lname varchar(45), IN Qcontact_person_position varchar(45),IN Qcontact_person_email varchar(45), IN Qcontact_person_no varchar(20), IN Qcontact_person_priority enum('PRIMARY','SECONDARY'), IN QCompany_company_id int)
BEGIN
INSERT INTO contact_person(contact_person_fname,contact_person_lname,contact_person_position,contact_person_email,contact_person_no,contact_person_priority,Company_company_id)
VALUES(Qcontact_person_fname,Qcontact_person_lname,Qcontact_person_position,Qcontact_person_email,Qcontact_person_no,Qcontact_person_priority,QCompany_company_id);
END //
COMMIT//

CREATE PROCEDURE uspUpdateCompany(IN Qcompany_name varchar(45), IN Qcompany_address varchar(100), IN QIndustry_Type_industry_type_id int, IN QpictureFileName varchar(100), IN QbannerFileName varchar(100), IN QmoaFileName varchar(100), IN Qcompany_id int)
BEGIN
UPDATE company SET company_name=Qcompany_name, company_address= Qcompany_address, Industry_Type_industry_type_id=QIndustry_Type_industry_type_id, profile_image=QpictureFileName, banner_image=QbannerFileName, company_attachment=QmoaFileName 
WHERE company_id = Qcompany_id;
END //
COMMIT//
/*
DELIMITER //
CREATE TRIGGER updateLevelOfEngagement123
BEFORE UPDATE 
ON Company
FOR EACH ROW
BEGIN 
  IF NEW.company_engagement_score BETWEEN 4 AND 26 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 1 WHERE company_id = (NEW.company_id);
  ELSEIF NEW.company_engagement_score BETWEEN 25 AND 47 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 2 WHERE company_id = (NEW.company_id);
  ELSEIF NEW.company_engagement_score > 47 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 3 WHERE company_id = (NEW.company_id);
  END IF;
END//
COMMIT//

DELIMITER ;

DELIMITER //

CREATE TRIGGER updateLevelOfEngagement321
AFTER UPDATE 
ON Company
FOR EACH ROW
BEGIN 
  IF OLD.company_engagement_score BETWEEN 4 AND 26 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 1 WHERE company_id = (OLD.company_id);
  ELSEIF OLD.company_engagement_score BETWEEN 25 AND 47 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 2 WHERE company_id = (OLD.company_id);
  ELSEIF OLD.company_engagement_score > 47 THEN
  UPDATE company SET Level_of_engagement_level_of_engagement_id = 3 WHERE company_id = (OLD.company_id);
  END IF;
END//
COMMIT//

DELIMITER ;*/

DELIMITER //
CREATE TRIGGER updateActivityLog_Insert
AFTER INSERT
ON company
FOR EACH ROW
BEGIN
  INSERT INTO activity_log (table_name, activity_name, dateTimeOccurred, user) VALUES ('Company', 'Insert', now(), (SELECT temp_username from Temp_logs));
  DELETE FROM Temp_logs;
END//
COMMIT//

CREATE TRIGGER updateActivityLog_Update
AFTER UPDATE
ON company
FOR EACH ROW
BEGIN
  INSERT INTO activity_log (table_name, activity_name, dateTimeOccurred, user) VALUES ('Company', 'Update', now(), (SELECT temp_username from Temp_logs));
  DELETE FROM Temp_logs;
END//
COMMIT//

CREATE TRIGGER updateActivityLog_Delete
AFTER DELETE
ON company
FOR EACH ROW
BEGIN
  INSERT INTO activity_log (table_name, activity_name, dateTimeOccurred, user) VALUES ('Company', 'Delete', now(), (SELECT temp_username from Temp_logs));
  DELETE FROM Temp_logs;
END//
COMMIT//

DELIMITER ;