use housebook;

/*------------------------------ Create Table ------------------------------*/
#User/Buyer/Agent/Salesman
CREATE TABLE userAddress(
	address_id int,
	address1 varchar(50), #4101 Bigelow Blvd.
	address2 varchar(50), #Apt 133
	city varchar(30),     #Pittsburgh
	state varchar(10),    #PA
	zipcode int,      #15213
    PRIMARY KEY(address_id)
);
CREATE TABLE users(
	user_id int not null,
	first_name varchar(50),
	middle_name varchar(50), 
	last_name varchar(50), 
	organization_name varchar(150),
	user_gender varchar(10), #F/M
	user_address int,
	user_phone varchar(50),
	user_email varchar(100), 
	user_account varchar(50),  
	passward varchar(50),
	create_datetime datetime,  	#create user date and time
	delete_datetime datetime,  	#delete user date and time
	is_delete int,  			# 0:active / 1:deleted
    PRIMARY KEY(user_id),
    FOREIGN KEY(user_address) REFERENCES userAddress(address_id),
    CONSTRAINT check_user_type CHECK(
    (first_name IS NOT NULL AND last_name IS NOT NULL) OR organization_name IS NOT NULL)
);
#alter table users modify user_phone varchar(50);
CREATE TABLE buyer(
	buyer_id int, #80001
	user_id int,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int,  #0/1
    PRIMARY KEY(buyer_id,user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE agent(
	agent_id int, #10001
    user_id int,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int, #0/1
	PRIMARY KEY(agent_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE store(
	store_id int,
	store_name varchar(30),
	store_region varchar(30),
    agent_id int,
	PRIMARY KEY(store_id),
    FOREIGN KEY(agent_id) REFERENCES agent(agent_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE salesman(
	salesman_id int, #70001
	user_id int,
	agent_id int,
	store_id int,
	create_datetime datetime,
	delete_datetime datetime,
	is_delete int, #0/1
    PRIMARY KEY(salesman_id,user_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(agent_id) REFERENCES agent(agent_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(store_id) REFERENCES store(store_id) ON DELETE CASCADE ON UPDATE CASCADE
);

#Property
CREATE TABLE propertyAddress(
	address_id int,
	address1 varchar(50), #4101 Bigelow Blvd.
	address2 varchar(50), #Apt 133
	city varchar(30),     #Pittsburgh
	state varchar(10),    #PA
	zipcode int,      #15213
    PRIMARY KEY(address_id)
);
CREATE TABLE property(
	property_id int,
    property_name varchar(30),	#Schenley Apartment
    property_type varchar(30),	#Apartment/Condo/House/Single-family/Townhouse
    zipcode int,				#15213
    city varchar(30),			#Pittsburgh
    state varchar(10),			#PA
    PRIMARY KEY(property_id)
);
CREATE TABLE propertyItem(
	item_id int not null,
	property_id int not null,
    address_id int not null,
	item_type varchar(50), #2B2B/1B1.5B/STUDIO/?
    capacity int, #2000 sqft
	item_bedroom float, #2/1
	item_bathroom float, #2/1.5
	PRIMARY KEY(item_id),
    FOREIGN KEY(property_id) REFERENCES property(property_id),
    FOREIGN KEY(address_id) REFERENCES propertyAddress(address_id)
);
CREATE TABLE propertyItemImages(
	item_id int,
    image_id int,
	image text,   #image path
	PRIMARY KEY(image_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) 
);
CREATE TABLE propertyItemPayment(
	item_id int not null, 
    payment_id int not null,
    payment_name varchar(50) not null, #Price/Homeowners Insurance/HOA/Property taxes
    payment_amount decimal(10, 2) not null,
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
CREATE TABLE propertyItemFeatures2(
	feature_id int,				#1/2/3/4/5/...
	item_id int,				#100
    featutre_type varchar(50),	#Parking;Facilities;Equipments
    feature_name varchar(50),	#Parking/Garage; swimming pools/gyms; Cooktop/Dishwasher/Disposal/Microwave/Refrigerator/Stove
    feature_value varchar(50),	#寫內容：On Street Parking/Attached Garage; 或只寫有無：Y/Y; Y/Y/N/Y/Y/Y
	PRIMARY KEY(feature_id, item_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) 
);
CREATE TABLE Label(
	label_id int,		#1/2/3/4/...
    label varchar(50),	#OPEN HOUSE/New/Convenience/Near School/...?
    label_description varchar(50),	#description for this label
	PRIMARY KEY(label_id)
);
CREATE TABLE propertyItemLabel(
    item_id int,	#100
    label_id int,	#4
	PRIMARY KEY(label_id, item_id),
    FOREIGN KEY(item_id) REFERENCES propertyItem(item_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(label_id) REFERENCES Label(label_id)
);

#Transcation
CREATE TABLE transactions(
	transaction_id int not null, 
	buyer_id int not null,
	salesman_id  int not null,
	propertyItem_id  int not null,
	transaction_datetime datetime,
    delete_datetime datetime, 
    is_delete int,
	PRIMARY KEY(transaction_id),
    FOREIGN KEY(buyer_id) REFERENCES buyer(buyer_id),
	FOREIGN KEY(salesman_id) REFERENCES salesman(salesman_id),
    FOREIGN KEY(propertyItem_id) REFERENCES propertyItem(item_id),
    FOREIGN KEY(propertyItem_id) REFERENCES propertyItem(item_id)
);
CREATE TABLE transactionsReview(
	review_id int not null, 
    transaction_id int not null,
    rating int not null, 
    review text,
    PRIMARY KEY(review_id),
    FOREIGN KEY(transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE ON UPDATE CASCADE
);

/*------------------------------ Select Table ------------------------------*/
select * from users;
select * from userAddress;
select * from buyer;
select * from agent;
select * from store;
select * from salesman;

select * from propertyAddress;
select * from property;
select * from propertyItem;
select * from propertyItemImages;
select * from propertyItemPayment;
#select * from propertyItemFeatures1;
select * from propertyItemFeatures2;
select * from Label;
select * from propertyItemLabel;

select * from transactions;
select * from transactionsReview;

#delete from userAddress where address_id=3;
#update userAddress set address2='Suite 566' where address_id=2;

/*------------------------------ DROP TABLE ------------------------------*/
-- #User/Buyer/Agent/Salesman
-- ALTER TABLE users DROP FOREIGN KEY users_ibfk_1; 
-- ALTER TABLE buyer DROP FOREIGN KEY buyer_ibfk_1;
-- ALTER TABLE agent DROP FOREIGN KEY agent_ibfk_1;
-- ALTER TABLE store DROP FOREIGN KEY store_ibfk_1;
-- ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_1;
-- ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_2;
-- ALTER TABLE salesman DROP FOREIGN KEY salesman_ibfk_3;

-- #Property
-- ALTER TABLE propertyItem DROP FOREIGN KEY propertyItem_ibfk_1;
-- ALTER TABLE propertyItem DROP FOREIGN KEY propertyItem_ibfk_2;
-- ALTER TABLE propertyItemImages DROP FOREIGN KEY propertyItemImages_ibfk_1;
-- ALTER TABLE propertyItemPayment DROP FOREIGN KEY propertyItemPayment_ibfk_1;
-- #ALTER TABLE propertyItemFeatures1 DROP FOREIGN KEY propertyItemFeatures1_ibfk_1;
-- ALTER TABLE propertyItemFeatures2 DROP FOREIGN KEY propertyItemFeatures2_ibfk_1;
-- ALTER TABLE propertyItemLabel DROP FOREIGN KEY propertyItemLabel_ibfk_1;
-- ALTER TABLE propertyItemLabel DROP FOREIGN KEY propertyItemLabel_ibfk_2;
-- #Transcations
-- ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_1;
-- ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_2;
-- ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_3;
-- ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_4;
-- ALTER TABLE transactionsReview DROP FOREIGN KEY transactionsReview_ibfk_1;

-- #User/Buyer/Agent/Salesman
-- DROP TABLE users;
-- DROP TABLE userAddress;
-- DROP TABLE buyer;
-- DROP TABLE agent;
-- DROP TABLE store;
-- DROP TABLE salesman;
-- #Property
-- DROP TABLE propertyAddress;
-- DROP TABLE property;
-- DROP TABLE propertyItem;
-- DROP TABLE propertyItemImages;
-- DROP TABLE propertyItemPayment;
-- #DROP TABLE propertyItemFeatures1;
-- DROP TABLE propertyItemFeatures2;
-- DROP TABLE Label;
-- DROP TABLE propertyItemLabel;
-- #Transaction & Review
-- DROP TABLE transactions;
-- DROP TABLE transactionsReview;


/*------------------------------ Insert Data ------------------------------*/

INSERT INTO userAddress (address_id, address1, address2, city, state, zipcode) VALUES
(1, '4101 Bigelow Blvd.', 'Apt 133', 'Pittsburgh', 'PA', 15213),(2, '123 Main St', 'Suite 567', 'Anytown', 'CA', 90210),(3, '789 Oak Lane', NULL, 'Smallville', 'NY', 56789),(4, '456 Elm Street', 'Unit 101', 'Metro City', 'IL', 67890),(5, '999 Pine Avenue', NULL, 'Greenfield', 'TX', 34567),
(6, '321 Maple Drive', 'Apt 45', 'Riverside', 'FL', 45678),(7, '555 Cedar Street', NULL, 'Meadowville', 'OH', 23456),(8, '777 Birch Road', 'Apt 22', 'Mountain View', 'CA', 87654),(9, '222 Spruce Lane', NULL, 'Hometown', 'WA', 54321),(10, '888 Walnut Circle', 'Unit 77', 'Harbor City', 'OR', 76543);

INSERT INTO users (user_id, first_name, middle_name, last_name, organization_name, user_gender, user_address, user_phone, user_email, user_account, passward, create_datetime, delete_datetime, is_delete) VALUES
(1, 'John', 'A.', 'Doe', NULL, 'M', 1, 1234567890, 'john.doe@example.com', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
(2, 'Jane', 'B.', 'Smith', NULL, 'F', 2, 9876543210, 'jane.smith@example.com', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
(3, 'Bob', 'C.', 'Johnson', NULL, 'M', 3, 5555555555, 'bob.johnson@example.com', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
(4, 'Emily', NULL, 'Williams', NULL, 'F', 4, 1111111111, 'emily.williams@example.com', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
(5, 'Mike', 'D.', 'Miller', NULL, 'M', 5, 9999999999, 'mike.miller@example.com', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
(6, 'Sarah', 'E.', 'Davis', NULL, 'F', 6, 3333333333, 'sarah.davis@example.com', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
(7, 'Tom', 'F.', 'Brown', NULL, 'M', 7, 7777777777, 'tom.brown@example.com', 'tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
(8, 'Anna', 'G.', 'Lee', NULL, 'F', 8, 8888888888, 'anna.lee@example.com', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
(9, 'Chris', NULL, 'Clark', NULL, 'M', 9, 2222222222, 'chris.clark@example.com', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
(10, 'Emma', 'H.', 'White', NULL, 'F', 10, 4444444444, 'emma.white@example.com', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0),

(11, NULL, NULL, NULL, 'X Corp', NULL, 1, 1234567890, 'john.doe@example.com', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
(12, NULL, NULL, NULL, 'Y Corp', NULL, 2, 9876543210, 'jane.smith@example.com', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
(13, NULL, NULL, NULL, 'ABC Corp', NULL, 3, 5555555555, 'bob.johnson@example.com', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
(14, NULL, NULL, NULL, 'XYZ Corp', NULL, 4, 1111111111, 'emily.williams@example.com', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
(15, NULL, NULL, NULL, 'CC Corp', NULL, 5, 9999999999, 'mike.miller@example.com', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
(16, NULL, NULL, NULL, 'LMN Ltd', NULL, 6, 3333333333, 'sarah.davis@example.com', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
(17, NULL, NULL, NULL, 'Z Corp', NULL, 7, 7777777777, 'tom.brown@example.com', 'tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
(18, NULL, NULL, NULL, 'A Corp', NULL, 8, 8888888888, 'anna.lee@example.com', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
(19, NULL, NULL, NULL, 'PQR Ltd', NULL, 9, 2222222222, 'chris.clark@example.com', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
(20, NULL, NULL, NULL, 'BB Corp', NULL, 10, 4444444444, 'emma.white@example.com', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0),

(21, 'John', 'A.', 'Doe', NULL, 'M', 1, 1234567890, 'john.doe@example.com', 'john_doe_01', 'password123', '2023-01-01 08:00:00', NULL, 0),
(22, 'Jane', 'J.', 'Smith', NULL, 'F', 2, 9876543210, 'jane.smith@example.com', 'jane_smith_02', 'pass456word', '2023-02-15 10:30:00', NULL, 0),
(23, 'Bob', 'D.', 'Johnson', NULL, 'M', 3, 5555555555, 'bob.johnson@example.com', 'bob_123', 'secure789', '2023-03-20 15:45:00', NULL, 0),
(24, 'Emily', NULL, 'Williams', NULL, 'F', 4, 1111111111, 'emily.williams@example.com', 'emily_567', 'safePass', '2023-04-05 12:15:00', NULL, 0),
(25, 'Mike', 'E.', 'Miller', NULL, 'M', 5, 9999999999, 'mike.miller@example.com', 'mike_abc', 'passwordXYZ', '2023-05-10 11:00:00', NULL, 0),
(26, 'Sarah', 'E.', 'Davis', NULL, 'F', 6, 3333333333, 'sarah.davis@example.com', 'sarah_789', '123Secure', '2023-06-25 09:30:00', NULL, 0),
(27, 'Tom', 'C.', 'Brown', NULL, 'M', 7, 7777777777, 'tom.brown@example.com', 'tom_321', 'brownPass', '2023-07-30 14:00:00', NULL, 0),
(28, 'Anna', 'G.', 'Lee', NULL, 'F', 8, 8888888888, 'anna.lee@example.com', 'anna_654', 'leePassword', '2023-08-12 17:45:00', NULL, 0),
(29, 'Chris', NULL, 'Clark', NULL, 'M', 9, 2222222222, 'chris.clark@example.com', 'chris_876', 'clarkSafe', '2023-09-18 13:20:00', NULL, 0),
(30, 'Emma', 'A.', 'White', NULL, 'F', 10, 4444444444, 'emma.white@example.com', 'emma_543', 'whitePass', '2023-10-05 16:10:00', NULL, 0);



INSERT INTO buyer (buyer_id, user_id, create_datetime, delete_datetime, is_delete) VALUES
(80001, 1, '2023-01-01 08:30:00', NULL, 0),(80002, 2, '2023-02-15 11:00:00', NULL, 0),(80003, 3, '2023-03-20 16:00:00', NULL, 0),(80004, 4, '2023-04-05 13:00:00', NULL, 0),
(80005, 5, '2023-05-10 12:00:00', NULL, 0),(80006, 6, '2023-06-25 10:00:00', NULL, 0),(80007, 7, '2023-07-30 15:30:00', NULL, 0),(80008, 8, '2023-08-12 18:30:00', NULL, 0),
(80009, 9, '2023-09-18 14:00:00', NULL, 0),(80010, 10, '2023-10-05 17:00:00', NULL, 0);

INSERT INTO agent (agent_id, user_id, create_datetime, delete_datetime, is_delete) VALUES
(10001, 11, '2023-01-01 09:00:00', NULL, 0),(10002, 12, '2023-02-15 12:30:00', NULL, 0),(10003, 13, '2023-03-20 17:45:00', NULL, 0),(10004, 14, '2023-04-05 14:30:00', NULL, 0),(10005, 15, '2023-05-10 13:30:00', NULL, 0),
(10006, 16, '2023-06-25 11:30:00', NULL, 0),(10007, 17, '2023-07-30 16:15:00', NULL, 0),(10008, 18, '2023-08-12 19:00:00', NULL, 0),(10009, 19, '2023-09-18 15:15:00', NULL, 0),(10010, 20, '2023-10-05 18:00:00', NULL, 0);

INSERT INTO store (store_id, store_name, store_region, agent_id) VALUES
(1, 'SuperMart', 'North', 10001),(2, 'MegaStore', 'East', 10002),(3, 'CityGrocery', 'West', 10003),(4, 'NeighborhoodMart', 'South', 10004),(5, 'QuickShop', 'Central', 10005),
(6, 'CornerStore', 'North', 10006),(7, 'TownMarket', 'East', 10007),(8, 'LocalMart', 'West', 10008),(9, 'VillageGrocery', 'South', 10009),(10, 'ExpressMart', 'Central', 10010);

-- Inserting data into salesman table
INSERT INTO salesman (salesman_id, store_id, user_id, agent_id, create_datetime, delete_datetime, is_delete) VALUES
(70001, 1, 21, 10001, '2023-01-01 10:30:00', NULL, 0),
(70002, 2, 22, 10002, '2023-02-15 13:30:00', NULL, 0),
(70003, 3, 23, 10003, '2023-03-20 19:00:00', NULL, 0),
(70004, 4, 24, 10004, '2023-04-05 16:15:00', NULL, 0),
(70005, 5, 25, 10005, '2023-05-10 15:15:00', NULL, 0),
(70006, 6, 26, 10006, '2023-06-25 13:15:00', NULL, 0),
(70007, 7, 27, 10007, '2023-07-30 18:30:00', NULL, 0),
(70008, 8, 28, 10008, '2023-08-12 21:15:00', NULL, 0),
(70009, 9, 29, 10009, '2023-09-18 17:30:00', NULL, 0),
(70010, 10, 30, 10010, '2023-10-05 20:15:00', NULL, 0);

#Property
INSERT INTO propertyAddress (address_id, address1, address2, city, state, zipcode) VALUES
(1, '4101 Bigelow Blvd.', 'Apt 133', 'Pittsburgh', 'PA', 15213),
(2, '123 Main St', 'Suite 567', 'Anytown', 'CA', 90210),
(3, '789 Oak Lane', NULL, 'Smallville', 'NY', 56789),
(4, '456 Elm Street', 'Unit 101', 'Metro City', 'IL', 67890),
(5, '999 Pine Avenue', NULL, 'Greenfield', 'TX', 34567),
(6, '321 Maple Drive', 'Apt 45', 'Riverside', 'FL', 45678),
(7, '555 Cedar Street', NULL, 'Meadowville', 'OH', 23456),
(8, '777 Birch Road', 'Apt 22', 'Mountain View', 'CA', 87654),
(9, '222 Spruce Lane', NULL, 'Hometown', 'WA', 54321),
(10, '888 Walnut Circle', 'Unit 77', 'Harbor City', 'OR', 76543),
(11, '111 Oak Street', 'Suite 22', 'Downtown', 'TX', 11111),
(12, '222 Maple Avenue', 'Apt 33', 'Uptown', 'CA', 22222),
(13, '333 Cedar Lane', NULL, 'Midtown', 'NY', 33333),
(14, '444 Pine Road', 'Unit 44', 'Suburbia', 'FL', 44444),
(15, '555 Elm Boulevard', 'Apt 55', 'Cityville', 'OH', 55555);

INSERT INTO property (property_id, property_name, property_type, zipcode, city, state) VALUES
(1, 'Schenley Apartment', 'Apartment', 15213, 'Pittsburgh', 'PA'),
(2, 'Downtown Condo', 'Condo', 11111, 'Downtown', 'TX'),
(3, 'Uptown House', 'House', 22222, 'Uptown', 'CA'),
(4, 'Midtown Single-family', 'Single-family', 33333, 'Midtown', 'NY'),
(5, 'Suburbia Townhouse', 'Townhouse', 44444, 'Suburbia', 'FL'),
(6, 'Cityville Apartment', 'Apartment', 55555, 'Cityville', 'OH'),
(7, 'Meadowville House', 'House', 23456, 'Meadowville', 'OH'),
(8, 'Mountain View Condo', 'Condo', 87654, 'Mountain View', 'CA'),
(9, 'Hometown Single-family', 'Single-family', 54321, 'Hometown', 'WA'),
(10, 'Harbor City Townhouse', 'Townhouse', 76543, 'Harbor City', 'OR'),
(11, 'Newtown Apartment', 'Apartment', 98765, 'Newtown', 'TX'),
(12, 'Oceanview Condo', 'Condo', 12345, 'Oceanview', 'CA'),
(13, 'Riverfront House', 'House', 87612, 'Riverfront', 'NY'),
(14, 'Lakeview Single-family', 'Single-family', 56789, 'Lakeview', 'FL'),
(15, 'Hillside Townhouse', 'Townhouse', 34567, 'Hillside', 'OH');

INSERT INTO propertyItem (item_id, property_id, address_id, item_type, capacity, item_bedroom, item_bathroom) VALUES
(1, 1, 1, '2B2B', 2000, 2, 2),(2, 2, 2, '1B1.5B', 1500, 1, 1.5),
(3, 3, 3, 'STUDIO', 1000, 1, 1),(4, 4, 4, '2B2B', 1800, 2, 2),
(5, 5, 5, '1B1.5B', 1600, 1, 1.5),(6, 6, 6, 'STUDIO', 1200, 1, 1),
(7, 7, 7, '2B2B', 2200, 2, 2),(8, 8, 8, '1B1.5B', 1700, 1, 1.5),
(9, 9, 9, 'STUDIO', 900, 1, 1),(10, 10, 10, '2B2B', 2400, 2, 2),
(11, 11, 11, '1B1.5B', 1300, 1, 1.5),(12, 12, 12, 'STUDIO', 1100, 1, 1),
(13, 13, 13, '2B2B', 2000, 2, 2),(14, 14, 14, '1B1.5B', 1500, 1, 1.5),(15, 15, 15, 'STUDIO', 1000, 1, 1);

INSERT INTO propertyItemImages (item_id, image_id, image) VALUES
(1, 1, '/images/item1_image1.jpg'),(2, 2, '/images/item2_image1.jpg'),
(3, 3, '/images/item3_image1.jpg'),(4, 4, '/images/item4_image1.jpg'),
(5, 5, '/images/item5_image1.jpg'),(6, 6, '/images/item6_image1.jpg'),
(7, 7, '/images/item7_image1.jpg'),(8, 8, '/images/item8_image1.jpg'),
(9, 9, '/images/item9_image1.jpg'),(10, 10, '/images/item10_image1.jpg'),
(11, 11, '/images/item11_image1.jpg'),(12, 12, '/images/item12_image1.jpg'),
(13, 13, '/images/item13_image1.jpg'),(14, 14, '/images/item14_image1.jpg'),(15, 15, '/images/item15_image1.jpg');


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

INSERT INTO propertyItemFeatures2 (feature_id, item_id, featutre_type, feature_name, feature_value) VALUES
(1, 1, 'Parking', 'On Street Parking', 'Y'),(2, 1, 'Facilities', 'Swimming Pool', 'Y'),
(3, 1, 'Equipments', 'Dishwasher', 'Y'),(4, 2, 'Parking', 'Attached Garage', 'Y'),
(5, 2, 'Facilities', 'Gym', 'Y'),(6, 2, 'Equipments', 'Refrigerator', 'Y'),
(7, 3, 'Parking', 'None', 'N'),(8, 3, 'Facilities', 'None', 'N'),(9, 3, 'Equipments', 'None', 'N'),(10, 4, 'Parking', 'Garage', 'Y'),
(11, 4, 'Facilities', 'Swimming Pool', 'Y'),(12, 4, 'Equipments', 'Microwave', 'Y'),
(13, 5, 'Parking', 'None', 'N'),(14, 5, 'Facilities', 'None', 'N'),(15, 5, 'Equipments', 'None', 'N');

INSERT INTO Label (label_id, label, label_description) VALUES
(1, 'OPEN HOUSE', 'Property is open for viewing'),(2, 'New', 'Newly constructed or renovated property'),
(3, 'Convenience', 'Convenient location'),(4, 'Near School', 'Close to educational institutions'), (5, 'Pet-Friendly', 'Allows pets on the premises');

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

