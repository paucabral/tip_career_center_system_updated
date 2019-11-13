-- mysql workbench forward ENGINEering

set @old_unique_checks=@@unique_checks, unique_checks=0;
set @old_foreign_key_checks=@@foreign_key_checks, foreign_key_checks=0;
set @old_sql_mode=@@sql_mode, sql_mode='only_full_group_by,strict_trans_tables,no_zero_in_date,no_zero_date,error_for_division_by_zero,no_ENGINE_substitution';

-- -----------------------------------------------------
-- schema tip_career_center_system_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tip_career_center_system_db` ;

-- -----------------------------------------------------
-- schema tip_career_center_system_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tip_career_center_system_db` default character set utf8 ;
use `tip_career_center_system_db` ;

-- -----------------------------------------------------
-- table `tip_career_center_system_db`.`level_of_engagement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`level_of_engagement` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`level_of_engagement` (
  `level_of_engagement_id` INT NOT NULL AUTO_INCREMENT,
  `level_of_engagement_name` varchar(45) NULL,
  `level_of_engagement_required_score` int NULL,
  primary key (`level_of_engagement_id`))
ENGINE = innodb;


-- -----------------------------------------------------
-- table `tip_career_center_system_db`.`industry_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`industry_type` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`industry_type` (
  `industry_type_id` INT NOT NULL AUTO_INCREMENT,
  `industry_type_name` varchar(100) NULL,
  primary key (`industry_type_id`))
ENGINE = innodb;

-- -----------------------------------------------------
-- table `tip_career_center_system_db`.`activity_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`activity_log` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`activity_log` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `table_name` varchar(20) NULL,
  `activity_name` varchar(15) NULL,
  `datetimeoccurred` datetime NULL,
  `user` varchar(50) NULL,
  primary key (`activity_id`))
ENGINE = innodb;

-- -----------------------------------------------------
-- table `tip_career_center_system_db`.`company`
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
-- table `tip_career_center_system_db`.`activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`activity` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`activity` (
  `activity_id` INT NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(45) NULL,
  primary key (`activity_id`))
ENGINE = innodb;


-- -----------------------------------------------------
-- table `tip_career_center_system_db`.`company_has_activity`
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
-- table `tip_career_center_system_db`.`intership`
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
-- table `tip_career_center_system_db`.`contact_person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tip_career_center_system_db`.`contact_person` ;

CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`contact_person` (
  `contact_person_id` INT NOT NULL AUTO_INCREMENT,
  `contact_person_fname` varchar(45) NULL,
  `contact_person_lname` varchar(45) NULL,
  `contact_person_email` varchar(45) NULL,
  `contact_person_no` varchar(20) NULL,
  `contact_person_priority` enum('primary', 'secondary') NULL,
  `company_company_id` INT NOT NULL,
  `contact_person_position` varchar(45) NULL,
  primary key (`contact_person_id`),
  CONSTRAINT `fk_contact_person_company1`
    FOREIGN KEY (`company_company_id`)
    REFERENCES `tip_career_center_system_db`.`company` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = innodb;

-- -----------------------------------------------------
-- data for table `tip_career_center_system_db`.`industry_type`
-- -----------------------------------------------------
start transaction;
use `tip_career_center_system_db`;

insert into `tip_career_center_system_db`.`level_of_engagement` values(1,'confederate partner',5);
insert into `tip_career_center_system_db`.`level_of_engagement` values(2,'associate partner',26);
insert into `tip_career_center_system_db`.`level_of_engagement` values(3,'executive partner',47);


insert into `tip_career_center_system_db`.`activity` values(1,'internship');
insert into `tip_career_center_system_db`.`activity` values(2,'externship');
insert into `tip_career_center_system_db`.`activity` values(3,'scholarship');
insert into `tip_career_center_system_db`.`activity` values(4,'career fair');
insert into `tip_career_center_system_db`.`activity` values(5,'on-campus recruitment');
insert into `tip_career_center_system_db`.`activity` values(6,'career development training');
insert into `tip_career_center_system_db`.`activity` values(7,'mock job interview');


insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (1, 'agricultural production-crops');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (2, 'agricultural prod-livestock  animal specialties');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (3, 'agricultural services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (4, 'forestry');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (5, 'fishing hunting and trapping');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (6, 'metal mining');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (7, 'gold and silver ores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (8, 'miscellaneous metal ores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (9, 'bituminous coal  lignite mining');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (10, 'bituminous coal  lignite surface mining');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (11, 'crude petroleum  natural gas');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (12, 'drilling oil  gas wells');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (13, 'oil  gas field exploration services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (14, 'oil  gas field services nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (15, 'mining  quarrying of nonmetallic minerals (no fuels)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (16, 'general bldg contractors - residential bldgs');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (17, 'operative builders');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (18, 'general bldg contractors - nonresidential bldgs');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (19, 'heavy construction other than bldg const - contractors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (20, 'water sewer pipeline comm  power line construction');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (21, 'heavy construction not elsewhere classified [8]');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (22, 'construction - special trade contractors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (23, 'electrical work');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (24, 'food and kindred products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (25, 'meat packing plants');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (26, 'sausages  other prepared meat products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (27, 'poultry slaughtering and processing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (28, 'dairy products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (29, 'ice cream  frozen desserts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (30, 'canned frozen  preserved fruit veg  food specialties');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (31, 'canned fruits veg preserves jams  jellies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (32, 'grain mill products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (33, 'bakery products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (34, 'cookies  crackers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (35, 'sugar  confectionery products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (37, 'fats  oils');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (38, 'beverages');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (39, 'malt beverages');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (40, 'bottled  canned soft drinks  carbonated waters');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (41, 'miscellaneous food preparations  kindred products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (42, 'prepared fresh or frozen fish  seafood');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (43, 'tobacco products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (44, 'cigarettes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (45, 'textile mill products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (46, 'broadwoven fabric mills cotton');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (47, 'broadwoven fabric mills man made fiber  silk');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (48, 'knitting mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (49, 'knit outerwear mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (50, 'carpets  rugs');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (51, 'apparel  other finished prods of fabrics  similar matl');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (52, 'men\'s  boys\' furnishings work clothing  allied garments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (53, 'women\'s misses\' and juniors outerwear');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (54, 'women\'s misses\' children\'s  infant\'s undergarments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (55, 'miscellaneous fabricated textile products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (56, 'lumber  wood products (no furniture)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (57, 'sawmills  planing mills general');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (58, 'millwood veneer plywood  structural wood members');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (59, 'mobile homes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (60, 'prefabricated wood bldgs  components');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (61, 'household furniture');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (62, 'wood household furniture (no upholstered)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (63, 'office furniture');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (64, 'office furniture (no wood)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (65, 'public bldg  related furniture');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (66, 'partitions shelvg lockers  office  store fixtures');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (67, 'miscellaneous furniture  fixtures');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (68, 'papers  allied products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (69, 'pulp mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (70, 'paper mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (71, 'paperboard mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (72, 'paperboard containers  boxes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (73, 'converted paper  paperboard prods (no containers/boxes)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (74, 'plastics foil  coated paper bags');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (76, 'newspapers: publishing or publishing  printing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (77, 'periodicals: publishing or publishing  printing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (78, 'books: publishing or publishing  printing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (79, 'book printing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (80, 'miscellaneous publishing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (81, 'commercial printing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (82, 'manifold business forms');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (83, 'greeting cards');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (84, 'blankbooks looseleaf binders  bookbinding  related work');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (85, 'service industries for the printing trade');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (86, 'chemicals  allied products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (87, 'industrial inorganic chemicals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (88, 'plastic material synth resin/rubber cellulos (no glass)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (89, 'plastic materials synth resins  nonvulcan elastomers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (90, 'medicinal chemicals  botanical products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (91, 'pharmaceutical preparations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (92, 'in vitro  in vivo diagnostic substances');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (93, 'biological products (no diagnostic substances)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (94, 'soap detergents cleaning preparations perfumes cosmetics');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (95, 'specialty cleaning polishing and sanitation preparations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (96, 'perfumes cosmetics  other toilet preparations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (97, 'paints varnishes lacquers enamels  allied prods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (98, 'industrial organic chemicals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (99, 'agricultural chemicals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (100, 'miscellaneous chemical products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (101, 'adhesives  sealants');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (102, 'petroleum refining');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (103, 'asphalt paving  roofing materials');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (104, 'miscellaneous products of petroleum  coal');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (105, 'tires  inner tubes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (106, 'rubber  plastics footwear');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (107, 'gaskets packg  sealg devices  rubber  plastics hose');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (108, 'fabricated rubber products nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (109, 'miscellaneous plastics products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (110, 'unsupported plastics film  sheet');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (111, 'plastics foam products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (112, 'plastics products nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (113, 'leather  ');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (114, 'leather products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (115, 'footwear (no rubber)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (116, 'flat glass');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (117, 'glass  glassware pressed or blown');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (118, 'glass containers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (119, 'glass products made of purchased glass');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (120, 'cement hydraulic');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (121, 'structural clay products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (122, 'pottery  related products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (123, 'concrete gypsum  plaster products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (124, 'concrete products except block  brick');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (125, 'cut stone  stone products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (126, 'abrasive asbestos  misc nonmetallic mineral prods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (127, 'steel works blast furnaces  rolling  finishing mills');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (128, 'steel works blast furnaces  rolling mills (coke ovens)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (129, 'steel pipe  tubes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (130, 'iron  steel foundries');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (131, 'primary smelting  refining of nonferrous metals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (132, 'primary production of aluminum');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (133, 'secondary smelting  refining of nonferrous metals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (134, 'rolling drawing  extruding of nonferrous metals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (135, 'drawing  insulating of nonferrous wire');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (136, 'nonferrous foundries (castings)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (137, 'miscellaneous primary metal products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (138, 'metal cans');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (139, 'metal shipping barrels drums kegs  pails');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (140, 'cutlery handtools  general hardware');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (141, 'heating equip except elec  warm air;  plumbing fixtures');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (142, 'heating equipment except electric  warm air furnaces');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (143, 'fabricated structural metal products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (144, 'metal doors sash frames moldings  trim');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (145, 'fabricated plate work (boiler shops)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (146, 'sheet metal work');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (147, 'prefabricated metal buildings  components');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (148, 'screw machine products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (149, 'bolts nuts screws rivets  washers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (150, 'metal forgings  stampings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (151, 'coating engraving  allied services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (152, 'ordnance  accessories (no vehicles/guided missiles)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (154, 'miscellaneous fabricated metal products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (155, 'ENGINEs  turbines');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (156, 'farm machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (157, 'lawn  garden tractors  home lawn  gardens equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (158, 'construction mining  materials handling machinery  equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (159, 'construction machinery  equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (160, 'mining machinery  equip (no oil  gas field mach  equip)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (161, 'oil  gas field machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (162, 'industrial trucks tractors trailers  stackers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (163, 'metalworkg machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (164, 'machine tools metal cutting types');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (165, 'special industry machinery (no metalworking machinery)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (166, 'printing trades machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (167, 'special industry machinery nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (168, 'general industrial machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (169, 'pumps  pumping equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (170, 'ball  roller bearings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (171, 'industrial  commercial fans  blowers  air purifying equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (172, 'industrial process furnaces  ovens');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (173, 'general industrial machinery  equipment nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (174, 'computer  office equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (175, 'electronic computers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (176, 'computer storage devices');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (177, 'computer terminals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (178, 'computer communications equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (179, 'computer peripheral equipment nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (180, 'calculating  accounting machines (no electronic computers)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (181, 'office machines nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (182, 'refrigeration  service industry machinery');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (183, 'air-cond  warm air heatg equip  comm  indl refrig equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (184, 'misc industrial  commercial machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (185, 'electronic  other electrical equipment (no computer equip)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (186, 'power distribution  specialty transformers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (187, 'switchgear  switchboard apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (188, 'electrical industrial apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (189, 'motors  generators');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (190, 'household appliances');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (191, 'electric housewares  fans');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (193, 'electric lighting  wiring equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (194, 'household audio  video equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (195, 'phonograph records  prerecorded audio tapes  disks');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (196, 'telephone  telegraph apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (197, 'radio  tv broadcasting  communications equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (198, 'communications equipment nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (199, 'electronic components  accessories');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (200, 'printed circuit boards');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (201, 'semiconductors  related devices');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (202, 'electronic coils transformers  other inductors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (203, 'electronic connectors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (204, 'electronic components nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (205, 'miscellaneous electrical machinery equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (206, 'magnetic  optical recording media');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (207, 'motor vehicles  passenger car bodies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (208, 'truck  bus bodies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (209, 'motor vehicle parts  accessories');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (210, 'truck trailers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (211, 'motor homes');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (212, 'aircraft  parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (213, 'aircraft');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (214, 'aircraft ENGINEs  ENGINE parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (215, 'aircraft parts  auxiliary equipment nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (216, 'ship  boat building  repairing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (217, 'railroad equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (218, 'motorcycles bicycles  parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (219, 'guided missiles  space vehicles  parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (220, 'miscellaneous transportation equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (221, 'search detection navigation guidance aeronautical sys');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (222, 'laboratory apparatus  furniture');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (223, 'auto controls for regulating residential  comml environments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (224, 'industrial instruments for measurement display and control');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (225, 'totalizing fluid meters  counting devices');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (226, 'instruments for meas  testing of electricity  elec signals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (227, 'laboratory analytical instruments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (228, 'optical instruments  lenses');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (229, 'measuring  controlling devices nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (230, 'surgical  medical instruments  apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (232, 'orthopedic prosthetic  surgical appliances  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (233, 'dental equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (234, 'x-ray apparatus  tubes  related irradiation apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (235, 'electromedical  electrotherapeutic apparatus');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (236, 'ophthalmic goods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (237, 'photographic equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (238, 'watches clocks clockwork operated devices/parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (239, 'jewelry silverware  plated ware');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (240, 'jewelry precious metal');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (241, 'musical instruments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (242, 'dolls  stuffed toys');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (243, 'games toys  children\'s vehicles (no dolls  bicycles)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (244, 'sporting  athletic goods nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (245, 'pens pencils  other artists\' materials');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (246, 'costume jewelry  novelties');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (247, 'miscellaneous manufacturing industries');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (248, 'railroads line-haul operating');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (249, 'railroad switching  terminal establishments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (250, 'local  suburban transit  interurban hwy passenger trans');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (251, 'trucking  courier services (no air)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (252, 'trucking (no local)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (253, 'public warehousing  storage');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (254, 'terminal maintenance facilities for motor freight transport');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (255, 'water transportation');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (256, 'deep sea foreign transportation of freight');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (257, 'air transportation scheduled');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (258, 'air courier services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (259, 'air transportation nonscheduled');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (260, 'airports flying fields  airport terminal services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (261, 'pipe lines (no natural gas)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (262, 'transportation services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (263, 'arrangement of transportation of freight  cargo');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (264, 'radiotelephone communications');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (265, 'telephone communications (no radiotelephone)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (266, 'telegraph  other message communications');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (267, 'radio broadcasting stations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (268, 'television broadcasting stations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (269, 'cable  other pay television services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (271, 'communications services nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (272, 'electric gas  sanitary services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (273, 'electric services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (274, 'natural gas transmission');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (275, 'natural gas transmission  distribution');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (276, 'natural gas distribution');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (277, 'electric  other services combined');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (278, 'gas  other services combined');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (279, 'water supply');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (280, 'sanitary services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (281, 'refuse systems');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (282, 'hazardous waste management');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (283, 'steam  air-conditioning supply');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (284, 'co-generation services  small power producers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (285, 'wholesale-durable goods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (286, 'wholesale-motor vehicles  motor vehicle parts  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (287, 'wholesale-motor vehicle supplies  new parts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (288, 'wholesale-furniture  home furnishings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (289, 'wholesale-lumber  other construction materials');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (290, 'wholesale-lumber plywood millwork  wood panels');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (291, 'wholesale-professional  commercial equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (292, 'wholesale-computers  peripheral equipment  software');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (293, 'wholesale-medical dental  hospital equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (294, 'wholesale-metals  minerals (no petroleum)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (295, 'wholesale-metals service centers  offices');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (296, 'wholesale-electrical apparatus  equipment wiring supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (297, 'wholesale-electrical appliances tv  radio sets');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (298, 'wholesale-electronic parts  equipment nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (299, 'wholesale-hardware  plumbing  heating equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (300, 'wholesale-hardware');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (301, 'wholesale-machinery equipment  supplies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (302, 'wholesale-construction  mining (no petro) machinery  equip');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (303, 'wholesale-industrial machinery  equipment');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (304, 'wholesale-misc durable goods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (305, 'wholesale-jewelry watches precious stones  metals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (306, 'wholesale-durable goods nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (307, 'wholesale-paper  paper products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (308, 'wholesale-drugs proprietaries  druggists\' sundries');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (310, 'wholesale-apparel piece goods  notions');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (311, 'wholesale-groceries  related products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (312, 'wholesale-groceries general line (merchandise)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (313, 'wholesale-farm product raw materials');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (314, 'wholesale-chemicals  allied products');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (315, 'wholesale-petroleum bulk stations  terminals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (316, 'wholesale-petroleum  petroleum products (no bulk stations)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (317, 'wholesale-beer wine  distilled alcoholic beverages');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (318, 'wholesale-miscellaneous non-durable goods');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (319, 'retail-building materials hardware garden supply');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (320, 'retail-lumber  other building materials dealers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (321, 'retail-mobile home dealers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (322, 'retail-department stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (323, 'retail-variety stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (324, 'retail-misc general merchandise stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (325, 'retail-food stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (326, 'retail-grocery stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (327, 'retail-convenience stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (328, 'retail-auto dealers  gasoline stations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (329, 'retail-auto  home supply stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (330, 'boat dealers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (331, 'retail-apparel  accessory stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (332, 'retail-women\'s clothing stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (333, 'retail-family clothing stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (334, 'retail-shoe stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (335, 'retail-home furniture furnishings  equipment stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (336, 'retail-furniture stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (337, 'retail-radio tv  consumer electronics stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (338, 'retail-computer  computer software stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (339, 'retail-record  prerecorded tape stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (340, 'retail-eating  drinking places');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (341, 'retail-eating places');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (342, 'retail-miscellaneous retail');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (343, 'retail-drug stores and proprietary stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (344, 'retail-miscellaneous shopping goods stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (345, 'retail-jewelry stores');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (346, 'retail-hobby toy  game shops');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (347, 'retail-nonstore retailers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (348, '');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (349, 'retail-catalog  mail-order houses');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (350, 'retail-retail stores nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (351, 'pay day lenders');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (352, 'national commercial banks');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (353, 'state commercial banks');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (354, 'commercial banks nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (355, 'savings institution federally chartered');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (356, 'savings institutions not federally chartered');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (357, 'functions related to depository banking nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (358, 'federal  federally sponsored credit agencies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (359, 'personal credit institutions');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (360, 'short-term business credit institutions');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (361, 'miscellaneous business credit institution');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (362, 'mortgage bankers  loan correspondents');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (363, 'loan brokers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (364, 'finance lessors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (365, 'asset-backed securities');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (366, 'finance services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (367, 'security  commodity brokers dealers exchanges  services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (368, 'security brokers dealers  flotation companies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (369, 'commodity contracts brokers  dealers');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (370, 'investment advice');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (371, 'life insurance');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (372, 'accident  health insurance');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (373, 'hospital  medical service plans');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (374, 'fire marine  casualty insurance');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (375, 'surety insurance');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (376, 'title insurance');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (377, 'insurance carriers nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (378, 'insurance agents brokers  service');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (379, 'real estate');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (380, 'real estate operators (no developers)  lessors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (381, 'operators of nonresidential buildings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (382, 'operators of apartment buildings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (383, 'lessors of real property nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (384, 'real estate agents  managers (for others)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (385, 'real estate dealers (for their own account)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (386, 'land subdividers  developers (no cemeteries)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (388, 'blank checks');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (389, 'oil royalty traders');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (390, 'patent owners  lessors');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (391, 'mineral royalty traders');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (392, 'real estate investment trusts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (393, 'investors nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (394, 'hotels rooming houses camps  other lodging places');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (395, 'hotels  motels');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (396, 'services-personal services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (397, 'services-advertising');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (398, 'services-advertising agencies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (399, 'services-consumer credit reporting collection agencies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (400, 'services-mailing reproduction commercial art  photography');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (401, 'services-direct mail advertising services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (402, 'services-photocopying and duplicating services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (403, 'services-to dwellings  other buildings');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (404, 'services-miscellaneous equipment rental  leasing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (405, 'services-equipment rental  leasing nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (406, 'services-employment agencies');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (407, 'services-help supply services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (408, 'services-computer programming data processing etc.');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (409, 'services-computer programming services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (410, 'services-prepackaged software');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (411, 'services-computer integrated systems design');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (412, 'services-computer processing  data preparation');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (413, 'services-computer rental  leasing');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (414, 'services-miscellaneous business services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (415, 'services-detective guard  armored car services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (416, 'services-photofinishing laboratories');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (417, 'services-telephone interconnect systems');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (418, 'services-business services nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (419, 'services-automotive repair services  parking');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (420, 'services-auto rental  leasing (no drivers)');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (421, 'services-miscellaneous repair services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (422, 'services-motion picture  video tape production');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (423, 'services-allied to motion picture production');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (424, 'services-motion picture  video tape distribution');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (425, 'services-allied to motion picture distribution');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (427, 'services-motion picture theaters');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (428, 'services-video tape rental');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (429, 'services-amusement  recreation services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (430, 'services-racing including track operation');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (431, 'services-miscellaneous amusement  recreation');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (432, 'services-video game arcades');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (433, 'services-gambling transactions');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (434, 'services-amusement parks');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (435, 'services-membership sports  recreation clubs');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (436, 'services-health services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (437, 'services-offices  clinics of doctors of medicine');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (438, 'services-nursing  personal care facilities');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (439, 'services-skilled nursing care facilities');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (440, 'services-hospitals');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (441, 'services-general medical  surgical hospitals nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (442, 'services-medical laboratories');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (443, 'services-home health care services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (444, 'services-misc health  allied services nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (445, 'services-specialty outpatient facilities nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (446, 'services-legal services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (447, 'services-educational services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (448, 'services-social services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (449, 'services-child day care services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (450, 'services-membership organizations');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (451, 'services-ENGINEering accounting research management');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (452, 'services-ENGINEering services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (453, 'services-commercial physical  biological research');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (454, 'services-testing laboratories');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (455, 'services-management services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (456, 'services-management consulting services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (457, 'services-facilities support management services');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (458, 'business consulting services not elsewhere classified');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (459, 'american depositary receipts');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (460, 'foreign governments');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (461, 'services-services nec');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (462, 'international affairs');
insert into `tip_career_center_system_db`.`industry_type` (`industry_type_id`, `industry_type_name`) values (463, 'non-operating establishments');

commit;
/*
-- additional code
create table accounts(id int primary key AUTO_INCREMENT, first_name varchar(50), last_name varchar(50), username varchar(50) unique not NULL, email varchar(50), password text not NULL, isadmin tinyint(1), datecreated datetime default now(), session_id varchar(40));
commit;*/


-- additional code
DROP TABLE IF EXISTS `tip_career_center_system_db`.`accounts` ;
CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`accounts`(id int primary key not NULL AUTO_INCREMENT, first_name varchar(50), last_name varchar(50), username varchar(50) unique not NULL, email varchar(50), password text not NULL, isadmin tinyint(1), datecreated datetime default now(), session_id varchar(40));

commit;

DROP TABLE IF EXISTS `tip_career_center_system_db`.`temp_logs` ;
CREATE TABLE IF NOT EXISTS `tip_career_center_system_db`.`temp_logs`(id int primary key not NULL AUTO_INCREMENT, temp_username varchar(50) not NULL);

commit;

-- stored proc
delimiter //
create procedure uspaddtotemplog(in qtemp_username varchar(50))
begin
insert into temp_logs(temp_username) 
values(qtemp_username);
end//
commit//

create procedure uspaddcompany(in qcompany_name varchar(45), in qcompany_address varchar(100), in qindustry_type_industry_type_id int, in qpicturefilename varchar(100), in qbannerfilename varchar(100), in qmoafilename varchar(100))
begin
insert into company(company_engagement_score,company_name, company_address, industry_type_industry_type_id, profile_image, banner_image, company_attachment)
values(0,qcompany_name, qcompany_address, qindustry_type_industry_type_id, qpicturefilename, qbannerfilename, qmoafilename);
end //
commit//

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
delimiter //
create trigger updatelevelofengagement123
before update 
on company
for each row
begin 
  if new.company_engagement_score between 4 and 26 then
  update company set level_of_engagement_level_of_engagement_id = 1 where company_id = (new.company_id);
  elseif new.company_engagement_score between 25 and 47 then
  update company set level_of_engagement_level_of_engagement_id = 2 where company_id = (new.company_id);
  elseif new.company_engagement_score > 47 then
  update company set level_of_engagement_level_of_engagement_id = 3 where company_id = (new.company_id);
  end if;
end//
commit//
delimiter ;
delimiter //
create trigger updatelevelofengagement321
after update 
on company
for each row
begin 
  if old.company_engagement_score between 4 and 26 then
  update company set level_of_engagement_level_of_engagement_id = 1 where company_id = (old.company_id);
  elseif old.company_engagement_score between 25 and 47 then
  update company set level_of_engagement_level_of_engagement_id = 2 where company_id = (old.company_id);
  elseif old.company_engagement_score > 47 then
  update company set level_of_engagement_level_of_engagement_id = 3 where company_id = (old.company_id);
  end if;
end//
commit//
delimiter ;*/

delimiter //
create trigger updateactivitylog_insert
after insert
on company
for each row
begin
  insert into activity_log (table_name, activity_name, datetimeoccurred, user) values ('company', 'insert', now(), (select temp_username from temp_logs));
  delete from temp_logs;
end//
commit//

create trigger updateactivitylog_update
after update
on company
for each row
begin
  insert into activity_log (table_name, activity_name, datetimeoccurred, user) values ('company', 'update', now(), (select temp_username from temp_logs));
  delete from temp_logs;
end//
commit//

create trigger updateactivitylog_delete
after delete
on company
for each row
begin
  insert into activity_log (table_name, activity_name, datetimeoccurred, user) values ('company', 'delete', now(), (select temp_username from temp_logs));
  delete from temp_logs;
end//
commit//

delimiter ;
