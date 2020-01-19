CREATE SCHEMA GALLERY_DB;
USE GALLERY_DB;

CREATE TABLE ARTIST_ID_CODE_TABLE(
  Artist_Id INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(20) NOT NULL DEFAULT 'Not Set',
  FName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  MName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  LName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  DOB DATE NOT NULL DEFAULT '1900-01-01',
  St_Apt_Num VARCHAR(20) NOT NULL DEFAULT 'Not Set',
  Street VARCHAR(50) NOT NULL DEFAULT 'Not Set',
  City VARCHAR(50) NOT NULL DEFAULT 'Not Set',
  State VARCHAR(2) NOT NULL DEFAULT 'NS',
  Zip VARCHAR(10) NOT NULL DEFAULT '00000',
  Country VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  Intl_Code INT NOT NULL DEFAULT 0,
  Area_Code INT NOT NULL DEFAULT 0,
  P_Number INT NOT NULL DEFAULT 0,
  PRIMARY KEY (Artist_Id),
  UNIQUE KEY (Title, FName, MName, LName));

CREATE TABLE LOCATION_ID_CODE_TABLE(
  Location_Id INT NOT NULL AUTO_INCREMENT,
  St_Apt_Num VARCHAR(20) NOT NULL DEFAULT 'Not Set',
  Street VARCHAR(50) NOT NULL DEFAULT 'Not Set',
  City VARCHAR(50) NOT NULL DEFAULT 'Not Set',
  State VARCHAR(2) NOT NULL DEFAULT 'NS',
  Zip VARCHAR(10) NOT NULL DEFAULT '00000',
  Country VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  Room VARCHAR(40) DEFAULT 'Not Set',
  PRIMARY KEY (Location_Id));

