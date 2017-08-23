# NOTE: The database engine we have selected is MySQL (v5.7+).
#
# Some of this SQL is might be engine-specific, especially the constraint
# (foreign key) creation

USE `my_db$default`;

# set to ignore all foreign keys
SET FOREIGN_KEY_CHECKS = 0;

# drop all the tables
DROP TABLE IF EXISTS Site;
DROP TABLE IF EXISTS FoodBankService;
DROP TABLE IF EXISTS ShelterService;
DROP TABLE IF EXISTS FoodPantryService;
DROP TABLE IF EXISTS SoupKitchenService;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS ClientLog;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS ItemRequest;
DROP TABLE IF EXISTS Item;

DROP VIEW IF EXISTS ClientServices;
DROP VIEW IF EXISTS AllServices;

# enable all foreign key
SET FOREIGN_KEY_CHECKS = 1;

    
CREATE TABLE Site(
    SiteID int NOT NULL AUTO_INCREMENT,
    Name varchar(50) NULL,
    Address varchar(50) NULL,
    City varchar(50) NULL,
    State char(2) NULL,
    ZipCode int NULL,
    Phone varchar(50) NULL,
    PRIMARY KEY (SiteID));
    
CREATE TABLE FoodBankService(
    ServiceID int NOT NULL,
    SiteID int NOT NULL,
    PRIMARY KEY (ServiceID));
    
CREATE TABLE ShelterService(
    ServiceID int NOT NULL,
    SiteID int NOT NULL,
    Description varchar(200) NULL,
    HoursOfOperation varchar(50) NOT NULL,
    ConditionsOfUse varchar(200) NULL,
    MaleBunkCount int NOT NULL,
    FemaleBunkCount int NOT NULL,
    MixedBunkCount int NOT NULL,
    MaleBunksAvailable int NOT NULL,
    FemaleBunksAvailable int NOT NULL,
    MixedBunksAvailable int NOT NULL,
    PRIMARY KEY (ServiceID));

CREATE TABLE FoodPantryService(
    ServiceID int NOT NULL,
    SiteID int NOT NULL,
    Description varchar(200) NULL,
    HoursOfOperation varchar(50) NOT NULL,
    ConditionsOfUse varchar(200) NULL,
    PRIMARY KEY (ServiceID));
    
CREATE TABLE SoupKitchenService(
    ServiceID int NOT NULL,
    SiteID int NOT NULL,
    Description varchar(200) NULL,
    HoursOfOperation varchar(50) NOT NULL,
    ConditionsOfUse varchar(200) NULL,
    SeatsAvailable int NOT NULL,
    TotalCapacity int NOT NULL,
    PRIMARY KEY (ServiceID));

CREATE TABLE Client(
    ClientID int NOT NULL AUTO_INCREMENT,
    FullName varchar(50) NOT NULL,
    IDOrDescription varchar(200) NULL,
    PhoneNumber varchar(50) NULL,
    PRIMARY KEY (ClientID));

CREATE TABLE ClientLog(
    ClientID int NOT NULL,
    TimeStamp datetime NOT NULL,
    ServiceID int NOT NULL,
    Description varchar(200) NULL,
    Notes varchar(200) NULL,
    PRIMARY KEY (ClientID, TimeStamp));

CREATE TABLE `User` (
    UserID int NOT NULL AUTO_INCREMENT,
    SiteID int NOT NULL,
    UserName varchar(50) NOT NULL,
    Password varchar(50) NOT NULL,
    FullName varchar(50) NULL,
    Email varchar(50) NULL,
    PRIMARY KEY (UserID));
    
CREATE TABLE ItemRequest(
    ItemRequestID int NOT NULL AUTO_INCREMENT,
    ItemID int NOT NULL,
    FoodBankServiceID int,
    UserID int NOT NULL,
    Units int NOT NULL,
    Status varchar(50) NOT NULL,
    PRIMARY KEY (ItemRequestID));
    
CREATE TABLE Item(
    ItemID int NOT NULL AUTO_INCREMENT,
    FoodBankServiceID int NOT NULL,
    Category varchar(50) NOT NULL,    
    SubCategory varchar(50) NOT NULL,    
    Name varchar(50) NULL,
    Units int NOT NULL,
    ExpirationDate datetime NOT NULL,
    StorageType varchar(50) NOT NULL,
    PRIMARY KEY (ItemID));
    
# add all the FOREIGN KEY constraints

ALTER TABLE FoodBankService
    ADD FOREIGN KEY (SiteID) REFERENCES Site(SiteID);    
    
ALTER TABLE ShelterService
    ADD FOREIGN KEY (SiteID) REFERENCES Site(SiteID);    

ALTER TABLE SoupKitchenService
    ADD FOREIGN KEY (SiteID) REFERENCES Site(SiteID);    

ALTER TABLE ShelterService
    ADD FOREIGN KEY (SiteID) REFERENCES Site(SiteID);    

ALTER TABLE ClientLog
    ADD FOREIGN KEY (ClientID) REFERENCES Client(ClientID);         
    
ALTER TABLE `User`
    ADD FOREIGN KEY (SiteID) REFERENCES Site(SiteID);

ALTER TABLE ItemRequest    
    ADD FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    ADD FOREIGN KEY (FoodBankServiceID) REFERENCES FoodBankService(ServiceID),
    ADD FOREIGN KEY (UserID) REFERENCES `User`(UserID);    
    
ALTER TABLE Item
    ADD FOREIGN KEY (FoodBankServiceID) REFERENCES FoodBankService(ServiceID);

# create all the views needed by the database

CREATE VIEW ClientServices
AS 		
	SELECT ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse FROM FoodPantryService
	UNION ALL
	SELECT ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse FROM ShelterService
	UNION ALL
	SELECT ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse FROM SoupKitchenService;
    
CREATE VIEW AllServices
AS 		
	SELECT ServiceID, SiteID FROM FoodBankService
	UNION ALL
	SELECT ServiceID, SiteID FROM FoodPantryService
	UNION ALL
	SELECT ServiceID, SiteID FROM ShelterService
	UNION ALL
	SELECT ServiceID, SiteID FROM SoupKitchenService;
