CREATE DATABASE library;

USE library;

CREATE TABLE readers (
	reader_id VARCHAR(5),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    dob DATE,
    ph_no VARCHAR(10),
    CONSTRAINT PRIMARY KEY(reader_id) 
);

DROP TABLE readers;

INSERT INTO readers VALUES('R0001', 'Ram', 'Raj', '2006-11-08', '9273543214');
INSERT INTO readers VALUES('R0011', 'Vishnu', 'Madhav', '2002-01-18', '9876543210');
INSERT INTO readers VALUES('R0002', 'Sai', 'Bhargav', '2003-12-13', '9866543216');
INSERT INTO readers VALUES('R0009', 'Joseph', 'Rose', '1997-11-28', '9676543719');
INSERT INTO readers VALUES('R0006', 'Lauren', 'Lawrence', '1986-04-23', '9816543218');
INSERT INTO readers VALUES('R0003', 'Jiwanjot', 'Singh', '1992-10-11', '8876543214');
INSERT INTO readers VALUES('R0008', 'Abrar', 'Ahmed', '2006-01-31', '9976543219');
INSERT INTO readers VALUES('R0005', 'Lokesh', 'Sai', '2001-12-25', '9386543217');
INSERT INTO readers VALUES('R0004', 'Ravi', 'Kishan', '2005-02-21', '7876544211');
INSERT INTO readers VALUES('R0007', 'Selvan', 'Kumar', '2006-03-28', '9236543218');
INSERT INTO readers VALUES('R0010', 'Paul', 'Dawson', '1976-11-14', '8676543212');

SELECT * FROM readers;

CREATE TABLE authors (
	author_id VARCHAR(5),
    author_first_name VARCHAR(20),
    author_second_name VARCHAR(20),
    CONSTRAINT PRIMARY KEY(author_id)
);

INSERT INTO authors VALUES('AT001', 'John', 'Benny');
INSERT INTO authors VALUES('AT002', 'JK', 'Rowling');
INSERT INTO authors VALUES('AT003', 'Ramkrishna', 'Agarwal');
INSERT INTO authors VALUES('AT004', 'William', 'Porterfield');
INSERT INTO authors VALUES('AT005', 'Author', 'Doyle');
INSERT INTO authors VALUES('AT006', 'VK', 'Mehta');
INSERT INTO authors VALUES('AT007', 'John', 'Larkin');
SELECT * FROM authors;

CREATE TABLE books (
	book_id VARCHAR(5),
    book_name VARCHAR(50),
    author_id VARCHAR(5),
    book_genre VARCHAR(20),
    CONSTRAINT PRIMARY KEY(book_id),
    CONSTRAINT FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

DROP TABLE books;

INSERT INTO books VALUES('B0001', 'Introduction to Programming', 'AT001', 'Science');
INSERT INTO books VALUES('B0002', 'Harry Potter- I', 'AT002', 'Fiction');
INSERT INTO books VALUES('B0003', 'Harry Potter- II', 'AT002', 'Fiction');
INSERT INTO books VALUES('B0004', 'Harry Potter- III', 'AT002', 'Fiction');
INSERT INTO books VALUES('B0005', 'Human Evolution', 'AT003', 'Science');
INSERT INTO books VALUES('B0006', 'Attitude is Everything', 'AT004', 'Self Help');
INSERT INTO books VALUES('B0007', 'Sherlock Holmes', 'AT005', 'Fiction');
INSERT INTO books VALUES('B0008', 'Elements of Electrical Engineering', 'AT006', 'Science');
INSERT INTO books VALUES('B0009', 'Database Management Systems', 'AT007', 'Science');
INSERT INTO books VALUES('B0010', 'Python Programming', 'AT001', 'Science');

SELECT * FROM books;

CREATE TABLE active_readers (
	account_id VARCHAR(5),
    reader_id VARCHAR(5),
    membership VARCHAR(10),
    CONSTRAINT PRIMARY KEY(account_id),
    CONSTRAINT FOREIGN KEY (reader_id) REFERENCES readers(reader_id)
);

INSERT INTO active_readers VALUES('AC001', 'R0003', 'GOLD');
INSERT INTO active_readers VALUES('AC002', 'R0011', 'STANDARD');
INSERT INTO active_readers VALUES('AC003', 'R0008', 'PREMIUM');
INSERT INTO active_readers VALUES('AC004', 'R0005', 'PREMIUM');
INSERT INTO active_readers VALUES('AC005', 'R0001', 'STANDARD');
INSERT INTO active_readers VALUES('AC006', 'R0007', 'STANDARD');
INSERT INTO active_readers VALUES('AC007', 'R0010', 'GOLD');

SELECT * FROM active_readers;

CREATE TABLE transactions (
	transaction_id VARCHAR(5),
    account_id VARCHAR(5),
    book_id VARCHAR(5),
    transaction_date DATE,
    return_date DATE,
    CONSTRAINT PRIMARY KEY(transaction_id),
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT FOREIGN KEY (account_id) REFERENCES active_readers(account_id)
);

DROP TABLE transactions;

INSERT INTO transactions VALUES('TR001', 'AC003', 'B0004', '2023-07-13', DATE_ADD('2023-07-13', INTERVAL 15 DAY));
INSERT INTO transactions VALUES('TR002', 'AC003', 'B0001', '2023-07-15', DATE_ADD('2023-07-15', INTERVAL 15 DAY));
INSERT INTO transactions VALUES('TR003', 'AC002', 'B0003', '2023-07-05', DATE_ADD('2023-07-05', INTERVAL 15 DAY));
INSERT INTO transactions VALUES('TR004', 'AC003', 'B0003', '2023-07-17', DATE_ADD('2023-07-17', INTERVAL 15 DAY));
INSERT INTO transactions VALUES('TR005', 'AC001', 'B0002', '2023-07-19', DATE_ADD('2023-07-19', INTERVAL 15 DAY));

SELECT * FROM transactions;


-- QUERIES

-- QUERY TO SHOW THE YOUNG READERS
SELECT reader_id,
	   first_name,
       last_name,
       dob
FROM readers
WHERE TIMESTAMPDIFF(YEAR, dob, CURDATE()) < 18;


-- QUERY TO SHOW THE READERS WITH ACTIVE SUBSCRIPTIONS
SELECT readers.reader_id,
	   first_name,
       last_name,
       membership
FROM readers
LEFT JOIN active_readers
	ON readers.reader_id = active_readers.reader_id;
 
 
-- QUERY TO SHOW ALL THE BOOKS AND AUTHORS NAMES WITH A SPECIFIC GENRE
SELECT book_id, book_name, author_first_name, author_second_name
FROM books
JOIN authors
	ON books.author_id = authors.author_id
WHERE book_genre = 'Science';


-- QUERY TO FIND OUT AND FINE THE READERS FOR NOT RETURNING ON TIME
SELECT readers.reader_id, 
		active_readers.account_id, 
        first_name, 
        last_name, 
        ph_no, 
        book_id,
        transaction_date, 
        return_date,
        if(CURDATE() > return_date, DATEDIFF(DATE(CURRENT_TIMESTAMP), return_date)*5, null) AS fine
FROM active_readers
JOIN transactions
		ON transactions.account_id = active_readers.account_id
JOIN readers
		ON readers.reader_id = active_readers.reader_id;
	
        


    
