use housebook;

/*------------------------------ Create Table ------------------------------*/

#User/Buyer/Agent/Salesman/Administrator
CREATE TABLE userAddress(
	address_id int not null AUTO_INCREMENT,
	address1 varchar(50), 	#4101 Bigelow Blvd.
	address2 varchar(50), 	#Apt 133
	city varchar(30),     	#Pittsburgh
	state varchar(30),    	#PA
	zipcode int,      		#15213
    PRIMARY KEY(address_id),
    CONSTRAINT CHK_ValidState CHECK (CHAR_LENGTH(state) = 2 AND state = UPPER(state)),
    CONSTRAINT CHK_ValidZipcode CHECK (CHAR_LENGTH(zipcode) = 5)
);
CREATE TABLE users(
	user_id int not null AUTO_INCREMENT,
	first_name varchar(50),
	middle_name varchar(50), 
	last_name varchar(50), 
	organization_name varchar(150),
	user_gender varchar(10), 	#F/M
	user_address int,
	user_phone varchar(50),
	user_email varchar(100),
    user_role varchar(50),		#ADMIN/AGENT/SALESMAN/BUYER
	user_account varchar(50),
	passward varchar(50),
	create_datetime datetime,  	#create user date and time
	delete_datetime datetime,  	#delete user date and time
	is_delete int,  			#0:active / 1:deleted
    PRIMARY KEY(user_id),
    FOREIGN KEY(user_address) REFERENCES userAddress(address_id),
    CONSTRAINT check_user_type 
    CHECK (
    (first_name IS NOT NULL AND last_name IS NOT NULL AND organization_name IS NULL AND user_role <> 'AGENT') 
    OR (first_name IS NULL AND middle_name IS NULL AND last_name IS NULL AND organization_name IS NOT NULL AND user_gender IS NULL AND user_role='AGENT')
    ),
    CONSTRAINT CHK_ValidEmail CHECK (user_email like '%@%')
);
CREATE TABLE userPhoto(
	userPhoto_id int not null auto_increment,
    user_id int not null,
	photo text,   #photo path
	PRIMARY KEY(userPhoto_id, user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE buyer(
	buyer_id int not null AUTO_INCREMENT, #80001
	user_id int not null,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int,  #0/1
    PRIMARY KEY(buyer_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE buyer AUTO_INCREMENT=80001;
CREATE TABLE agent(
	agent_id int not null AUTO_INCREMENT, #10001
    user_id int not null,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int, #0/1
	PRIMARY KEY(agent_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE agent AUTO_INCREMENT=10001;
CREATE TABLE store(
	store_id int not null AUTO_INCREMENT,
	store_name varchar(30) not null,
	store_region varchar(30),
    agent_id int not null,
	PRIMARY KEY(store_id, agent_id),
    FOREIGN KEY(agent_id) REFERENCES agent(agent_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE salesman(
	salesman_id int not null AUTO_INCREMENT, #70001
	user_id int not null,
	agent_id int,
	store_id int,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int,
    PRIMARY KEY(salesman_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(agent_id) REFERENCES agent(agent_id),
    FOREIGN KEY(store_id) REFERENCES store(store_id)
);
ALTER TABLE salesman AUTO_INCREMENT=70001;
CREATE TABLE administrator(
	admin_id int not null AUTO_INCREMENT,
    user_id int not null,
    job_title varchar(100),
    member_introduction text,
    PRIMARY KEY(admin_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

#Role & Grant Permission
CREATE TABLE userRole(
	user_id int not null,	
    user_role varchar(50),			#ADMIN/BUYER/SALESMAN/AGENT
	PRIMARY KEY(user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE grantRoleFeatures(
	user_role varchar(50) not null,	#ADMIN/BUYER/SALESMAN/AGENT
    features varchar(50), 			#HomePage/CreatePost/MyProfile/MyPost/MyOrder/MyReview
    features_value text				#e.g. variable value using in the system
);

#Property
CREATE TABLE propertyAddress(
	address_id int not null AUTO_INCREMENT, 
	address1 varchar(50), 	#4101 Bigelow Blvd.
	address2 varchar(50),	#Apt 133
	city varchar(30),		#Pittsburgh
	state varchar(30),		#PA
	zipcode int,			#15213
    PRIMARY KEY(address_id),
	CONSTRAINT CHK_ValidPropertyItemState CHECK (CHAR_LENGTH(state) = 2 AND state = UPPER(state)),
    CONSTRAINT CHK_ValidPropertyItemZipcode CHECK (CHAR_LENGTH(zipcode) = 5)
);
CREATE TABLE property(
	property_id int not null AUTO_INCREMENT,
    property_name varchar(30),	#Schenley Apartment
    property_type varchar(30),	#Apartment/Condo/House/Single-family/Townhouse (from lookUpTable)
	city varchar(30),			#Pittsburgh
	state varchar(10),			#PA
	zipcode int,				#15213
    PRIMARY KEY(property_id),
	CONSTRAINT CHK_ValidPropertyState CHECK (CHAR_LENGTH(state) = 2 AND state = UPPER(state)),
    CONSTRAINT CHK_ValidPropertyZipcode CHECK (CHAR_LENGTH(zipcode) = 5)
);
CREATE TABLE propertyItem(
	item_id int not null AUTO_INCREMENT,
	property_id int not null,
    address_id int not null,
    #property_address int not null,
	item_type varchar(50),		#2B2B/1B1.5B/STUDIO/..
    capacity int, 				#2000 sqft
	item_bedroom float, 		#2/1
	item_bathroom float, 		#2/1.5
    salesman_id int not null, 	#70001 | one property item, one salesperson
	PRIMARY KEY(item_id),
    FOREIGN KEY(property_id) REFERENCES property(property_id),
    FOREIGN KEY(address_id) REFERENCES propertyAddress(address_id),
	FOREIGN KEY(salesman_id) REFERENCES salesman(salesman_id)
);
CREATE TABLE propertyItemImages(
    image_id int not null AUTO_INCREMENT,
    item_id int not null,
	image text,   #image path
    PRIMARY KEY(image_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE propertyItemPayment(
	payment_id int not null,
    item_id int not null, 
    payment_name varchar(50) not null, 		#Price/Homeowners Insurance/HOA/Property taxes
    payment_amount decimal(10, 2) not null,	#180000/50/100/150
    PRIMARY KEY(item_id, payment_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) ON DELETE CASCADE ON UPDATE CASCADE
);
#如果我們要用的欄位比較單純可以考慮這種
/*CREATE TABLE propertyItemFeatures1(
	feature_id int,
	item_id int,
    kitchen int, 			#有無:0/1? 或是要寫內容再改成varchar
	wifi int,    			#有無:check/1?
	heating int, 			#有無:0/1?
	air_conditioning int,	#有無:0/1?
	parking int,
    gym int, 
	PRIMARY KEY(feature_id, item_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id)
);*/
#如果需要寫很多feature 這種寫法比較容易擴充 有新增欄位可以不修改attribute
CREATE TABLE propertyItemFeatures(
	feature_id int not null auto_increment,		#1/2/3/4/5/...
	item_id int,				#100
    featutre_type varchar(50),	#Parking;Facilities;Equipments (from lookUpTable)
    feature_name varchar(50),	#Parking/Garage; swimming pools/gyms; Cooktop/Dishwasher/Disposal/Microwave/Refrigerator/Stove (from lookUpTable)
    feature_value varchar(50),	#寫內容：On Street Parking/Attached Garage; 或只寫有無：Y/Y; Y/Y/N/Y/Y/Y
    PRIMARY KEY(feature_id, item_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE label(
	label_id int,					#1/2/3/4/...
    label varchar(50),				#OPEN HOUSE/New/School Districts
    label_description varchar(50),	#description of this label
	PRIMARY KEY(label_id)
);
CREATE TABLE propertyItemLabel(
    item_id int,	#100
    label_id int,	#4
	PRIMARY KEY(label_id, item_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(label_id) REFERENCES Label(label_id) ON DELETE CASCADE ON UPDATE CASCADE
);

#Transcation
CREATE TABLE transactions(
	transaction_id int not null, 
	buyer_id int not null,
	salesman_id int not null,
	propertyItem_id int not null,
	transaction_datetime datetime,
    delete_datetime datetime,
    is_delete int,
	PRIMARY KEY(transaction_id),
    FOREIGN KEY(buyer_id) REFERENCES buyer(buyer_id) ON UPDATE CASCADE,
	FOREIGN KEY(salesman_id) REFERENCES salesman(salesman_id) ON UPDATE CASCADE,
    FOREIGN KEY(propertyItem_id) REFERENCES propertyItem(item_id) ON UPDATE CASCADE
);
CREATE TABLE transactionsReview(
	review_id int not null, 
    transaction_id int not null,
    rating decimal(3,1) not null,	#5/4.5
    review text,					#Allen was great to work with he was very available and made buying a home an easy process.
    PRIMARY KEY(review_id),
    FOREIGN KEY(transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE ON UPDATE CASCADE
);

#LookUp
CREATE TABLE lookUpTable(
	lookUp_category varchar(200) not null,	#Property ; Property; Property
    lookUp_name varchar(200) not null,		#HouseType ; Payment; FeaturesType ; 
    lookUp_value1 varchar(200),				#Single House/Condo/Apartment/Townhouse/...; Price/HOA/Insurance/Taxs ; Facilities
    lookUp_value2 varchar(200),				#Swimming Pools/Gyms
    lookUp_value3 varchar(200),
	lookUp_value4 varchar(200),
    lookUp_value5 varchar(200),
    lookUp_descriptoin varchar(200)
);

#INDEX
CREATE INDEX index_user_name ON users (last_name, first_name);
CREATE INDEX index_property_name ON property (property_name);

#If we want to Add more CONSTRAINT
#ALTER TABLE users ADD CONSTRAINT CHK_PersonAge CHECK (expression);
#ALTER TABLE userAddress ADD CONSTRAINT CHK_ValidState CHECK (state in (select lookUp_value2 from lookUpTable where lookUp_category='Address' and lookUp_name='STATE'));

/*------------------------------ Select Table ------------------------------*/
#User/Buyer/Agent/Salesman/Administrator
select * from users;
select * from userAddress;
select * from userPhoto;
select * from buyer;
select * from agent;
select * from store;
select * from salesman;
select * from administrator;

#Role & Grant
select * from userRole;
select * from grantRoleFeatures;

#Property
select * from propertyAddress;
select * from property;
select * from propertyItem;
select * from propertyItemImages;
select * from propertyItemPayment;
select * from propertyItemFeatures;
select * from label;
select * from propertyItemLabel;

#Transcations
select * from transactions;
select * from transactionsReview;

#LookUp
select * from lookUpTable;

#delete & update
#delete from userAddress where address_id=3;
#update userAddress set address2='Suite 566' where address_id=2;

/*------------------------------ DROP FOREIGN KEY & INDEX------------------------------*/
#User/Buyer/Agent/Salesman
ALTER TABLE users DROP FOREIGN KEY users_ibfk_1;
ALTER TABLE userPhoto DROP FOREIGN KEY userPhoto_ibfk_1;
ALTER TABLE buyer DROP FOREIGN KEY buyer_ibfk_1;
ALTER TABLE agent DROP FOREIGN KEY agent_ibfk_1;
ALTER TABLE store DROP FOREIGN KEY store_ibfk_1;
ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_1;
ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_2;
ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_3;
ALTER TABLE administrator DROP FOREIGN KEY administrator_ibfk_1;

#Role & Grant
ALTER TABLE userRole DROP FOREIGN KEY userRole_ibfk_1;

#Property
ALTER TABLE propertyItem DROP FOREIGN KEY propertyItem_ibfk_1;
ALTER TABLE propertyItem DROP FOREIGN KEY propertyItem_ibfk_2;
ALTER TABLE propertyItem DROP FOREIGN KEY propertyItem_ibfk_3;
ALTER TABLE propertyItemImages DROP FOREIGN KEY propertyItemImages_ibfk_1;
ALTER TABLE propertyItemPayment DROP FOREIGN KEY propertyItemPayment_ibfk_1;
#ALTER TABLE propertyItemFeatures1 DROP FOREIGN KEY propertyItemFeatures1_ibfk_1;
ALTER TABLE propertyItemFeatures DROP FOREIGN KEY propertyItemFeatures_ibfk_1;
ALTER TABLE propertyItemLabel DROP FOREIGN KEY propertyItemLabel_ibfk_1;
ALTER TABLE propertyItemLabel DROP FOREIGN KEY propertyItemLabel_ibfk_2;

#Transcations
ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_1;
ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_2;
ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_3;
ALTER TABLE transactionsReview DROP FOREIGN KEY transactionsReview_ibfk_1;

#Index
ALTER TABLE users DROP INDEX index_user_name;
ALTER TABLE property DROP INDEX index_property_name;

/*------------------------------ DROP TABLE ------------------------------*/
#User/Buyer/Agent/Salesman
DROP TABLE userAddress;
DROP TABLE users;
DROP TABLE userPhoto;
DROP TABLE buyer;
DROP TABLE agent;
DROP TABLE store;
DROP TABLE salesman;
DROP TABLE administrator;

#Role & Grant
DROP TABLE userRole;
DROP TABLE grantRoleFeatures;

#Property
DROP TABLE propertyAddress;
DROP TABLE property;
DROP TABLE propertyItem;
DROP TABLE propertyItemImages;
DROP TABLE propertyItemPayment;
#DROP TABLE propertyItemFeatures1;
DROP TABLE propertyItemFeatures;
DROP TABLE label;
DROP TABLE propertyItemLabel;

#Transaction & Review
DROP TABLE transactions;
DROP TABLE transactionsReview;

#LookUp
DROP TABLE lookUpTable;


/*------------------------------ Insert Data ------------------------------*/

INSERT INTO userAddress (address1, address2, city, state, zipcode) VALUES
('4101 Bigelow Blvd.', 'Apt 133', 'Pittsburgh', 'PA', 15213),('123 Main St', 'Suite 567', 'Anytown', 'CA', 90210),
('789 Oak Lane', NULL, 'Smallville', 'NY', 56789),('456 Elm Street', 'Unit 101', 'Metro City', 'IL', 67890),
('999 Pine Avenue', NULL, 'Greenfield', 'TX', 34567),('321 Maple Drive', 'Apt 45', 'Riverside', 'FL', 45678),
('555 Cedar Street', NULL, 'Meadowville', 'OH', 23456),('777 Birch Road', 'Apt 22', 'Mountain View', 'CA', 87654),
('222 Spruce Lane', NULL, 'Hometown', 'WA', 54321),('888 Walnut Circle', 'Unit 77', 'Harbor City', 'OR', 76543);

INSERT INTO users (first_name, middle_name, last_name, organization_name, user_gender, user_address, user_phone, user_email, user_role, user_account, passward, create_datetime, delete_datetime, is_delete) VALUES
#1-10 Buyer
('John', 'A.', 'Doe', NULL, 'M', 1, 1234567890, 'john.doe@example.com', 'BUYER', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
('Jane', 'B.', 'Smith', NULL, 'F', 2, 9876543210, 'jane.smith@example.com', 'BUYER',  'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
('Bob', 'C.', 'Johnson', NULL, 'M', 3, 5555555555, 'bob.johnson@example.com', 'BUYER', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
('Emily', NULL, 'Williams', NULL, 'F', 4, 1111111111, 'emily.williams@example.com', 'BUYER', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
('Mike', 'D.', 'Miller', NULL, 'M', 5, 9999999999, 'mike.miller@example.com', 'BUYER', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
('Sarah', 'E.', 'Davis', NULL, 'F', 6, 3333333333, 'sarah.davis@example.com', 'BUYER', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
('Tom', 'F.', 'Brown', NULL, 'M', 7, 7777777777, 'tom.brown@example.com', 'BUYER', 'tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
('Anna', 'G.', 'Lee', NULL, 'F', 8, 8888888888, 'anna.lee@example.com', 'BUYER', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
('Chris', NULL, 'Clark', NULL, 'M', 9, 2222222222, 'chris.clark@example.com', 'BUYER', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
('Emma', 'H.', 'White', NULL, 'F', 10, 4444444444, 'emma.white@example.com', 'BUYER', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0),
#11-21 Agent
(NULL, NULL, NULL, 'X Corp', NULL, 1, 1234567890, 'john.doe@example.com', 'AGENT', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
(NULL, NULL, NULL, 'Y Corp', NULL, 2, 9876543210, 'jane.smith@example.com', 'AGENT', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
(NULL, NULL, NULL, 'ABC Corp', NULL, 3, 5555555555, 'bob.johnson@example.com', 'AGENT', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
(NULL, NULL, NULL, 'XYZ Corp', NULL, 4, 1111111111, 'emily.williams@example.com', 'AGENT', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
(NULL, NULL, NULL, 'CC Corp', NULL, 5, 9999999999, 'mike.miller@example.com', 'AGENT', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
(NULL, NULL, NULL, 'LMN Ltd', NULL, 6, 3333333333, 'sarah.davis@example.com', 'AGENT', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
(NULL, NULL, NULL, 'Z Corp', NULL, 7, 7777777777, 'tom.brown@example.com', 'AGENT','tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
(NULL, NULL, NULL, 'A Corp', NULL, 8, 8888888888, 'anna.lee@example.com', 'AGENT','anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
(NULL, NULL, NULL, 'PQR Ltd', NULL, 9, 2222222222, 'chris.clark@example.com', 'AGENT', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
(NULL, NULL, NULL, 'BB Corp', NULL, 10, 4444444444, 'emma.white@example.com', 'AGENT', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0),
#21-30 Salesman
('John', 'A.', 'Doe', NULL, 'M', 1, 1234567890, 'john.doe@example.com', 'SALESMAN', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
('Jane', 'J.', 'Smith', NULL, 'F', 2, 9876543210, 'jane.smith@example.com', 'SALESMAN', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
('Bob', 'D.', 'Johnson', NULL, 'M', 3, 5555555555, 'bob.johnson@example.com', 'SALESMAN', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
('Emily', NULL, 'Williams', NULL, 'F', 4, 1111111111, 'emily.williams@example.com', 'SALESMAN', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
('Mike', 'E.', 'Miller', NULL, 'M', 5, 9999999999, 'mike.miller@example.com', 'SALESMAN', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
('Sarah', 'E.', 'Davis', NULL, 'F', 6, 3333333333, 'sarah.davis@example.com', 'SALESMAN', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
('Tom', 'C.', 'Brown', NULL, 'M', 7, 7777777777, 'tom.brown@example.com', 'SALESMAN', 'tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
('Anna', 'G.', 'Lee', NULL, 'F', 8, 8888888888, 'anna.lee@example.com', 'SALESMAN', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
('Chris', NULL, 'Clark', NULL, 'M', 9, 2222222222, 'chris.clark@example.com', 'SALESMAN', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
('Emma', 'A.', 'White', NULL, 'F', 10, 4444444444, 'emma.white@example.com', 'SALESMAN', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0),
#31-34 Administrator
('Pei Chieh (Jessie)', NULL, 'Chen', NULL, 'F', 1, 7777777777, 'jessie.chen@example.com', 'ADMIN','jessiechen_777', 'whitePass', '2023-11-14 09:10:00', NULL, 0),
('Josh', NULL, 'Cho', NULL, 'M', 1, 8888888888, 'josh.cho@example.com', 'ADMIN', 'joshchu', 'passward', '2023-11-14 09:10:00', NULL, 0),
('Si-Lian', NULL, 'Wu', NULL, 'M', 1, 7777777777, 'jessie.chen@example.com', 'ADMIN', 'jessiechen', 'whitePass', '2023-11-14 09:10:00', NULL, 0),
('BB', NULL, 'Cho', NULL, 'M', 1, 8888888888, 'josh.cho@example.com', 'ADMIN', 'joshchu3', 'passward', '2023-11-14 09:10:00', NULL, 0),
#35-40 user
('John', 'A.', 'Doe', NULL, 'M', 1, 1234567890, 'john.doe@example.com', 'USER', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
('Jane', 'B.', 'Smith', NULL, 'F', 2, 9876543210, 'jane.smith@example.com', 'USER', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
('Bob', 'C.', 'Johnson', NULL, 'M', 3, 5555555555, 'bob.johnson@example.com', 'USER', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
('Emily', NULL, 'Williams', NULL, 'F', 4, 1111111111, 'emily.williams@example.com', 'USER', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
('Mike', 'D.', 'Miller', NULL, 'M', 5, 9999999999, 'mike.miller@example.com', 'USER', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
('Anna', 'G.', 'Lee', NULL, 'F', 8, 8888888888, 'anna.lee@example.com', 'USER', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0);

INSERT INTO userPhoto (user_id, photo) VALUES 
(31, 'css/user_photo/Jessie1.jpg'),(32, 'css/user_photo/Josh1.jpg'), (33, 'css/user_photo/Angelo1.jpg'), (34, 'css/user_photo/user2.jpg');

INSERT INTO buyer (user_id, create_datetime, delete_datetime, is_delete) VALUES
(1, '2023-01-01 08:30:00', NULL, 0),(2, '2023-02-15 11:00:00', NULL, 0),(3, '2023-03-20 16:00:00', NULL, 0),
(4, '2023-04-05 13:00:00', NULL, 0),(5, '2023-05-10 12:00:00', NULL, 0),(6, '2023-06-25 10:00:00', NULL, 0),
(7, '2023-07-30 15:30:00', NULL, 0),(8, '2023-08-12 18:30:00', NULL, 0),(9, '2023-09-18 14:00:00', NULL, 0),
(10, '2023-10-05 17:00:00', NULL, 0);

INSERT INTO agent (user_id, create_datetime, delete_datetime, is_delete) VALUES
(11, '2023-01-01 09:00:00', NULL, 0),(12, '2023-02-15 12:30:00', NULL, 0),(13, '2023-03-20 17:45:00', NULL, 0),
(14, '2023-04-05 14:30:00', NULL, 0),(15, '2023-05-10 13:30:00', NULL, 0),(16, '2023-06-25 11:30:00', NULL, 0),
(17, '2023-07-30 16:15:00', NULL, 0),(18, '2023-08-12 19:00:00', NULL, 0),(19, '2023-09-18 15:15:00', NULL, 0),
(20, '2023-10-05 18:00:00', NULL, 0);

INSERT INTO store (store_name, store_region, agent_id) VALUES
('SuperMart', 'North', 10001),('MegaStore', 'East', 10002),('CityGrocery', 'West', 10003),('NeighborhoodMart', 'South', 10004),
('QuickShop', 'Central', 10005),('CornerStore', 'North', 10006),('TownMarket', 'East', 10007),('LocalMart', 'West', 10008),
('VillageGrocery', 'South', 10009),('ExpressMart', 'Central', 10010);

INSERT INTO salesman (store_id, user_id, agent_id, create_datetime, delete_datetime, is_delete) VALUES
(1, 21, 10001, '2023-01-01 10:30:00', NULL, 0),(2, 22, 10002, '2023-02-15 13:30:00', NULL, 0),
(3, 23, 10003, '2023-03-20 19:00:00', NULL, 0),(4, 24, 10004, '2023-04-05 16:15:00', NULL, 0),
(5, 25, 10005, '2023-05-10 15:15:00', NULL, 0),(6, 26, 10006, '2023-06-25 13:15:00', NULL, 0),
(7, 27, 10007, '2023-07-30 18:30:00', NULL, 0),(8, 28, 10008, '2023-08-12 21:15:00', NULL, 0),
(9, 29, 10009, '2023-09-18 17:30:00', NULL, 0),(10, 30, 10010, '2023-10-05 20:15:00', NULL, 0);

INSERT INTO administrator (user_id, job_title, member_introduction) VALUES
(31, 'Product Designer', 'Pet lover, creative problem solver, dream big, think systematic, dancer, experience design, create impact, ENTJ'),
(32, 'Founder/Developer', 'Travel aficionado with a keen interest in technology, a passion for programming, a deep love for dogs, and an enthusiasm for sports.'),
(33, 'Full-stack Developer', 'A cryptocurrency enthusiast with full-stack programming and community managing skills'),
(34, 'Job title', 'Member Introduction');

#Role & Grant
INSERT INTO userRole (user_id, user_role) VALUES
(1, 'BUYER'), (2, 'BUYER'), (3, 'BUYER'), (4, 'BUYER'), (5, 'BUYER'),(6, 'BUYER'), (7, 'BUYER'), (8, 'BUYER'), (9, 'BUYER'), (10, 'BUYER'),
(11, 'AGENT'), (12, 'AGENT'), (13, 'AGENT'), (14, 'AGENT'), (15, 'AGENT'),(16, 'AGENT'), (17, 'AGENT'), (18, 'AGENT'), (19, 'AGENT'), (20, 'AGENT'),
(21, 'SALESMAN'), (22, 'SALESMAN'), (23, 'SALESMAN'), (24, 'SALESMAN'), (25, 'SALESMAN'),(26, 'SALESMAN'), (27, 'SALESMAN'), (28, 'SALESMAN'), (29, 'SALESMAN'), (30, 'SALESMAN'),
(31, 'ADMIN'), (32, 'ADMIN'), (33, 'ADMIN'), (34, 'ADMIN'), 
(35, 'USER'),(36, 'USER'), (37, 'USER'), (38, 'USER'), (39, 'USER'), (40, 'USER');

INSERT INTO grantRoleFeatures (user_role, features, features_value) VALUES 
('ADMIN', 'MyDashboard', 'TBD'),('ADMIN', 'MyProfile', 'TBD'),('ADMIN', 'EditProfile', 'TBD'),
('ADMIN', 'MyFavorite', 'TBD'),('ADMIN', 'AddFavorite', 'TBD'),('ADMIN', 'DeleteFavorite', 'TBD'),
('ADMIN', 'MyPost', 'TBD'),('ADMIN', 'CreatePost', 'TBD'),('ADMIN', 'EditPost', 'TBD'),('ADMIN', 'DeletePost', 'TBD'),
('ADMIN', 'MyTransaction', 'TBD'),('ADMIN', 'AddTransaction', 'TBD'),('ADMIN', 'EditTransaction', 'TBD'),('ADMIN', 'DeleteTransaction', 'TBD'),
('ADMIN', 'MyReview', 'TBD'),('ADMIN', 'AddReview', 'TBD'),('ADMIN', 'EditReview', 'TBD'),('ADMIN', 'DeleteReview', 'TBD'),
('BUYER', 'MyDashboard', 'TBD'),('BUYER', 'MyProfile', 'TBD'),('BUYER', 'EditProfile', 'TBD'),
('BUYER', 'MyFavorite', 'TBD'),('BUYER', 'AddFavorite', 'TBD'),('BUYER', 'DeleteFavorite', 'TBD'),('BUYER', 'MyTransaction', 'TBD'),
('BUYER', 'MyReview', 'TBD'),('BUYER', 'AddReview', 'TBD'),('BUYER', 'EditReview', 'TBD'),('BUYER', 'DeleteReview', 'TBD'),
('SALESMAN', 'MyDashboard', 'TBD'),('SALESMAN', 'MyProfile', 'TBD'),('SALESMAN', 'EditProfile', 'TBD'),
('SALESMAN', 'MyPost', 'TBD'),('SALESMAN', 'CreatePost', 'TBD'),('ADMIN', 'EditPost', 'TBD'),('ADMIN', 'DeletePost', 'TBD'),
('SALESMAN', 'MyTransaction', 'TBD'),('SALESMAN', 'AddTransaction', 'TBD'),('SALESMAN', 'EditTransaction', 'TBD'),('SALESMAN', 'DeleteTransaction', 'TBD'),
('AGENT', 'MyDashboard', 'TBD'),('AGENT', 'MyProfile', 'TBD'),('AGENT', 'EditProfile', 'TBD'),
('AGENT', 'MySalesman', 'TBD'),('AGENT', 'MyStore', 'TBD');

#Property
INSERT INTO propertyAddress (address1, address2, city, state, zipcode) VALUES
('4101 Bigelow Blvd.', 'Apt 133', 'Pittsburgh', 'PA', 15213),
('123 Main St', 'Suite 567', 'Anytown', 'CA', 90210),
('789 Oak Lane', NULL, 'Smallville', 'NY', 56789),
('456 Elm Street', 'Unit 101', 'Metro City', 'IL', 67890),
('999 Pine Avenue', NULL, 'Greenfield', 'TX', 34567),
('321 Maple Drive', 'Apt 45', 'Riverside', 'FL', 45678),
('555 Cedar Street', NULL, 'Meadowville', 'OH', 23456),
('777 Birch Road', 'Apt 22', 'Mountain View', 'CA', 87654),
('222 Spruce Lane', NULL, 'Hometown', 'WA', 54321),
('888 Walnut Circle', 'Unit 77', 'Harbor City', 'OR', 76543),
('111 Oak Street', 'Suite 22', 'Downtown', 'TX', 11111),
('222 Maple Avenue', 'Apt 33', 'Uptown', 'CA', 22222),
('333 Cedar Lane', NULL, 'Midtown', 'NY', 33333),
('444 Pine Road', 'Unit 44', 'Suburbia', 'FL', 44444),
('555 Elm Boulevard', 'Apt 55', 'Cityville', 'OH', 55555);

INSERT INTO property (property_name, property_type, zipcode, city, state) VALUES
('Schenley Apartment', 'Apartment', 15213, 'Pittsburgh', 'PA'),
('Downtown Condo', 'Condo', 11111, 'Downtown', 'TX'),
('Uptown House', 'House', 22222, 'Uptown', 'CA'),
('Midtown Single-family', 'Single-family', 33333, 'Midtown', 'NY'),
('Suburbia Townhouse', 'Townhouse', 44444, 'Suburbia', 'FL'),
('Cityville Apartment', 'Apartment', 55555, 'Cityville', 'OH'),
('Meadowville House', 'House', 23456, 'Meadowville', 'OH'),
('Mountain View Condo', 'Condo', 87654, 'Mountain View', 'CA'),
('Hometown Single-family', 'Single-family', 54321, 'Hometown', 'WA'),
('Harbor City Townhouse', 'Townhouse', 76543, 'Harbor City', 'OR'),
('Newtown Apartment', 'Apartment', 98765, 'Newtown', 'TX'),
('Oceanview Condo', 'Condo', 12345, 'Oceanview', 'CA'),
('Riverfront House', 'House', 87612, 'Riverfront', 'NY'),
('Lakeview Single-family', 'Single-family', 56789, 'Lakeview', 'FL'),
('Hillside Townhouse', 'Townhouse', 34567, 'Hillside', 'OH');

INSERT INTO propertyItem (property_id, address_id, item_type, capacity, item_bedroom, item_bathroom, salesman_id) VALUES
(1, 1, '2B2B', 2000, 2, 2, 70001),(2, 2, '1B1.5B', 1500, 1, 1.5, 70002),
(3, 3, 'STUDIO', 1000, 1, 1,70003),(4, 4, '2B2B', 1800, 2, 2, 70002),
(5, 5, '1B1.5B', 1600, 1, 1.5, 70005),(6, 6, 'STUDIO', 1200, 1, 1, 70006),
(7, 7, '2B2B', 2200, 2, 2, 70007),(8, 8, '1B1.5B', 1700, 1, 1.5, 70008),
(9, 9, 'STUDIO', 900, 1, 1, 70009),(10, 10, '2B2B', 2400, 2, 2, 70010),
(11, 11, '1B1.5B', 1300, 1, 1.5, 70001),(12, 12, 'STUDIO', 1100, 1, 1, 70002),
(13, 13, '2B2B', 2000, 2, 2, 70003),(14, 14, '1B1.5B', 1500, 1, 1.5, 70004),(15, 15, 'STUDIO', 1000, 1, 1, 70005);

INSERT INTO propertyItemImages (item_id, image_id, image) VALUES
(1, 1, 'css/item1_image.jpg'),(2, 2, 'css/item2_image.jpg'),
(3, 3, 'css/item3_image.jpg'),(4, 4, 'css/item4_image.jpg'),
(5, 5, 'css/item5_image.jpg'),(6, 6, 'css/item6_image.jpg'),
(7, 7, 'css/item7_image.jpg'),(8, 8, 'css/item8_image.jpg'),
(9, 9, 'css/item9_image.jpg'),(10, 10, 'css/item10_image.jpg'),
(11, 11, 'css/item11_image.jpg'),(12, 12, 'css/item12_image.jpg'),
(13, 13, 'css/item13_image.jpg'),(14, 14, 'css/item14_image.jpg'),(15, 15, 'css/item15_image.jpg');

INSERT INTO propertyItemPayment (item_id, payment_id, payment_name, payment_amount) VALUES
(1, 1, 'Price', 2000.00),(1, 2, 'Homeowners Insurance', 100.00),(1, 3, 'HOA', 50.00),(1, 4, 'Property taxes', 150.00),
(2, 1, 'Price', 1800.00),(2, 2, 'Homeowners Insurance', 90.00),(2, 3, 'HOA', 45.00),(2, 4, 'Property taxes', 135.00),
(3, 1, 'Price', 1000.00),(3, 2, 'Homeowners Insurance', 50.00),(3, 3, 'HOA', 25.00),(3, 4, 'Property taxes', 75.00),
(4, 1, 'Price', 2200.00),(4, 2, 'Homeowners Insurance', 110.00),(4, 3, 'HOA', 55.00),(4, 4, 'Property taxes', 165.00),
(5, 1, 'Price', 1900.00),(5, 2, 'Homeowners Insurance', 95.00),(5, 3, 'HOA', 47.50),(5, 4, 'Property taxes', 142.50),
(6, 1, 'Price', 1100.00),(6, 2, 'Homeowners Insurance', 55.00),(6, 3, 'HOA', 27.50),(6, 4, 'Property taxes', 82.50),
(7, 1, 'Price', 2100.00),(7, 2, 'Homeowners Insurance', 105.00),(7, 3, 'HOA', 52.50),(7, 4, 'Property taxes', 157.50),
(8, 1, 'Price', 2000.00),(8, 2, 'Homeowners Insurance', 100.00),(8, 3, 'HOA', 50.00),(8, 4, 'Property taxes', 150.00),
(9, 1, 'Price', 1200.00),(9, 2, 'Homeowners Insurance', 60.00),(9, 3, 'HOA', 30.00),(9, 4, 'Property taxes', 90.00),
(10, 1, 'Price', 2300.00),(10, 2, 'Homeowners Insurance', 115.00),(10, 3, 'HOA', 57.50),(10, 4, 'Property taxes', 172.50),
(11, 1, 'Price', 2100.00),(11, 2, 'Homeowners Insurance', 105.00),(11, 3, 'HOA', 52.50),(11, 4, 'Property taxes', 157.50),
(12, 1, 'Price', 1300.00),(12, 2, 'Homeowners Insurance', 65.00),(12, 3, 'HOA', 32.50),(12, 4, 'Property taxes', 97.50),
(13, 1, 'Price', 2400.00),(13, 2, 'Homeowners Insurance', 120.00),(13, 3, 'HOA', 60.00),(13, 4, 'Property taxes', 180.00),
(14, 1, 'Price', 2200.00),(14, 2, 'Homeowners Insurance', 110.00),(14, 3, 'HOA', 55.00),(14, 4, 'Property taxes', 165.00),
(15, 1, 'Price', 1400.00),(15, 2, 'Homeowners Insurance', 70.00),(15, 3, 'HOA', 35.00),(15, 4, 'Property taxes', 105.00);

INSERT INTO propertyItemFeatures (feature_id, item_id, featutre_type, feature_name, feature_value) VALUES
(1, 1, 'Parking', 'On Street Parking', 'Y'),(2, 1, 'Facilities', 'Swimming Pool', 'Y'),
(3, 1, 'Equipments', 'Dishwasher', 'Y'),(4, 2, 'Parking', 'Attached Garage', 'Y'),
(5, 2, 'Facilities', 'Gym', 'Y'),(6, 2, 'Equipments', 'Refrigerator', 'Y'),
(7, 3, 'Parking', 'None', 'N'),(8, 3, 'Facilities', 'Fitness Center', 'Y'),(9, 3, 'Equipments', 'Dishwasher', 'N'),
(10, 4, 'Parking', 'Garage', 'Y'),(11, 4, 'Facilities', 'Swimming Pool', 'Y'),(12, 4, 'Equipments', 'Microwave', 'Y'),
(13, 5, 'Parking', 'On Street Parking', 'Y'),(14, 5, 'Facilities', 'Fitness Center', 'Y'),(15, 5, 'Equipments', 'Dishwasher', 'N');

INSERT INTO label (label_id, label, label_description) VALUES
(1, 'OPEN HOUSE', 'Property is open for viewing'),(2, 'New', 'Newly constructed or renovated property'),
(3, 'Convenience', 'Convenient location'),(4, 'School Districts', 'Close to educational institutions'), 
(5, 'Pet-Friendly', 'Allows pets on the premises');

INSERT INTO propertyItemLabel (item_id, label_id) VALUES
(1, 1),(1, 2),(1, 3),(2, 2),(2, 4),(3, 1),(3, 3),(4, 1),(4, 2),(4, 3),
(5, 2),(5, 4),(6, 1),(7, 2),(8, 4),(9, 3),(10, 2),(11, 1),(12, 3),(13, 2),(14, 4),(15, 5);


INSERT INTO transactions (transaction_id, buyer_id, salesman_id, propertyItem_id, transaction_datetime, delete_datetime, is_delete) VALUES
(1, 80001, 70001, 1, '2023-01-01 10:00:00', NULL, 0),(2, 80002, 70001, 2, '2023-02-15 13:00:00', NULL, 0),
(3, 80003, 70001, 3, '2023-03-20 18:30:00', NULL, 0),(4, 80004, 70002, 4, '2023-04-05 15:45:00', NULL, 0),
(5, 80005, 70001, 5, '2023-05-10 14:45:00', NULL, 0),(6, 80006, 70003, 6, '2023-06-25 12:45:00', NULL, 0),
(7, 80007, 70002, 7, '2023-05-10 18:45:00', NULL, 0),(8, 80008, 70004, 8, '2023-09-25 12:40:00', NULL, 0),
(9, 80009, 70002, 9, '2023-03-10 18:45:00', NULL, 0),(10, 80010, 70010, 10, '2023-12-25 12:40:00', NULL, 0),
(11, 80001, 70003, 11, '2023-11-15 14:00:00', NULL, 0),(12, 80002, 70008, 12, '2023-12-20 20:45:00', NULL, 0),
(13, 80003, 70004, 13, '2024-01-05 18:00:00', NULL, 0),(14, 80004, 70010, 14, '2024-02-10 15:15:00', NULL, 0),
(15, 80005, 70008, 15, '2024-03-25 14:30:00', NULL, 0);

INSERT INTO transactionsReview (review_id, transaction_id, rating, review) VALUES
(1, 1, 4, 'Smooth transaction. Happy with the purchase.'),(2, 2, 5, 'Excellent service. Would recommend.'),
(3, 3, 3, 'Average experience. Could be better.'),(4, 4, 4, 'Satisfied with the product.'),
(5, 5, 5, 'Great communication. Quick delivery.'),(6, 6, 2, 'Disappointed with the quality.'),
(7, 7, 4, 'Good overall experience.'),(8, 8, 5, 'Very helpful salesman. Happy customer.'),
(9, 9, 3, 'Transaction took longer than expected.'),(10, 10, 4, 'Smooth process. No issues.'),
(11, 11, 5, 'Highly recommended. Professional service.'),(12, 12, 4, 'Pleased with the purchase.'),
(13, 13, 2, 'Not satisfied with the product.'),(14, 14, 4, 'Fair transaction. No complaints.'),
(15, 15, 5, 'Excellent service. Quick turnaround.');

#lookUpTable
INSERT INTO lookUpTable VALUES 
('Address','STATE','Alabama (AL)','AL',NULL,NULL,NULL,NULL),
('Address','STATE','Alaska (AK)','AK',NULL,NULL,NULL,NULL),
('Address','STATE','Arizona (AZ)','AZ',NULL,NULL,NULL,NULL),
('Address','STATE','Arkansas (AR)','AR',NULL,NULL,NULL,NULL),
('Address','STATE','California (CA)','CA',NULL,NULL,NULL,NULL),
('Address','STATE','Colorado (CO)','CO',NULL,NULL,NULL,NULL),
('Address','STATE','Connecticut (CT)','CT',NULL,NULL,NULL,NULL),
('Address','STATE','Delaware (DE)','DE',NULL,NULL,NULL,NULL),
('Address','STATE','Florida (FL)','FL',NULL,NULL,NULL,NULL),
('Address','STATE','Georgia (GA)','GA',NULL,NULL,NULL,NULL),
('Address','STATE','Hawaii (HI)','HI',NULL,NULL,NULL,NULL),
('Address','STATE','Idaho (ID)','ID',NULL,NULL,NULL,NULL),
('Address','STATE','Illinois (IL)','IL',NULL,NULL,NULL,NULL),
('Address','STATE','Indiana (IN)','IN',NULL,NULL,NULL,NULL),
('Address','STATE','Iowa (IA)','IA',NULL,NULL,NULL,NULL),
('Address','STATE','Kansas (KS)','KS',NULL,NULL,NULL,NULL),
('Address','STATE','Kentucky (KY)','KY',NULL,NULL,NULL,NULL),
('Address','STATE','Louisiana (LA)','LA',NULL,NULL,NULL,NULL),
('Address','STATE','Maine (ME)','ME',NULL,NULL,NULL,NULL),
('Address','STATE','Maryland (MD)','MD',NULL,NULL,NULL,NULL),
('Address','STATE','Massachusetts (MA)','MA',NULL,NULL,NULL,NULL),
('Address','STATE','Michigan (MI)','MI',NULL,NULL,NULL,NULL),
('Address','STATE','Minnesota (MN)','MN',NULL,NULL,NULL,NULL),
('Address','STATE','Mississippi (MS)','MS',NULL,NULL,NULL,NULL),
('Address','STATE','Missouri (MO)','MO',NULL,NULL,NULL,NULL),
('Address','STATE','Montana (MT)','MT',NULL,NULL,NULL,NULL),
('Address','STATE','Nebraska (NE)','NE',NULL,NULL,NULL,NULL),
('Address','STATE','Nevada (NV)','NV',NULL,NULL,NULL,NULL),
('Address','STATE','New Hampshire (NH)','NH',NULL,NULL,NULL,NULL),
('Address','STATE','New Jersey (NJ)','NJ',NULL,NULL,NULL,NULL),
('Address','STATE','New Mexico (NM)','NM',NULL,NULL,NULL,NULL),
('Address','STATE','New York (NY)','NY',NULL,NULL,NULL,NULL),
('Address','STATE','North Carolina (NC)','NC',NULL,NULL,NULL,NULL),
('Address','STATE','North Dakota (ND)','ND',NULL,NULL,NULL,NULL),
('Address','STATE','Ohio (OH)','OH',NULL,NULL,NULL,NULL),
('Address','STATE','Oklahoma (OK)','OK',NULL,NULL,NULL,NULL),
('Address','STATE','Oregon (OR)','OR',NULL,NULL,NULL,NULL),
('Address','STATE','Pennsylvania (PA)','PA',NULL,NULL,NULL,NULL),
('Address','STATE','Rhode Island (RI)','RI',NULL,NULL,NULL,NULL),
('Address','STATE','South Carolina (SC)','SC',NULL,NULL,NULL,NULL),
('Address','STATE','South Dakota (SD)','SD',NULL,NULL,NULL,NULL),
('Address','STATE','Tennessee (TN)','TN',NULL,NULL,NULL,NULL),
('Address','STATE','Texas (TX)','TX',NULL,NULL,NULL,NULL),
('Address','STATE','Utah (UT)','UT',NULL,NULL,NULL,NULL),
('Address','STATE','Vermont (VT)','VT',NULL,NULL,NULL,NULL),
('Address','STATE','Virginia (VA)','VA',NULL,NULL,NULL,NULL),
('Address','STATE','Washington (WA)','WA',NULL,NULL,NULL,NULL),
('Address','STATE','West Virginia (WV)','WV',NULL,NULL,NULL,NULL),
('Address','STATE','Wisconsin (WI)','WI',NULL,NULL,NULL,NULL),
('Address','STATE','Wyoming (WY)','WY',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Apartment','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Condo','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Single Family House','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Townhouse','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Coop','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Colonial','NULL',NULL,NULL,NULL,NULL),
('Property','PROPERTY TYPE','Multi Family House','NULL',NULL,NULL,NULL,NULL),
('Property','PAYMENT TYPE','Price','NULL',NULL,NULL,NULL,NULL),
('Property','PAYMENT TYPE','Homeowners Insurance/','NULL',NULL,NULL,NULL,NULL),
('Property','PAYMENT TYPE','HOA','NULL',NULL,NULL,NULL,NULL),
('Property','PAYMENT TYPE','Property taxes','NULL',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Parking','Garage',NULL,NULL,NULL),
('Property','FEATURES','Facilities','Parking','On Street Parking',NULL,NULL,NULL),
('Property','FEATURES','Facilities','Gym',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Swimming Pool',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Laundry Room',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Loung',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Fitness Center',NULL,NULL,NULL,NULL),
('Property','FEATURES','Facilities','Garbage Disposal',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Elevator',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Dishwasher',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Microwave',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Refrigerator',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Stove',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','In-unit Laundry',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Air Conditioning',NULL,NULL,NULL,NULL),
('Property','FEATURES','Equipments','Dryer',NULL,NULL,NULL,NULL),
('Property','FEATURES','Utilities','Heating Fuel','Natural Gas',NULL,NULL,NULL),
('Property','FEATURES','Utilities','Heating Fuel','Oil',NULL,NULL,NULL),
('Property','FEATURES','Utilities','Cooling Type','Central A/C',NULL,NULL,NULL),
('Property','FEATURES','Utilities','Sewer','Public Sewer',NULL,NULL,NULL),
('Property','FEATURES','Utilities','Water Source','Public',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Sign Up','SignUp','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Sign In','SignIn','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Dashboard','MyDashboard','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Profile','MyProfile','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Edit Profile','EditProfile','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Favorite','MyFavorite','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Add Favorite','AddFavorite','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Delete Favorite','DeleteFavorite','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Property Post','MyPost','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Add Property Post','AddPost','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Edit Property Post','EditPost','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Delete Property Post','DeletePost','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Transaction','MyTransaction','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Edit Transaction','EditTransaction','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Delete Transaction','DeleteTransaction','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','My Review ','MyReview ','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Add Review','AddReview','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Edit Review','EditReview','NULL',NULL,NULL,NULL),
('Permission','GRANT FEATURES','Delete Review','DeleteReview','NULL',NULL,NULL,NULL);

/*--------- Aggregation Query-------*/
# Salesman ranking by rating
select salesman_id, avg(rating) as rating from transactions t inner join transactionsReview tr 
where t.transaction_id = tr.transaction_id group by salesman_id order by rating desc;

# Popular property type
select property_type, count(property_type) as amount from property group by property_type order by property_type desc;


/*--------- Other Query-------*/
select * from users u inner join administrator a on u.user_id=a.user_id 
left join userPhoto up on u.user_id=up.user_id where u.user_role='ADMIN';

select lookUp_value2 from lookUpTable where lookUp_category='Address' and lookUp_name='STATE';
select * from lookUpTable where lookUp_category='Property' and lookUp_name='FEATURES' and lookUp_value1='Facilities';
select * from lookUpTable where lookUp_category='Permission' and lookUp_name='GRANT FEATURES';

select * from transactions t inner join transactionsReview tr where t.transaction_id=tr.transaction_id;

