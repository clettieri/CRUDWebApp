# NOTE: The database engine we have selected is MySQL (v5.7+).
#
# Some of this SQL is might be engine-specific, especially the constraint
# (foreign key) creation

USE `my_db$default`;

# set to ignore all foreign keys
SET FOREIGN_KEY_CHECKS = 0;

# drop all the rows
DELETE FROM Site;
DELETE FROM FoodBankService;
DELETE FROM ShelterService;
DELETE FROM FoodPantryService;
DELETE FROM SoupKitchenService;
DELETE FROM Client;
DELETE FROM ClientLog;
DELETE FROM `User`;
DELETE FROM ItemRequest;
DELETE FROM Item;

# reset the auto-increment values for tables with AI

ALTER TABLE Site AUTO_INCREMENT=1;
ALTER TABLE Client AUTO_INCREMENT=1;
ALTER TABLE `User` AUTO_INCREMENT=1;
ALTER TABLE ItemRequest AUTO_INCREMENT=1;
ALTER TABLE Item AUTO_INCREMENT=1;

# enable all foreign key
SET FOREIGN_KEY_CHECKS = 1;

# Sites
#     • 3 Sites: (short name, address, phone) use short name: ('site1', 'site2', …, 'site3')

INSERT INTO Site (Name, Address, City, State, ZipCode, Phone) VALUES
	('site1', 'Site1 Address', 'Atlanta', 'GA', '30332', '111-111-1111'),
	('site2', 'Site2 Address', 'Atlanta', 'GA', '30332', '222-222-2222'),
	('site3', 'Site3 Address', 'Atlanta', 'GA', '30332', '333-333-3333');

# Users: Note: Hard Code Username and SAME Password: All Users (Employees and Volunteers)
#     • 3 Employee Users username: 'emp#' firstname: 'Site#' lastname: 'Employee#' password value="gatech123"
#         o Assign 'emp1' to 'site1'
#         o Assign 'emp2' to 'site2'
#         o Assign 'emp3' to 'site3'
#     • 3 Volunteer Users username: 'vol#' firstname: 'Site#' lastname: Volunteer# password value="gatech123"
#         o Assign 'vol1' to 'site1'
#         o Assign 'vol2' to 'site2'
#         o Assign 'vol3' to 'site3'

INSERT INTO `User` (SiteID, UserName, Password, FullName, Email) VALUES
	(1, 'emp1', 'gatech123', 'Employee #1', 'emp1@asacs.com'),
	(2, 'emp2', 'gatech123', 'Employee #2', 'emp2@asacs.com'),
	(3, 'emp3', 'gatech123', 'Employee #3', 'emp3@asacs.com'),
	(1, 'vol1', 'gatech123', 'Volunteer #1', 'vol1@asacs.com'),
	(2, 'vol2', 'gatech123', 'Volunteer #2', 'vol2@asacs.com'),
	(3, 'vol3', 'gatech123', 'Volunteer #3', 'vol3@asacs.com');

# Clients:
#     • 12 Clients firstname: either 'Joe' or ‘Jane’ lastname: 'Client#' id: TestID#
#         o Examples: ‘Joe Client1/TestID1’, ‘Jane Client2/TestID2’, … ‘Joe Client12/TestID12’. (6 Joe’s, and 6 Jane’s-12 total)

INSERT INTO Client (FullName, IDOrDescription, PhoneNumber) VALUES
	('Joe Client1', 'TestID1', '111-111-1111'),    
	('Joe Client2', 'TestID2', '222-222-2222'),    
	('Joe Client3', 'TestID3', '333-333-3333'),    
	('Joe Client4', 'TestID4', '444-444-4444'),    
	('Joe Client5', 'TestID5', '555-555-5555'),    
	('Joe Client6', 'TestID6', '666-666-6666'),
    ('Jane Client7', 'TestID7', '777-777-8888'),    
	('Jane Client8', 'TestID8', '888-888-8888'),    
	('Jane Client9', 'TestID9', '999-999-9999'),    
	('Jane Client10', 'TestID10', '101-010-1010'),    
	('Jane Client11', 'TestID11', '111-111-1111'),    
	('Jane Client12', 'TestID12', '121-212-1212');
	
