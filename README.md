# RateMyRent
## Files : 
[Meeting Document](https://docs.google.com/document/d/1vlk1mottYMlSErFy5jw6XkFr3GL9b7EKUiC7yKRR5HQ/edit?usp=sharing)

[Trello Link](https://docs.google.com/document/d/1vlk1mottYMlSErFy5jw6XkFr3GL9b7EKUiC7yKRR5HQ/edit?usp=sharing)

[Data Schema from Jessie](https://app.quickdatabasediagrams.com/?fbclid=IwAR3h-MZcOOE7eySR4rwgCFqz489UXjXK6ZimXibK9-zY1nsWq84atpzjcqk#/d/zp2E7C)

[Data Schema from Angelo](https://docs.google.com/document/d/12DPXRQn29HHXUZN69DYoJISuBVaJ5VF-D_EGP8muBOA/edit?usp=sharing)

## Database Build-up
1. 打开 MySQL Workbench。
2. 连接到你的 MySQL 实例。
3. 在 Navigator 面板中，点击 "Schemas" 标签以查看数据库列表。
4. 右键点击 "Schemas"，选择 "Create Schema..."，为你的数据库输入一个名字，比如 myDatabase，然后点击 "Apply"。
6. 在出现的脚本预览窗口中点击 "Apply"，然后点击 "Finish"。
```sql
USE myDatabase;

-- Address Table
CREATE TABLE IF NOT EXISTS `Address` (
    `address_id` INT NOT NULL AUTO_INCREMENT,
    `address1` VARCHAR(50),
    `address2` VARCHAR(50),
    `city` VARCHAR(30),
    `state` VARCHAR(10),
    `zipcode` INT,
    PRIMARY KEY (`address_id`)
);

-- User Table
CREATE TABLE IF NOT EXISTS `User` (
    `user_id` INT NOT NULL AUTO_INCREMENT,
    `user_first_name` VARCHAR(255),
    `user_middle_name` VARCHAR(255),
    `user_last_name` VARCHAR(255),
    `user_gender` VARCHAR(10),
    `current_address` INT,
    `user_phone` VARCHAR(20),
    `user_email` VARCHAR(255),
    `account_id` INT,
    `create_date` DATETIME,
    `delete_date` DATETIME,
    `is_delete` INT,
    PRIMARY KEY (`user_id`),
    INDEX (`user_first_name`(100)),
    INDEX (`user_middle_name`(100)),
    INDEX (`user_last_name`(100)),
    FOREIGN KEY (`current_address`) REFERENCES `Address`(`address_id`)
);

-- Account Table
CREATE TABLE IF NOT EXISTS `Account` (
    `account_id` INT NOT NULL AUTO_INCREMENT,
    `account_username` VARCHAR(30),
    `account_password` VARCHAR(30),
    `signup_email` VARCHAR(75),
    `user_id` INT,
    PRIMARY KEY (`account_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`)
);

-- Item Table
CREATE TABLE IF NOT EXISTS `Item` (
    `item_id` INT NOT NULL AUTO_INCREMENT,
    `building` INT,
    `item_type` VARCHAR(50),
    `capacity` INT,
    `item_bedroom` VARCHAR(20),
    `item_bathroom` VARCHAR(20),
    `monthly_rent` DECIMAL(10,2),
    PRIMARY KEY (`item_id`),
    FOREIGN KEY (`building`) REFERENCES `Building`(`building_id`)
);

-- Building Table
CREATE TABLE IF NOT EXISTS `Building` (
    `building_id` INT NOT NULL AUTO_INCREMENT,
    `building_type` VARCHAR(10),
    `building_name` VARCHAR(45),
    `building_region` VARCHAR(45),
    `building_location` VARCHAR(45),
    `building_zipcode` INT,
    `landload_type` VARCHAR(30),
    `landload` VARCHAR(30),
    PRIMARY KEY (`building_id`)
);

-- StoreImages Table
CREATE TABLE IF NOT EXISTS `StoreImages` (
    `image_id` INT NOT NULL AUTO_INCREMENT,
    `item_id` INT,
    `image` TEXT,
    PRIMARY KEY (`image_id`),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Feature Table
CREATE TABLE IF NOT EXISTS `Feature` (
    `feature_type` VARCHAR(30),
    `item_id` INT,
    `feature_name` VARCHAR(50),
    `feature_content` VARCHAR(200),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Rent Table
CREATE TABLE IF NOT EXISTS `Rent` (
    `rent_id` INT NOT NULL AUTO_INCREMENT,
    `tenant_id` INT,
    `item` INT,
    `rating` INT,
    `rent_start_date` DATE,
    `rent_end_date` DATE,
    `is_delete` INT,
    PRIMARY KEY (`rent_id`),
    FOREIGN KEY (`tenant_id`) REFERENCES `User`(`user_id`),
    FOREIGN KEY (`item`) REFERENCES `Item`(`item_id`)
);

-- Favorite Table
CREATE TABLE IF NOT EXISTS `Favorite` (
    `favorite_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT,
    `item_id` INT,
    PRIMARY KEY (`favorite_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Comments Table
CREATE TABLE IF NOT EXISTS `Comments` (
    `comment_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT,
    `item_id` INT,
    `comment` TEXT,
    `create_date` DATETIME,
    `delete_date` DATETIME,
    `is_delete` INT,
    PRIMARY KEY (`comment_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Like Table
CREATE TABLE IF NOT EXISTS `Like` (
    `like_id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT,
    `item_id` INT,
    PRIMARY KEY (`like_id`),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Grant Table
CREATE TABLE IF NOT EXISTS `Grant` (
    `user_id` INT,
    `role` VARCHAR(10),
    FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`)
);

-- ItemLabel Table
CREATE TABLE IF NOT EXISTS `ItemLabel` (
    `label_id` INT NOT NULL AUTO_INCREMENT,
    `item_id` INT,
    `label` VARCHAR(255),
    PRIMARY KEY (`label_id`),
    FOREIGN KEY (`item_id`) REFERENCES `Item`(`item_id`)
);

-- Lookup Table
CREATE TABLE IF NOT EXISTS `Lookup` (
    `category` VARCHAR(255),
    `type` VARCHAR(50),
    `content1` INT,
    `content2` VARCHAR(100),
    `content3` TEXT,
    `description` VARCHAR(200)
);
```

