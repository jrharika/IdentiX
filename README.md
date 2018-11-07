# BAB_IP_Homelessness
A blockchain solution for identity management for the homeless population in Berkeley.

## Project Description
Our project aims to use blockchain technology to create a digital identity and record management system for those experiencing homelessness, so that they are more likely to gain access to the shelter and full range of services that they need in order to create a path out of chronic homelessness. We have validated and refined this use case by conducting interviews with a range of organizations across Contra Costa, Alameda, and San Francisco counties (including private, county-funded, non-profit, walk-in, long-term, and youth focused facilities.) We are in the process of evaluating the feasibility of running a small scale pilot with two of these organizations. 

## Components

### Web Interface
Main:
Customer interaction with our application will be through a web interface. Initially, new customers on the application can access registration pages, for clients (homeless people looking to begin a digital identity) or institutions (looking to provide services to people with a digital identity). The web interface has access to user private keys so it can interact with the blockchain and decrypt information on their behalves.

Client Portal: 
Clients can view their record metadata on the website. They can also choose an individual record to view in its entirety. Clients can see a list of participating institutions on the website. If they see one  that they would like to request a service from, they can check in to that institution on the website. This grants access for an institution to view their records and add a new visit to their records.

Institution Portal:
Institutions can use the website to view the identity and records of clients that checked in with them. They can also add the client’s current visit to their record. If the institution has verification permission, they would be able to add identifying information and verify clients through the portal too.

### Smart Contract
Mapping that from public addresses to user structs will make it possible to access the data held in Institution and Client structs. This is where the records will be held and where permissions are managed with the check-in/check-out system. 

Client:
Certain pieces of data like date of birth, id type for verification, gender, and sex are  considering non-identifying data. These variables will be public, but will not be able to be traced to the client they pertain to. The client’s record metadata list will also be publically viewable. First name, last name, and government id numbers (like SSN) that are used for verification are considered identifying information and are encrypted. That information can only be decrypted using the client’s private key and the private key of the institution that the client is temporarily checked in at. 

Record Metadata:
The record on the blockchain will merely contain the public address of the involved institution (this can be used with the institution mapping to get information about the institution visited), the encrypted permission key for that visit, the time of the visit, and the IPFS address at which the encryption of the entire record is stored.

Institution:
The address, institution type, verification ability (whether or not they are allowed to verify clients), and a list of public addresses for checked-in clients will be publically viewable for each institution.

### Database:
Since the website handles a client’s blockchain interactions, their private key needs to be associated with their account. Their login information (username and hashed password) and private key will go in the database.

### InterPlanetary File System:
Encrypted records will be stored on the IPFS. Records will only be decryptable using the private key of the client or institutions at which the client is currently checked-in.

## Project Architecture
### Verified & Unverified Client actions
Accessing personal record metadata:
client requests their record on the web interface
web interface reads the record metadata list from the blockchain (without decrypting the permission key)
web interface displays each record separately

Accessing an individual record’s permission key:
while viewing all of their personal record metadata on the web interface, the client can select one record to retrieve the permission key for
the web interface decrypts the permission key and displays it

Accessing an entire record:
while viewing all of their personal record metadata on the web interface, the client can also select one record to view in its entirety
the web interface fetches the record from IPFS address in the metadata and decrypts it with the client’s private key 
displays the record on the website

Check-in to an institute:
web interface will show a list of institutions in the blockchain (with a search feature, time-permitting)
the client can select an institute and check-in --only if they are not currently checked in somewhere else
the web interface will broadcast a transaction

Check-out of an institution:
web interface will allow clients to check out of the institution they checked in to

### Institution’s allowed actions
Verify a client:
institution physically verifies an identification document
inputs some government ID number into the interface 
(ex. SSN, Driver’s license number, state ID number)
web interface handles data and make a transaction for the client
transaction is broadcasted and adds an encrypted copy of the ID number to the client’s struct
 
Adding information to a checked-in client’s record:
all checked-in clients will appear as a list on the web interface
an employee at the institute can select the client they are currently helping
the web interface will take a permission key and a file as input
the web interface will send a transaction with the permission key, file, and automatically-added date as parameters
The transaction will encrypt the permission key with the client’s public key and add the three inputs and the institution’s own public address as record metadata 

Check Out Clients
Institutions will be able to view all checked-in clients on the website
If they delete a client from their list, the web interface will create and broadcast a check-out transaction 
 
## Build Instructions

Clone this project. No other local set up is needed.
 
## Dev Instructions

Submit a pull request to the github project.
 

 