# Services:
#     • 9 Services: (Note: generally service names match site number)
#         o 2 Food Pantries (description, hours of operation, conditions) use description: ('pantry1', 'pantry2', etc.)
#         o 2 Soup Kitchens (description, hours of operation, conditions, seats_avail, seats_total) use description: ('soup2', 'soup3', etc.)
#         o 2 Shelters (description, hours of operation, conditions) use description: ('shelter2', 'shelter3', etc.)
#         o 3 Food Banks
#         o Assign 'pantry1' service to 'site1' (site1 has only 1 client service initially- 1 pantry)
#         o Assign only FoodBankID=1 to 'site1' (Other client services- soup1/shelter1- will be added to 'site1' during the demo)
#         o Assign 'soup2' service to 'site2'
#         o Assign 'shelter2' service to 'site2' (site2 has 2 client services initially- 1 soup, 1 shelter)
#         o Assign only FoodBankID=2 to 'site2'
#         o Assign 'pantry3' service to 'site3'
#         o Assign 'soup3' service to 'site3' (Note: 'pantry2' is intentionally missing to maintain site#, client_service_desc# pairing)
#         o Assign 'shelter3' service to 'site3' (site3 has all 3 client services initially- 1 pantry, 1 soup, 1 shelter)
#         o Assign only FoodBbankID=3 to 'site3' (Note: only FoodBankID=3 contains all expired food products)
#
# Shelter Rooms:
#     • Each Shelter: 2 bunks each type: men, woman, mixed (6 per shelter)
#         o 1 Male only room with 2 bunks
#         o 1 Female only room with 2 bunks
#         o 1 Mixed room with 2 bunks
#     • During Demo: all 12 clients will fill up both shelters to prompt for “shelters at maximum capacity”

INSERT INTO FoodPantryService (ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse) VALUES
	(1, 1, 'pantry1', 'pantry1', 'pantry1'),
	(2, 3, 'pantry3', 'pantry3', 'pantry3');
    
INSERT INTO SoupKitchenService (ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse, SeatsAvailable, TotalCapacity) VALUES
	(3, 2, 'soup2', 'soup2', 'soup2', 100, 100),
	(4, 3, 'soup3', 'soup3', 'soup3', 100, 100);
    
INSERT INTO ShelterService (ServiceID, SiteID, Description, HoursOfOperation, ConditionsOfUse, MaleBunkCount, FemaleBunkCount, MixedBunkCount, MaleBunksAvailable, FemaleBunksAvailable, MixedBunksAvailable) VALUES
	(5, 2, 'shelter2', 'shelter2', 'shelter2', 2, 2, 2, 2, 2, 2),
	(6, 3, 'shelter3', 'shelter3', 'shelter3', 2, 2, 2, 2, 2, 2);    
    
INSERT INTO FoodBankService (ServiceID, SiteID) VALUES
	(7, 1),
	(8, 2),
	(9, 3); 
    
# Client Activity:
# • 12 Clients: 3 Client Log entries per Client (36 total) – examples: create/modify profile, check-in to room, provide a meal, etc. 
#     o Example: client1_log1 = “profile created…” , timestamp, etc.
#     client1_log2 = “meal provided by…” site, timestamp, etc.
#     client1_log3 = “profile edited/updated…”, timestamp, etc.
#     …
#     client12_log3 = “check-in to room” … (each client has a profile created and some logs for services used)
#     o 'client1' … client4' visit 'pantry1' at 'site1' (clients 1-4 are ‘pantry’ clients)
#     o 'client5' … client8' visit 'soup2' at 'site2' (clients 5-8 are ‘soup’ clients)
#     o 'client1' … ‘client12' visit 'shelter2' at 'site2' (clients 1-12 are ‘shelter’ clients)
#     o 'client1' … 'client4' visit 'pantry3' at 'site3'
#     o 'client5' … 'client8' visit 'soup3' at 'site3'
#     o 'client1' … 'client12' visit 'shelter3' at 'site3'
# '

