-- https://stackoverflow.com/questions/12662534/how-to-filter-a-mysql-database-with-user-input-on-a-website-and-then-spit-the-fi

-- login page
select * from Login L;


-- sign up page (without data)
insert into Users
values (username, password, location, no. of pets...);

insert into Pets
values (name, owner, size...);

-- my account
-- delete pet record
delete from Pets
where ownername=%s
and petName=%s;

-- delet account
delete from Users
where username=%s;

-- change password
update password
set password=%s
where username=%s
and verification_qn=%s;

-- favourite account
select * from Favourite;

-- Main Page
select * from Services
order by minBid asc;

select * from Services
order by minBid desc;

select * from Services S left join Users U 
	on S.hostName=U.username
order by U.rating
;

select * from Services S
where S.hostName in(
	select hostName
	from Favourite
	);

-- select posts with time availability covers the required time slot
select * from Services S
where S.startdate<=%s
and S.enddate>=%s;

-- select greater capacity
select * from Services S
where S.capacity>=%s;

-- my listing
select * from Services S
where S.hostName=%s;

insert into Services S
values (input1,input2,input3....);

-- history
select * from BiddingStatus
where status='succeed';

-- all the accommodation that he has provided
select * from Accommodation A
where A.hostName=%s; --input name

-- completed service
select * from Accommodation A
where A.hostName=%s
and A.status='completed';

select * from Accommodation A
where A.hostName=%s
and A.status='sending';


-- when payment is made
update Accommodation A
set status='completed'
and id=%s;


-- pet owner view
--1. the overall view with all the services displayed.
select * from Services


--2. the specific view about a particular service after they select a specific services
with maxBid as(
	select id, max(bids) as max_bid, count(*) as total_num
	from BiddingStatus
	group by id
	having id=%s
)
select s.hostName, s.startdate, s.enddate, s.minBid, a.areaName, 
	s.capacity, M.max_bid, M.total_num
from (Services S left join Area A on s.hostName = a.username) 
	left join maxBid M on M.id=S.id;



--display a petOwner's current bidding information
select *
from BiddingStatus b
where b.ownerName = %s and b.status = 'pending'

--check whether it is a favourite user, the fisrt %s is the hostName and the second is the  
SELECT 1   
from  PetOwners p
where %s in ( 
 select f.hostName
 from Favourite f
 where p.ownerName = %s
)

---insert into wishlist
insert into Wishlist
values (input1, input2...);

select * from Wishlist;


-- list of bidders
select ownerName, bids from BiddingStatus

-- sorting algo, used when caretaker use our algo to select the winning bidder
select ownerName
from BiddingStatus BS left join Users U on BS.ownerName=U.username
order by BS.bids desc, U.numPets, U.rating desc, BS.created_at-- we are changing date data type???
limit 1;


-- care taker view:
-- time domain
select startdate, enddate
from Services S
where S.hostName=%s;

-- username
select username from Users where username=%s;

-- select all bidders with their information
select BS.ownername, bids, rating 
from BiddingStatus BS left join Users U on BS.hostName=U.username
where BS.id=%s;

-- Transaction
-- 1. when you add one more pet, update the Users' profile
Begin transaction
insert into Pets
values (petName, petType, ownerName...)
where ownerName=%s; 

update Users
set numPets=numPets+1
where username=%s;
commit;

-- 2. After bidding, update status => insert the id into Accommodation
-- update status for the winning bidder
BEGIN TRANSACTION
update BiddingStatus
set status='success'
where ownerName=%s 
and id=%s
and status='pending';

-- update other biddings status
update BiddingStatus
set status='fail'
where id=%s
and status='pending';

-- insert into Accommodation
insert into Accomodation
values (hostName, id, ownerName, status, rating)
COMMIT;