CREATE TABLE CUSTOMER_ID_CODE_TABLE(
  Customer_Id INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(20) NOT NULL DEFAULT 'Not Set',
  FName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  MName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  LName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  Intl_Code INT NOT NULL DEFAULT 0,
  Area_Code INT NOT NULL DEFAULT 0,
  P_Number INT NOT NULL DEFAULT 0,
  Artist_Id_FK INT NOT NULL,
  PRIMARY KEY (Customer_Id),
  FOREIGN KEY (Artist_Id_FK) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ART_SHOWS_CONTACT_ID_CODE_TABLE(
  Contact_Id INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(20) NOT NULL DEFAULT 'Not Set',
  FName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  MName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  LName VARCHAR(40) NOT NULL DEFAULT 'Not Set',
  Intl_Code INT NOT NULL DEFAULT 0,
  Area_Code INT NOT NULL DEFAULT 0,
  P_Number INT NOT NULL DEFAULT 0,
  PRIMARY KEY (Contact_Id));

CREATE TABLE TYPE_ART_ID_CODE_TABLE(
  Type_Id INT NOT NULL AUTO_INCREMENT,
  Type_Name VARCHAR(30) NOT NULL DEFAULT 'Not Set',
  PRIMARY KEY (Type_Id));

CREATE TABLE STYLE_ART_ID_CODE_TABLE(
  Style_Id INT NOT NULL AUTO_INCREMENT,
  Style_Name VARCHAR(30) NOT NULL DEFAULT 'Not Set',
  PRIMARY KEY (Style_Id));


CREATE TABLE ARTIST_TABLE(
  Artist_Id INT NOT NULL AUTO_INCREMENT,
  Birthplace_Id INT NOT NULL,
  PRIMARY KEY (Artist_Id),
  FOREIGN KEY (Birthplace_Id) REFERENCES LOCATION_ID_CODE_TABLE(Location_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ART_WORK_TABLE(
  Artist_Id INT NOT NULL,
  Artwork_Title VARCHAR(50) NOT NULL,
  Location_Id INT NOT NULL,
  Price FLOAT NOT NULL DEFAULT 0.00,
  AW_DOC DATE DEFAULT '1900-01-01',
  AW_DAG DATE NOT NULL DEFAULT '1900-01-01',
  PRIMARY KEY (Artist_Id, Artwork_Title),
  UNIQUE KEY (Artwork_Title),
  FOREIGN KEY (Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Location_Id) REFERENCES LOCATION_ID_CODE_TABLE(Location_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE CUSTOMER_TABLE(
  Customer_Number INT NOT NULL AUTO_INCREMENT,
  Customer_Id INT NOT NULL,
  Artist_Id INT NOT NULL,
  PRIMARY KEY (Customer_Number),
  FOREIGN KEY (Customer_Id) REFERENCES CUSTOMER_ID_CODE_TABLE(Customer_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ART_SHOWS_TABLE(
  Art_Show_Title VARCHAR(50) NOT NULL,
  Artist_Id INT NOT NULL,
  Contact_Id INT NOT NULL,
  Location_Id INT NOT NULL,
  AS_Date_Time DATETIME NOT NULL,
  PRIMARY KEY (Art_Show_Title),
  FOREIGN KEY (Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Contact_Id) REFERENCES ART_SHOWS_CONTACT_ID_CODE_TABLE(Contact_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Location_Id) REFERENCES LOCATION_ID_CODE_TABLE(Location_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE SHOWCASE_IN_TABLE(
  Artist_Id INT NOT NULL,
  Artwork_Title VARCHAR(50) NOT NULL,
  Art_Show_Title VARCHAR(50) NOT NULL,
  PRIMARY KEY (Artist_Id, Artwork_Title, Art_Show_Title),
  FOREIGN KEY (Artist_Id, Artwork_Title) REFERENCES ART_WORK_TABLE(Artist_Id, Artwork_Title) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Art_Show_Title) REFERENCES ART_SHOWS_TABLE(Art_Show_Title) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ARTIST_STYLE_ART_TABLE(
  Style_Id INT NOT NULL,
  Artist_Id INT NOT NULL,
  PRIMARY KEY (Style_Id, Artist_Id),
  FOREIGN KEY (Style_Id) REFERENCES STYLE_ART_ID_CODE_TABLE(Style_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ARTWORK_TYPE_OF_ART_TABLE(
  Type_Id INT NOT NULL,
  Artist_Id INT NOT NULL,
  Artwork_Title VARCHAR(50) NOT NULL,
  PRIMARY KEY (Type_Id, Artist_Id, Artwork_Title),
  FOREIGN KEY (Type_Id) REFERENCES TYPE_ART_ID_CODE_TABLE(Type_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Artist_Id, Artwork_Title) REFERENCES ART_WORK_TABLE(Artist_Id, Artwork_Title) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE ARTSHOW_ARTIST_TABLE(
  Art_Show_Artist_Id INT NOT NULL,
  Art_Show_Title VARCHAR(50) NOT NULL,
  PRIMARY KEY (Art_Show_Artist_Id, Art_Show_Title),
  FOREIGN KEY (Art_Show_Artist_Id) REFERENCES ARTIST_ID_CODE_TABLE(Artist_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Art_Show_Title) REFERENCES ART_SHOWS_TABLE(Art_Show_Title) ON DELETE CASCADE ON UPDATE CASCADE);


CREATE TABLE CUSTOMER_PREFERS_STYLE_OF_ART_TABLE(
  Style_Id INT NOT NULL,
  Customer_Number INT NOT NULL,
  PRIMARY KEY (Style_Id, Customer_Number),
  FOREIGN KEY (Style_Id) REFERENCES STYLE_ART_ID_CODE_TABLE(Style_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Customer_Number) REFERENCES CUSTOMER_TABLE(Customer_Number) ON DELETE CASCADE ON UPDATE CASCADE);


CREATE TABLE CUSTOMER_PREFERS_TYPE_OF_ART_TABLE(
  Type_Id INT NOT NULL,
  Customer_Number INT NOT NULL,
  PRIMARY KEY (Type_Id, Customer_Number),
  FOREIGN KEY (Type_Id) REFERENCES TYPE_ART_ID_CODE_TABLE(Type_Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Customer_Number) REFERENCES CUSTOMER_TABLE(Customer_Number) ON DELETE CASCADE ON UPDATE CASCADE);




INSERT INTO ARTIST_ID_CODE_TABLE(Title, FName, MName, LName, DOB, St_Apt_Num, Street, City, State, Zip, Country, Intl_Code, Area_Code, P_Number)
VALUES ('Mr.', 'Erik', 'Sanderson', 'Smith', '1955-10-09', 'Apt#77', 'Manser Way', 'Irvine', 'CA', '92011', 'United States', 011, 714, 9293891),
('Mrs.', 'Kerry', 'Sun', 'Pham', '1955-03-20', 'Apt#33', 'Jamboree Ave.', 'San Diego', 'CA', '92034', 'United States', 011, 858, 5997993),
('Mr.', 'Wilbur', 'Manesse', 'Smith', '1951-04-10', 'Apt#446', 'Ironway St.', 'Anaheim', 'CA', '92056', 'United States', 011, 923, 4499349),
('Ms.', 'Sarah', 'Gasler', 'Melarky', '1962-04-24', 'Apt#234', 'Jester St.', 'Anaheim', 'CA', '92479', 'United States', 011, 512, 4962358),
('Ms.', 'Vicky', 'Debbie', 'Scottsdale', '1978-03-24', 'Apt#3', 'Williamson St.', 'Anaheim', 'CA', '92004', 'United States', 411, 914, 5969451),
('Mr.', 'Aaron', 'Greg', 'Peterson', '1989-02-24', 'Apt#34', 'Sonoma St.', 'San Diego', 'CA', '92111', 'United States', 011, 524, 8969352),
('Mr.', 'Enrique', 'Andrew', 'Bentley', '1989-08-24', 'Apt#2', 'Abercombas St.', 'Irvine', 'CA', '92412', 'United States', 011, 824, 2009450);


INSERT INTO LOCATION_ID_CODE_TABLE(St_Apt_Num, Street, City, State, Zip, Country, Room)
VALUES ('House #12', 'Joslin Way', 'Irvine', 'CA', '92654', 'United States', 'Blue Room'),
('House #90', 'Arrow Ave.', 'Los Angeles', 'CA', '96023', 'United States', NULL),
('Apt#500', 'Yellow St.', 'New Port Beach', 'CA', '92106', 'United States', 'Front Room'),
('House #703', 'Plastic Ave.', 'Los Angeles', 'CA', '91022', 'United States', NULL),
('Apt#26', 'Belle St.', 'Irvine', 'CA', '92708', 'United States', 'Front Room'),
('House #100', 'Table Ave.', 'San Diego', 'CA', '36043', 'United States', NULL),
('Apt#3000', 'Glass St.', 'Los Angeles', 'CA', '52106', 'United States', 'Blue Room'),
('House #50', 'Lincoln Ave.', 'Torrance', 'CA', '86023', 'United States', NULL),
('Apt#1', 'McArthur Blvd.', 'Venice', 'CA', '12106', 'United States', 'Basement Room'),
('House #70', 'Pellican Way.', 'Manhattan Beach', 'CA', '58010', 'United States', NULL),
('Apt#5', 'Garden St.', 'Redondo Beach', 'CA', '90100', 'United States', 'Front Room'),
('Apt#30', 'Flower Ave.', 'Los Angeles', 'CA', '90545', 'United States', NULL),
('Apt#55', 'Wilbury St.', 'Redondo Beach', 'CA', '70130', 'United States', 'Basement Room'),
('House #7120', 'Jasperina.', 'Manhattan Beach', 'CA', '22010', 'United States', NULL),
('Apt#330', 'Tarence Ave.', 'Los Angeles', 'CA', '40544', 'United States', NULL);


INSERT INTO CUSTOMER_ID_CODE_TABLE(Title, FName, MName, LName, Intl_Code, Area_Code, P_Number, Artist_Id_FK)
VALUES ('Mr.', 'Jacomb', 'Withers', 'Telsher', 121, 444, 6458741, 1),
('Mrs.', 'Dakota', 'Alda', 'Renning', 456, 678, 6785674, 2),
('Ms.', 'Barney', 'Tuley', 'Stone', 234, 345, 3454564, 3),
('Mr.', 'Steven', 'Iverson', 'Carney', 011, 125, 8905674, 4),
('Mrs.', 'Kirstie', 'Grasman', 'Sheriner', 071, 123, 8205670, 2),
('Mr.', 'Tom', 'Tablan', 'Jackson', 011, 223, 8905304, 3),
('Mr.', 'Berners', 'Lee', 'Thompson', 011, 122, 8305624, 4);

INSERT INTO ART_SHOWS_CONTACT_ID_CODE_TABLE(Title, FName, MName, LName, Intl_Code, Area_Code, P_Number)
VALUES ('Mrs.', 'Crystal', 'Blue', 'Aura', 200, 533, 6458741),
('Ms.', 'Kirstie', 'Bell', 'Silver', 735, 336, 6785674),
('Mr.', 'Richard', 'Burnsey', 'Venser', 222, 726, 3454564),
('Mr.', 'Tan', 'Pho', 'Phan', 088, 112, 8905674);

INSERT INTO TYPE_ART_ID_CODE_TABLE(Type_Name)
VALUES ('Drawing - Chalk'),
('Drawing - Charcoal'),
('Drawing - Conte Crayon'),
('Drawing - Pastel'),
('Painting - Acrylics'),
('Painting - Ink and Wash'),
('Painting - Oils'),
('Animation Art'),
('Ceramics'),
('Collage'),
('Conceptual Art'),
('Graphic Art'),
('Illustration'),
('Metalwork Art');

INSERT INTO STYLE_ART_ID_CODE_TABLE(Style_Name)
VALUES ('Photorealism'),
('Abstract'),
('Whimsical'),
('Composite'),
('Modern Art'),
('Pop Art'),
('Cubism'),
('Renaissance Art'),
('Art Deco'),
('Surrealism'),
('Art Nouveau'),
('19th Century Art'),
('Realism'),
('Impressionism');

INSERT INTO ARTIST_TABLE(Birthplace_Id)
VALUES (2),
(4),
(6),
(8),
(10),
(12),
(14);

INSERT INTO ART_WORK_TABLE(Artist_Id, Artwork_Title, Location_Id, Price, AW_DOC, AW_DAG)
VALUES (1, 'Mona Lisa', 1, 5000000.00, '1670-02-14', '1980-06-20'),
(2, 'The Red Bridge', 3, 45000.00, '1910-05-01', '2000-04-02'),
(3, 'Into the Blue', 5, 200000.00, '1840-03-27', '1992-03-12'),
(4, 'Windy Day', 7, 150000.00, '1720-09-05', '1989-06-16'),
(5, 'Jelly Fish', 9, 85000.00, '1900-02-08', '2001-03-04'),
(6, 'Ocean Breeze', 11, 300000.00, '1854-04-07', '1993-06-10'),
(7, 'Wild Days', 13, 160000.00, '1934-04-03', '1990-08-18');


INSERT INTO CUSTOMER_TABLE(Customer_Id, Artist_Id)
VALUES (1, 4),
(2, 1),
(3, 2),
(4, 3),
(5, 2),
(6, 5),
(7, 4);

INSERT INTO ART_SHOWS_TABLE(Art_Show_Title, Artist_Id, Contact_Id, Location_Id, AS_Date_Time)
VALUES ('LA Art Show', 1, 2, 9, '2019-11-15 21:00:00'),
('The Grand Show', 2, 4, 11, '2019-11-18 19:00:00'),
('End of Year Art Gallery', 3, 1, 13, '2019-11-22 18:00:00'),
('San Diego Art Show', 4, 3, 11, '2019-12-29 17:00:00'),
('Grasser Art Show', 5, 1, 9, '2019-12-29 17:00:00');

INSERT INTO SHOWCASE_IN_TABLE(Artist_Id, Artwork_Title, Art_Show_Title)
VALUES (1, 'Mona Lisa', 'LA Art Show'),
(2, 'The Red Bridge', 'End of Year Art Gallery'),
(3, 'Into the Blue', 'San Diego Art Show'),
(4, 'Windy Day', 'San Diego Art Show'),
(5, 'Jelly Fish', 'End of Year Art Gallery'),
(6, 'Ocean Breeze', 'End of Year Art Gallery'),
(7, 'Wild Days', 'LA Art Show');

INSERT INTO ARTIST_STYLE_ART_TABLE(Style_Id, Artist_Id)
VALUES (8, 1),
(9, 2),
(10, 3),
(11, 4),
(12, 5),
(14, 6),
(2, 7);

INSERT INTO ARTWORK_TYPE_OF_ART_TABLE(Type_Id, Artist_Id, Artwork_Title)
VALUES (8, 1, 'Mona Lisa'),
(9, 2, 'The Red Bridge'),
(10, 3, 'Into the Blue'),
(11, 4, 'Windy Day'),
(2, 5, 'Jelly Fish'),
(3, 6, 'Ocean Breeze'),
(4, 7, 'Wild Days');


INSERT INTO ARTSHOW_ARTIST_TABLE(Art_Show_Artist_Id, Art_Show_Title)
VALUES (1, 'LA Art Show'),
(2, 'LA Art Show'),
(2, 'The Grand Show'),
(1, 'The Grand Show'),
(4, 'The Grand Show'),
(3, 'End of Year Art Gallery'),
(4, 'San Diego Art Show'),
(6, 'Grasser Art Show'),
(5, 'San Diego Art Show'),
(5, 'Grasser Art Show');

INSERT INTO CUSTOMER_PREFERS_STYLE_OF_ART_TABLE(Style_Id, Customer_Number)
VALUES (8, 1),
(9, 2),
(10, 3),
(11, 4),
(12, 5),
(2, 6),
(2, 7);

INSERT INTO CUSTOMER_PREFERS_TYPE_OF_ART_TABLE(Type_Id, Customer_Number)
VALUES (8, 1),
(9, 2),
(10, 3),
(11, 4),
(2, 5),
(3, 6),
(4, 7);
