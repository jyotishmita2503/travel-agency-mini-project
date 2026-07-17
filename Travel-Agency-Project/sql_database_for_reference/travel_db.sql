-- 1. Create the database
CREATE DATABASE IF NOT EXISTS travel;
USE travel;

-- 2. Create the user_info table
-- This matches your Python INSERT statement: 
-- INSERT INTO user_info (user_info_name,user_name,user_password)[cite: 4, 5, 8]
CREATE TABLE IF NOT EXISTS user_info (
    user_name VARCHAR(50) PRIMARY KEY,        -- Making this the Primary Key prevents duplicate usernames
    user_info_name VARCHAR(100) NOT NULL,
    user_password VARCHAR(255) NOT NULL       -- Set to 255 to allow room if you add password hashing later
);

-- 3. Create the package_info table
-- Your code prints: "Package name \t Price \t Package Description"
-- And filters by budget: WHERE package_price < %s
CREATE TABLE IF NOT EXISTS package_info (
    package_id INT AUTO_INCREMENT PRIMARY KEY,
    package_name VARCHAR(100) NOT NULL,
    package_price INT NOT NULL,               -- Must be an integer so budget comparisons work
    package_description TEXT NOT NULL
);

-- 4. Create the package_choice table
-- Your code inserts the username and the selected package name:
-- INSERT INTO package_choice VALUES(%s,%s)[cite: 5]
CREATE TABLE IF NOT EXISTS package_choice (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    package_name VARCHAR(100) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_name) REFERENCES user_info(user_name) ON DELETE CASCADE
);

-- 5. Create the customer_info table (From your packagechoice.py file)
-- Your code inserts 4 values: username, package_id, no_of_people, price[cite: 6]
CREATE TABLE IF NOT EXISTS customer_info (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    package_id INT NOT NULL,
    no_of_people INT NOT NULL,
    total_price INT NOT NULL,
    FOREIGN KEY (user_name) REFERENCES user_info(user_name) ON DELETE CASCADE,
    FOREIGN KEY (package_id) REFERENCES package_info(package_id) ON DELETE CASCADE
);

-- ==========================================
-- SAMPLE DATA FOR TESTING
-- ==========================================

-- Insert sample packages so your app has something to show when querying:
-- SELECT * FROM package_info[cite: 3, 5, 7]
INSERT INTO package_info (package_name, package_price, package_description) VALUES
('Goa Getaway', 15000, '3 Nights / 4 Days stay at a beach resort with breakfast.'),
('Manali Adventure', 25000, '5 Nights / 6 Days including snow activities and hotel stay.'),
('Kerala Backwaters', 30000, '4 Nights / 5 Days house-boat stay with all meals included.'),
('Rajasthan Royalty', 45000, '6 Nights / 7 Days exploring palaces and forts with luxury stay.'),
('Budget Weekend', 5000, '1 Night / 2 Days quick getaway for budget travelers.');