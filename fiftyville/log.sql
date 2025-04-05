-- Keep a log of any SQL queries you execute as you solve the mystery.

--find crime scene report
.schema crime_scene_reports
SELECT description FROM crime_scene_reports;
SELECT description FROM crime_scene_reports WHERE month = 7 AND day = 28 AND street = "Humphrey Street";
--Crime happened at the bakery at 10:15 AM.
--Interviews were conducted today (m7 d28) - 3 wittnessess. All mention bakery.

--we should check what people said in the interviews. We check for all interviews from month 7 day 28 that mention the bakery.
SELECT transcript FROM interviews WHERE month = 7 AND day = 28 AND transcript LIKE "%bakery%";
-- we discover that the thief fled into a car around 10:15 AM. We will check the cars that left at that hour and date time
-- before 10:15 AM the second witness saw someone he knew withdrawing money from the ATM on Legget Street. We will check ATM's
-- The thief is leaving town on the first flight of Month 7 day 29 out of fiftyville. The person on the other end bought the tickets.

--we first check what type of info is stored in the bakery logs to get a feel for what we're working with.
SELECT * FROM bakery_security_logs LIMIT 10;
--we narrow down to hour 10 and day 28
SELECT * FROM bakery_security_logs WHERE day = 28 AND hour = 10;
-- We discover someone exiting at 10:16 with the license plate number 5P2BI95. //LE: We will discover that this license plate does not join a flight. So we take the next one exiting at 10:18 : 94kL13X
-- Now we check the ATM. We discover alot of withdrawls. We should see if some transactions at the bakery match anything withdrawn. There is no record of that.
SELECT * FROM atm_transactions WHERE day = 28 AND atm_location = "Leggett Street";
-- We check each of the withdrawals against the bank's records to see who withdrew.
SELECT * FROM atm_transactions JOIN bank_accounts ON atm_tranactions.account_number = bank_accounts.account_number WHERE day = 28 AND atm_location = "Leggett Street";
-- We now have the person id's of people who withdrew that morning. we proceed to check their names.
-- We check for his name
SELECT * FROM atm_transactions JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON people.id = bank_accounts.person_id WHERE day = 28 AND atm_location = "Leggett Street";
-- We filter a bit by replacing * with what we are interested in. name, phone_number, passport_number, amount
-- Now that we have a list of suspects we check airport info
SELECT * FROM airports;
-- we discover the id of fiftyville airport which is 8. So let's query for leaving flights on the 29th and find the earlies one
SELECT * FROM flights WHERE origin_airport_id = 8 AND day = 29;
-- earliest one is at 8:20 leaving for new york, id 4
-- let's check which of our suspects leaves with that flight. Check passport numbers for all people on flight leaving at 8:20. Flight id is 36
SELECT * FROM passengers WHERE flight_id = 36
-- We now have all passengers passport numbers. Let's check if any of our suspects is there.
SELECT * FROM passengers WHERE flight_id = 36 AND passport_number IN (SELECT people.passport_number FROM atm_transactions JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON people.id = bank_accounts.person_id WHERE day = 28 AND atm_location = "Leggett Street");
-- We narrow down our list to 3 suspects. We need another lower denominator so let's crosscheck license plates of our suspects.
SELECT * FROM passengers WHERE flight_id = 36 AND passport_number IN (SELECT people.passport_number FROM atm_transactions JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON people.id = bank_accounts.person_id WHERE day = 28 AND atm_location = "Leggett Street" AND license_plate = "94KL13X");

SELECT * FROM passengers JOIN flights ON flights.id = passengers.flight_id WHERE flight_id = 36 AND passport_number IN (SELECT people.passport_number FROM atm_transactions JOIN bank_accounts ON atm_transactions.account_number = bank_accounts.account_number
JOIN people ON people.id = bank_accounts.person_id WHERE day = 28 AND atm_location = "Leggett Street" AND license_plate = "94KL13X");

--Bruce with passport number 5773159633 leaving for new york on seat 4a on the 29th at 8:20 STOLE THE DUCK. Let's check who helped him.
-- Query the phone records.
-- Check our guy's phone number: (367) 555-5533
SELECT * FROM phone_calls WHERE month = 7 AND day = 28 AND caller = "(367) 555-5533";
-- he did 3 phone calls that day
-- the only one that corresponds to the witness description (less than a minute) is to (375) 555-8161
-- Let's query the people for that person.
SELECT * FROM people WHERE phone_number = "(375) 555-8161";
-- Robin helped him. That bastard!

