INSERT INTO ClientLog(ClientID, TimeStamp, ServiceID, Description, Notes) VALUES
    (1, NOW() - INTERVAL 2 DAY - INTERVAL 1 HOUR, 1, 'check-in', 'checkin: Joe Client1 to pantry1'),
    (2, NOW() - INTERVAL 2 DAY - INTERVAL 1 HOUR, 1, 'check-in', 'checkin: Joe Client2 to pantry1'),
    (3, NOW() - INTERVAL 2 DAY - INTERVAL 1 HOUR, 1, 'check-in', 'checkin: Joe Client3 to pantry1'),
    (4, NOW() - INTERVAL 2 DAY - INTERVAL 1 HOUR, 1, 'check-in', 'checkin: Joe Client4 to pantry1'),
    
    (5, NOW() - INTERVAL 2 DAY - INTERVAL 2 HOUR, 3, 'check-in', 'checkin: Joe Client5 to soup2'),
    (6, NOW() - INTERVAL 2 DAY - INTERVAL 2 HOUR, 3, 'check-in', 'checkin: Joe Client6 to soup2'),
    (7, NOW() - INTERVAL 2 DAY - INTERVAL 2 HOUR, 3, 'check-in', 'checkin: Jane Client7 to soup2'),
    (8, NOW() - INTERVAL 2 DAY - INTERVAL 2 HOUR, 3, 'check-in', 'checkin: Jane Client8 to soup2'),

    (1, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client1 to shelter2'),
    (2, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client2 to shelter2'),
    (3, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client3 to shelter2'),
    (4, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client4 to shelter2'),
    (5, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client5 to shelter2'),
    (6, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Joe Client6 to shelter2'),
    (7, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client7 to shelter2'),
    (8, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client8 to shelter2'),
    (9, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client9 to shelter2'),
    (10, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client10 to shelter2'),
    (11, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client11 to shelter2'),
    (12, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 5, 'check-in', 'checkin: Jane Client12 to shelter2'),
    
    (1, NOW() - INTERVAL 1 DAY - INTERVAL 4 HOUR, 2, 'check-in', 'checkin: Joe Client1 to pantry3'),
    (2, NOW() - INTERVAL 1 DAY - INTERVAL 4 HOUR, 2, 'check-in', 'checkin: Joe Client2 to pantry3'),
    (3, NOW() - INTERVAL 1 DAY - INTERVAL 4 HOUR, 2, 'check-in', 'checkin: Joe Client3 to pantry3'),
    (4, NOW() - INTERVAL 1 DAY - INTERVAL 4 HOUR, 2, 'check-in', 'checkin: Joe Client4 to pantry3'),    

    (5, NOW() - INTERVAL 1 DAY - INTERVAL 5 HOUR, 4, 'check-in', 'checkin: Joe Client5 to soup3'),
    (6, NOW() - INTERVAL 1 DAY - INTERVAL 5 HOUR, 4, 'check-in', 'checkin: Joe Client6 to soup3'),
    (7, NOW() - INTERVAL 1 DAY - INTERVAL 5 HOUR, 4, 'check-in', 'checkin: Jane Client7 to soup3'),
    (8, NOW() - INTERVAL 1 DAY - INTERVAL 5 HOUR, 4, 'check-in', 'checkin: Jane Client8 to soup3'),    

    (1, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client1 to shelter3'),
    (2, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client2 to shelter3'),
    (3, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client3 to shelter3'),
    (4, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client4 to shelter3'),
    (5, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client5 to shelter3'),
    (6, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Joe Client6 to shelter3'),
    (7, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client7 to shelter3'),
    (8, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client8 to shelter3'),
    (9, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client9 to shelter3'),
    (10, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client10 to shelter3'),
    (11, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client11 to shelter3'),
    (12, NOW() - INTERVAL 1 DAY - INTERVAL 6 HOUR, 6, 'check-in', 'checkin: Jane Client12 to shelter3');

# Items: Each food bank has very specific items that are unique to that foodbank.
# The purpose of these bank specific items is to know which bank the item
# came from, so TAs can verify if your logged in user should be able to modify those items or not.
#     • Food Bank 1 (bankID=1) Notice: bankID=1 has nuts, soda/pop drinks where the other banks do not.
#         o 2 Food Items: (storage_type= refrigerated, food_catogory=vegetables) (only insert leafy vegetables into this bank)
#         o 2 Food Items: (storage_type=drygoods, food_catogory=nuts/grains/beans) (only insert nuts products into this bank)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory= juice/drink) (only insert soda/pop drinks items in this bank)
#         o 2 Food Items: (storage_type=frozen, food_catogory=meat/seafood) (only insert red-meat only items in this bank)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory=dairy/eggs) (only insert cheese products in this bank)
#         o 5 Supply Items: (type: personal hygiene) examples: toothbrush, toothpaste, shampoo, deodorant, soap/detergent, baby wipes, etc.
#         o 5 Supply Items: (type: clothing) examples: shirts, pants, underwear, etc.

INSERT INTO Item(FoodBankServiceID, Category, SubCategory, Name, Units, ExpirationDate, StorageType) VALUES
    (7, 'food_item', 'vegetables', 'Iceberg Lettuce', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (7, 'food_item', 'vegetables', 'Cabbage', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),

    (7, 'food_item', 'nuts/grains/beans', 'Peanuts', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),
    (7, 'food_item', 'nuts/grains/beans', 'Cashews', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),

    (7, 'food_item', 'juice/drink', 'Diet Coke', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (7, 'food_item', 'juice/drink', 'Mountain Dew', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),

    (7, 'food_item', 'meat/seafood', 'Ground Beef', 999, NOW() + INTERVAL 5 DAY, 'frozen'),
    (7, 'food_item', 'meat/seafood', 'Sirloin Steak', 999, NOW() + INTERVAL 5 DAY, 'frozen'),

    (7, 'food_item', 'dairy/eggs', 'Mild Cheddar Cheese', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (7, 'food_item', 'dairy/eggs', 'Sharp Cheddar Cheese', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    
    (7, 'supply_item', 'personal_hygiene', 'Toothbrush', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'personal_hygiene', 'Toothpaste', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'personal_hygiene', 'Shampoo', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'personal_hygiene', 'Deodorant', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'personal_hygiene', 'Hand Soap', 999, '2099-12-31', 'drygoods'),
    
    (7, 'supply_item', 'clothing', 'Men\'s Shirt (XL)', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'clothing', 'Womans\'s Blouse (M)', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'clothing', 'Boy\'s Shirt (4-5)', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'clothing', 'Girl\'s Shirt (7-8)', 999, '2099-12-31', 'drygoods'),
    (7, 'supply_item', 'clothing', 'Men\'s Undershirt (L)', 999, '2099-12-31', 'drygoods'),    
    
#     • Food Bank 2 (bankID=2) Notice: bankID=2 has grains, fruit-juices, and seafood where the other banks do not.
#         o 2 Food Items: (storage_type= refrigerated, food_catogory=vegetables) (only insert root veggies into this bank)
#         o 2 Food Items: (storage_type=drygoods, food_catogory= nuts/grains/beans) (only insert grains only items in this bank)
#         o 2 Food Items: (storage_type=drygoods, food_catogory=sauce/condiments)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory= juice/drink) (only insert fruit juice only items in this bank)
#         o 2 Food Items: (storage_type=frozen, food_catogory= meat/seafood) (only insert seafood only items in this bank)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory= dairy/eggs) (only insert egg containing products in this bank)
#         o 5 Supply Items: (type: shelter) examples: tent, sleeping bags, blankets, winter jackets, rain coat, etc.
#         o 5 Supply Items: (type: other) examples: paper products, toilet paper, pet food, batteries, etc.

    (8, 'food_item', 'vegetables', 'Carrots', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (8, 'food_item', 'vegetables', 'Turnips', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),

    (8, 'food_item', 'nuts/grains/beans', 'Rice', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),
    (8, 'food_item', 'nuts/grains/beans', 'Organic Wheat', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),

    (8, 'food_item', 'sauce/condiments', 'Ketchup', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),
    (8, 'food_item', 'sauce/condiments', 'Mayonaise', 999, NOW() + INTERVAL 5 DAY, 'drygoods'),
        
    (8, 'food_item', 'juice/drink', 'Orange Juice', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (8, 'food_item', 'juice/drink', 'Apple Juice', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    
    (8, 'food_item', 'meat/seafood', 'Peeled Shrimp', 999, NOW() + INTERVAL 5 DAY, 'frozen'),
    (8, 'food_item', 'meat/seafood', 'Lobster Tail', 999, NOW() + INTERVAL 5 DAY, 'frozen'),

    (8, 'food_item', 'dairy/eggs', 'AA Grade Eggs', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),
    (8, 'food_item', 'dairy/eggs', 'B Grade Eggs', 999, NOW() + INTERVAL 5 DAY, 'refrigerated'),

    (8, 'supply_item', 'shelter', 'Tent', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'shelter', 'Sleeping Bag (Adult)', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'shelter', 'Sleeping Bag (Child)', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'shelter', 'Blanket', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'shelter', 'Rain Coat (Adult)', 999, '2099-12-31', 'drygoods'),

    (8, 'supply_item', 'other', 'Toilet Paper', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'other', 'Small Breed Dog Food', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'other', 'Paper Towels', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'other', 'Baby Wipes', 999, '2099-12-31', 'drygoods'),
    (8, 'supply_item', 'other', '9V Batteries', 999, '2099-12-31', 'drygoods'),        
    
#     • Food Bank 3 all expired products: 10 days older than current date (bankID=3)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory= meat/seafood) (only insert expired chicken products only)
#         o 2 Food Items: (storage_type=refrigerated, food_catogory= dairy/eggs) (only insert expired milk (non-cheese) products only) 

    (9, 'food_item', 'meat/seafood', 'Chicken Drumstick', 999, NOW() - INTERVAL 5 DAY, 'refrigerated'),
    (9, 'food_item', 'meat/seafood', 'Chicken Breast', 999, NOW() - INTERVAL 5 DAY, 'refrigerated'),

    (9, 'food_item', 'dairy/eggs', '2% Milk (1 gallon)', 999, NOW() - INTERVAL 5 DAY, 'refrigerated'),
    (9, 'food_item', 'dairy/eggs', 'Vitamin D Milk (1/2 gallon)', 999, NOW() - INTERVAL 5 DAY, 'refrigerated');
    