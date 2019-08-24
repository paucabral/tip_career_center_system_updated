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
  `level_of_engagement_id` INT NOT NULL,
  `level_of_engagement_name` VARCHAR(45) NULL,
  `level_of_engagement_required_score` INT NULL,
  PRIMARY KEY (`level_of_engagement_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Company` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Company` (
  `company_id` INT NOT NULL,
  `company_name` VARCHAR(45) NULL,
  `company_engagement_score` INT NULL,
  `Level_of_engagement_level_of_engagement_id` INT NOT NULL,
  PRIMARY KEY (`company_id`),
  CONSTRAINT `fk_Company_Level_of_engagement`
    FOREIGN KEY (`Level_of_engagement_level_of_engagement_id`)
    REFERENCES `tip_career_center_system_db`.`Level_of_engagement` (`level_of_engagement_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Activity` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Activity` (
  `activity_id` INT NOT NULL,
  `activity_name` VARCHAR(45) NULL,
  PRIMARY KEY (`activity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tip_career_center_system_db`.`Company_has_Activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`Company_has_Activity` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`Company_has_Activity` (
  `quantity` INT NULL,
  `Company_company_id` INT NOT NULL,
  `Activity_activity_id` INT NOT NULL,
  CONSTRAINT `fk_Company_has_Activity_Company`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Company_has_Activity_Activity`
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
  `internship_id` INT NOT NULL,
  `internship_student_name` VARCHAR(45) NULL,
  `intership_program` VARCHAR(45) NULL,
  `intership_course` VARCHAR(45) NULL,
  `intership_school_year` VARCHAR(45) NULL,
  `internship_semester` VARCHAR(45) NULL,
  `Company_company_id` INT NOT NULL,
  `internship_date_added` DATE NULL,
  PRIMARY KEY (`internship_id`),
  CONSTRAINT `fk_Intership_Company`
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
  `externship_id` INT NOT NULL,
  `externship_student_name` VARCHAR(45) NULL,
  `externship_program` VARCHAR(45) NULL,
  `externship_course` VARCHAR(45) NULL,
  `externship_school_year` VARCHAR(45) NULL,
  `externship_semester` VARCHAR(45) NULL,
  `Company_company_id` INT NOT NULL,
  `externship_date_added` DATE NULL,
  PRIMARY KEY (`externship_id`),
  CONSTRAINT `fk_Externship_Company`
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
  `scholarship_id` INT NOT NULL,
  `scholarship_student_name` VARCHAR(45) NULL,
  `sholarship_program` VARCHAR(45) NULL,
  `scholarship_course` VARCHAR(45) NULL,
  `scholarship_school_year` VARCHAR(45) NULL,
  `scholarship_semester` VARCHAR(45) NULL,
  `scholarship_amount` FLOAT NULL,
  `Company_company_id` INT NOT NULL,
  `scholarship_date_added` DATE NULL,
  PRIMARY KEY (`scholarship_id`),
  CONSTRAINT `fk_Scholarship_Company`
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
  `career_fair_id` INT NOT NULL,
  `career_fair_title` VARCHAR(45) NULL,
  `career_fair_date` DATE NULL,
  `career_fair_participants` INT NULL,
  `career_fair_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `career_fair_date_added` DATE NULL,
  PRIMARY KEY (`career_fair_id`),
  CONSTRAINT `fk_Career_Fair_Company`
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
  `on_campus_recruitment_id` INT NOT NULL,
  `on_campus_recruitment_name` VARCHAR(45) NULL,
  `on_campus_recruitment_date` DATE NULL,
  `on_campus_recruitment_participants` INT NULL,
  `on_campus_recruitment_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `on_campus_recruitment_date_added` DATE NULL,
  PRIMARY KEY (`on_campus_recruitment_id`),
  CONSTRAINT `fk_On_Campus_Recruitment_Company`
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
  `career_development_training_id` INT NOT NULL,
  `career_development_training_name` VARCHAR(45) NULL,
  `career_development_training_date` DATE NULL,
  `career_development_training_participants` INT NULL,
  `career_development_training_attachment` BLOB NULL,
  `Company_company_id` INT NOT NULL,
  `career_development_training_date_added` DATE NULL,
  PRIMARY KEY (`career_development_training_id`),
  CONSTRAINT `fk_career_development_training_Company`
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
  `mock_job_interview_id` INT NOT NULL,
  `mock_job_interview_date` DATE NULL,
  `mock_job_interview_participants` INT NULL,
  `Company_company_id` INT NOT NULL,
  `mock_job_interviewcol_date_added` DATE NULL,
  PRIMARY KEY (`mock_job_interview_id`),
  CONSTRAINT `fk_mock_job_interview_Company`
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
  `contact_person_id` INT NOT NULL,
  `contact_person_fname` VARCHAR(45) NULL,
  `contact_person_lname` VARCHAR(45) NULL,
  `contact_person_email` VARCHAR(45) NULL,
  `contact_person_no` INT NULL,
  `contact_person_type` ENUM('PRIMARY', 'SECONDARY') NULL,
  `Company_company_id` INT NOT NULL,
  `contact_person_position` VARCHAR(45) NULL,
  PRIMARY KEY (`contact_person_id`),
  CONSTRAINT `fk_Contact_Person_Company`
    FOREIGN KEY (`Company_company_id`)
    REFERENCES `tip_career_center_system_db`.`Company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
