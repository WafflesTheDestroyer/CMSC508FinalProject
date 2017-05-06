-- clears these if they exist, would run into conflicts otherwise
drop table Pro_Users cascade constraints;
drop table Trial_Users cascade constraints;
drop table Transaction cascade constraints;
drop table Favorite cascade constraints;
drop table Hours_Of_Operation cascade constraints;
drop table Users cascade constraints;
drop table Event_Beer cascade constraints;
drop table Event cascade constraints;
drop table Sells cascade constraints;
drop table Sales cascade constraints;
drop table Brewery_Phone cascade constraints;
drop table Provider_Phone cascade constraints;
drop table Provider cascade constraints;
drop table Locations_List cascade constraints;
drop table Beer cascade constraints;
drop table Brewery cascade constraints;
drop table B_States cascade constraints;
drop table B_countries cascade constraints;

drop sequence Brewery_ID_seq;
drop sequence Beer_ID_seq;
drop sequence Event_ID_seq;
drop sequence Location_ID_seq;
drop sequence Provider_ID_seq;

-- begin creating tables
create table B_States(
State_Code varchar2(2) not Null,
State_Name varchar2(40) not Null,
primary key (State_Code));

create table B_Countries(
Country_Code varchar2(2) not Null,
Country_Name varchar2(40) not Null,
primary key (Country_Code));

create table Brewery(
Brewery_ID number(20) not Null,
Brewery_Name varchar2(25) not Null,
primary key (Brewery_ID),
Constraint Brewery_Brewery_ID_low_end check (0<Brewery_ID));

create table Beer(
Beer_ID number(20) not Null,
Beer_Name varchar2(25) not Null,
Type varchar2(25),
ABV number(2,2),
IBU number(4),
Color varchar2(25),
Brewery_ID number(20) not Null,
primary key(Beer_ID),
foreign key(Brewery_ID) references Brewery,
Constraint ABV_check_low_end check (0<=ABV),
Constraint ABV_check_high_end check (ABV<=100),
Constraint IBU_check_low_end check (0<=IBU),
Constraint IBU_check_high_end check (IBU<=100),
Constraint Beer_Beer_ID_low_end check (0<Beer_ID),
Constraint Beer_Brewery_ID_low_end check (0<Brewery_ID));

create table Locations_List(
Location_ID number(20) not Null,
Address1 varchar2(25),
Address2 varchar2(25),
Address3 varchar2(25),
City varchar2(25),
State_Code varchar2(2) references B_States,
Zip_Code varchar2(5),
Country_Code varchar2(2) references B_Countries,
primary key (Location_ID),
Constraint Location_Location_ID_low_end check (0<Location_ID));

create table Provider(
Provider_ID number(20) not Null,
Provider_Name varchar2(25),
Location_ID number(20),
primary key (Provider_ID),
foreign key (Location_ID) references Locations_List,
Constraint Provider_Provider_ID_low_end check (0<Provider_ID),
Constraint PRovider_Location_ID_low_end check (0<Location_ID));

create table Provider_Phone(
Provider_ID number(20) not Null,
Phone_Number varchar2(11) not Null,
Phone_Name varchar2(25),
Constraint P_Phone_Provider_ID_low_end check (0<Provider_ID));

create table Brewery_Phone(
Brewery_ID number(20) not Null,
Phone_Number varchar2(11) not Null,
Phone_Name varchar2(25),
Constraint B_Phone_Brewery_ID_low_end check (0<Brewery_ID));

create table Sales(
Provider_ID number(20) not Null,
Beer_ID number(20) not Null,
Start_Date date not Null,
End_Date date not Null,
Percentage_Change number(2,2) not Null,
foreign key (Provider_ID) references Provider,
foreign key (Beer_ID) references Beer,
Constraint Percent_Change_low_end check (-100<=Beer_ID),
Constraint Percent_Change_high_end check (Beer_ID<=100));

create table Sells(
Provider_ID number(20) not Null,
Beer_ID number(20) not Null,
Size_Sold number(8) not Null,
Quantity number(8) not Null,
Price number(4,2),
In_Stock number(1) not Null,
primary key (Provider_ID,Beer_ID),
Constraint Sells_Provider_ID_low_end check (0<Provider_ID),
Constraint Sells_Beer_ID_low_end check (0<Beer_ID),
Constraint Size_Sold_low_end check (0<=Size_Sold),
Constraint Size_Sold_high_end check (1000>=Size_Sold),
Constraint Quantity_low_end check (0<=Quantity),
Constraint Quantity_high_end check (1000>=Quantity),
Constraint Price_low_end check (0<=Price),
Constraint Price_high_end check (1000>=Price));

create table Event(
Event_ID number(20) not Null,
Location_ID number(20),
Start_Date date not Null,
End_Date date not Null,
primary key(Event_ID),
foreign key (Location_ID) references Locations_List,
Constraint Event_Event_ID_low_end check (0<Event_ID),
Constraint Event_Location_ID_low_end check (0<Location_ID));

create table Event_Beer(
Event_ID number(20) not Null,
Provider_ID number(20) not Null,
Beer_ID number(20) not Null,
foreign key (Event_ID) references Event,
foreign key (Provider_ID) references Provider,
foreign key (Beer_ID) references Beer,
primary key(Event_ID, Provider_ID, Beer_ID),
Constraint Event_Beer_Event_ID_low_end check (0<Event_ID),
Constraint Event_Beer_Provider_ID_low_end check (0<Provider_ID),
Constraint Event_Beer_Beer_ID_low_end check (0<Beer_ID));

create table Users(
Email varchar2(40) not Null,
User_Name varchar2(40) not Null,
Password varchar2(64) not Null,
primary key(Email));

create table Hours_Of_Operation(
Provider_ID number(20) not Null,
Day_Of_The_Week number(7) not Null,
Open_Time timestamp not Null,
Close_Time timestamp not Null,
primary key (Provider_ID, Day_Of_The_Week),
Constraint H_O_O_Provider_ID_low_end check (0<Provider_ID),
Constraint Day_Of_The_Week_low_end check (1<=Day_Of_The_Week),
Constraint Day_Of_The_Week_high_end check (7>=Day_Of_The_Week));

create table Favorite(
Email varchar2(40) not Null,
Beer_ID number(20) not Null,
foreign key (Email) references Users,
primary key(Email, Beer_ID),
Constraint Favorite_Beer_ID_low_end check (0<Beer_ID));

create table Transaction(
Email varchar2(40) not Null,
Transaction_Date date not Null,
Beer_ID number(20) not Null,
Size_Sold number(4) not Null,
Quantity number(4) not Null,
Provider_ID number(20) not Null,
Price number(6,2),
primary key(Email, Transaction_Date, Beer_ID, Size_Sold, Quantity),
foreign key(Beer_ID) references Beer,
Constraint Tr_Beer_ID_low_end check (0<Beer_ID),
Constraint Tr_Provider_ID_low_end check (0<Provider_ID),
Constraint Tr_Size_Sold_low_end check (0<=Size_Sold),
Constraint Tr_Size_Sold_high_end check (1000>=Size_Sold),
Constraint Tr_Quantity_low_end check (0<=Quantity),
Constraint Tr_Quantity_high_end check (1000>=Quantity),
Constraint Tr_Price_low_end check (0<=Price),
Constraint Tr_Price_high_end check (1000>=Price));

create table Trial_Users(
Email varchar2(40) not Null,
End_Date date not Null,
primary key(Email, End_Date),
foreign key (Email) references Users);

create table Pro_Users(
Email varchar2(40) not Null,
Payment_Processor_Token varchar2(64) not Null,
Last_Payment_date date,
primary key(Email, Payment_Processor_Token, Last_Payment_Date),
foreign key(Email) references Users);

-- begin creating sequences, views, and triggers
create sequence Beer_ID_seq
start with 1
maxvalue 1000000000000
increment by 1
nocycle;

create or replace view Beers as
select be.beer_id, be.Beer_name, be.type, be.ABV, be.IBU, be.Color, be.brewery_ID from beer be;

create or replace trigger New_Beer
instead of insert on Beers
Begin
insert into beer (Beer_ID, Beer_Name, Type, ABV, IBU, Color, Brewery_ID) values (Beer_ID_seq.nextval, :new.Beer_Name, :new.type, :new.ABV, :new.IBU, :new.Color, :new.Brewery_ID);
END;
/
create sequence Brewery_ID_seq
start with 1
maxvalue 1000000000000
increment by 1
nocycle;

create or replace view Breweries as
select brewery_id, brewery_name from brewery;

create or replace trigger New_Brewery
instead of insert on Breweries
Begin
insert into brewery (Brewery_ID, Brewery_Name) values (Brewery_ID_seq.nextval, :new.Brewery_Name);
END;
/
create sequence Event_ID_seq
start with 1
maxvalue 1000000000000
increment by 1
nocycle;

create or replace view Events as
select Event_id, Location_id, Start_date, End_date from Event;


create or replace trigger New_Event
instead of insert on Events
Begin
insert into event (Event_id, Location_id, Start_date, End_date) values (Event_ID_seq.nextval, :new.location_id, :new.start_date, :new.end_date);
END;
/
create sequence Location_ID_seq
start with 1
maxvalue 1000000000000
increment by 1
nocycle;


create or replace view b_Locations as
select location_id, address1, address2, address3, city, state_code, zip_code, country_code from locations_list;


create or replace trigger New_Location
instead of insert on b_Locations
Begin
insert into locations_list (Location_ID, address1, address2, address3, city, state_code, zip_code, country_code) values (Location_ID_seq.nextval, :new.address1, :new.address2, :new.address3, :new.city, :new.state_code, :new.zip_code, :new.country_code);
END;
/
create sequence Provider_ID_seq
start with 1
maxvalue 1000000000000
increment by 1
nocycle;

create or replace view Providers as
select provider_id, provider_name, location_id from provider;


create or replace trigger New_Provider
instead of insert on providers
Begin
insert into provider (Provider_ID, Provider_Name, Location_id) values (Provider_ID_seq.nextval, :new.Provider_Name, :new.location_id);
END;
/

create or replace function password_manager (
  hash_input in users.password%TYPE,
  email_input in users.email%TYPE)
     return varchar2
is
     hash_expected users.password%TYPE;
begin
     select password into hash_expected
     from users
     where email = email_input;
     if hash_expected = hash_input then
         return 'TRUE';
     else
         return 'FALSE';
     end if;
end password_manager;
/

-- begin filling in data
-- b_states
insert into b_states values ('AL','Alabama');
insert into b_states values ('AK','Alaska');
insert into b_states values ('AS','American Samoa');
insert into b_states values ('AZ','Arizona');
insert into b_states values ('AR','Arkansas');
insert into b_states values ('CA','California');
insert into b_states values ('CO','Colorado');
insert into b_states values ('CT','Connecticut');
insert into b_states values ('DE','Delaware');
insert into b_states values ('DC','District of Columbia');
insert into b_states values ('FM','Federated States of Micronesia');
insert into b_states values ('FL','Florida');
insert into b_states values ('GA','Georgia');
insert into b_states values ('GU','Guam');
insert into b_states values ('HI','Hawaii');
insert into b_states values ('ID','Idaho');
insert into b_states values ('IL','Illinois');
insert into b_states values ('IN','Indiana');
insert into b_states values ('IA','Iowa');
insert into b_states values ('KS','Kansas');
insert into b_states values ('KY','Kentucky');
insert into b_states values ('LA','Louisiana');
insert into b_states values ('ME','Maine');
insert into b_states values ('MH','Marshall Islands');
insert into b_states values ('MD','Maryland');
insert into b_states values ('MA','Massachusetts');
insert into b_states values ('MI','Michigan');
insert into b_states values ('MN','Minnesota');
insert into b_states values ('MS','Mississippi');
insert into b_states values ('MO','Missouri');
insert into b_states values ('MT','Montana');
insert into b_states values ('NE','Nebraska');
insert into b_states values ('NV','Nevada');
insert into b_states values ('NH','New Hampshire');
insert into b_states values ('NJ','New Jersey');
insert into b_states values ('NM','New Mexico');
insert into b_states values ('NY','New York');
insert into b_states values ('NC','North Carolina');
insert into b_states values ('ND','North Dakota');
insert into b_states values ('MP','Northern Mariana Islands');
insert into b_states values ('OH','Ohio');
insert into b_states values ('OK','Oklahoma');
insert into b_states values ('OR','Oregon');
insert into b_states values ('PW','Palau');
insert into b_states values ('PA','Pennsylvania');
insert into b_states values ('PR','Puerto Rico');
insert into b_states values ('RI','Rhode Island');
insert into b_states values ('SC','South Carolina');
insert into b_states values ('SD','South Dakota');
insert into b_states values ('TN','Tennessee');
insert into b_states values ('TX','Texas');
insert into b_states values ('UT','Utah');
insert into b_states values ('VT','Vermont');
insert into b_states values ('VI','Virgin Islands');
insert into b_states values ('VA','Virginia');
insert into b_states values ('WA','Washington');
insert into b_states values ('WV','West Virginia');
insert into b_states values ('WI','Wisconsin');
insert into b_states values ('WY','Wyoming');

-- b_countries
insert into b_countries values ('AF', 'Afghanistan');
insert into b_countries values ('AL', 'Albania');
insert into b_countries values ('DZ', 'Algeria');
insert into b_countries values ('DS', 'American Samoa');
insert into b_countries values ('AD', 'Andorra');
insert into b_countries values ('AO', 'Angola');
insert into b_countries values ('AI', 'Anguilla');
insert into b_countries values ('AQ', 'Antarctica');
insert into b_countries values ('AG', 'Antigua and Barbuda');
insert into b_countries values ('AR', 'Argentina');
insert into b_countries values ('AM', 'Armenia');
insert into b_countries values ('AW', 'Aruba');
insert into b_countries values ('AU', 'Australia');
insert into b_countries values ('AT', 'Austria');
insert into b_countries values ('AZ', 'Azerbaijan');
insert into b_countries values ('BS', 'Bahamas');
insert into b_countries values ('BH', 'Bahrain');
insert into b_countries values ('BD', 'Bangladesh');
insert into b_countries values ('BB', 'Barbados');
insert into b_countries values ('BY', 'Belarus');
insert into b_countries values ('BE', 'Belgium');
insert into b_countries values ('BZ', 'Belize');
insert into b_countries values ('BJ', 'Benin');
insert into b_countries values ('BM', 'Bermuda');
insert into b_countries values ('BT', 'Bhutan');
insert into b_countries values ('BO', 'Bolivia');
insert into b_countries values ('BA', 'Bosnia and Herzegovina');
insert into b_countries values ('BW', 'Botswana');
insert into b_countries values ('BV', 'Bouvet Island');
insert into b_countries values ('BR', 'Brazil');
insert into b_countries values ('IO', 'British Indian Ocean Territory');
insert into b_countries values ('BN', 'Brunei Darussalam');
insert into b_countries values ('BG', 'Bulgaria');
insert into b_countries values ('BF', 'Burkina Faso');
insert into b_countries values ('BI', 'Burundi');
insert into b_countries values ('KH', 'Cambodia');
insert into b_countries values ('CM', 'Cameroon');
insert into b_countries values ('CA', 'Canada');
insert into b_countries values ('CV', 'Cape Verde');
insert into b_countries values ('KY', 'Cayman Islands');
insert into b_countries values ('CF', 'Central African Republic');
insert into b_countries values ('TD', 'Chad');
insert into b_countries values ('CL', 'Chile');
insert into b_countries values ('CN', 'China');
insert into b_countries values ('CX', 'Christmas Island');
insert into b_countries values ('CC', 'Cocos (Keeling) Islands');
insert into b_countries values ('CO', 'Colombia');
insert into b_countries values ('KM', 'Comoros');
insert into b_countries values ('CG', 'Congo');
insert into b_countries values ('CK', 'Cook Islands');
insert into b_countries values ('CR', 'Costa Rica');
insert into b_countries values ('HR', 'Croatia (Hrvatska)');
insert into b_countries values ('CU', 'Cuba');
insert into b_countries values ('CY', 'Cyprus');
insert into b_countries values ('CZ', 'Czech Republic');
insert into b_countries values ('DK', 'Denmark');
insert into b_countries values ('DJ', 'Djibouti');
insert into b_countries values ('DM', 'Dominica');
insert into b_countries values ('DO', 'Dominican Republic');
insert into b_countries values ('TP', 'East Timor');
insert into b_countries values ('EC', 'Ecuador');
insert into b_countries values ('EG', 'Egypt');
insert into b_countries values ('SV', 'El Salvador');
insert into b_countries values ('GQ', 'Equatorial Guinea');
insert into b_countries values ('ER', 'Eritrea');
insert into b_countries values ('EE', 'Estonia');
insert into b_countries values ('ET', 'Ethiopia');
insert into b_countries values ('FK', 'Falkland Islands (Malvinas)');
insert into b_countries values ('FO', 'Faroe Islands');
insert into b_countries values ('FJ', 'Fiji');
insert into b_countries values ('FI', 'Finland');
insert into b_countries values ('FR', 'France');
insert into b_countries values ('FX', 'France, Metropolitan');
insert into b_countries values ('GF', 'French Guiana');
insert into b_countries values ('PF', 'French Polynesia');
insert into b_countries values ('TF', 'French Southern Territories');
insert into b_countries values ('GA', 'Gabon');
insert into b_countries values ('GM', 'Gambia');
insert into b_countries values ('GE', 'Georgia');
insert into b_countries values ('DE', 'Germany');
insert into b_countries values ('GH', 'Ghana');
insert into b_countries values ('GI', 'Gibraltar');
insert into b_countries values ('GK', 'Guernsey');
insert into b_countries values ('GR', 'Greece');
insert into b_countries values ('GL', 'Greenland');
insert into b_countries values ('GD', 'Grenada');
insert into b_countries values ('GP', 'Guadeloupe');
insert into b_countries values ('GU', 'Guam');
insert into b_countries values ('GT', 'Guatemala');
insert into b_countries values ('GN', 'Guinea');
insert into b_countries values ('GW', 'Guinea-Bissau');
insert into b_countries values ('GY', 'Guyana');
insert into b_countries values ('HT', 'Haiti');
insert into b_countries values ('HM', 'Heard and Mc Donald Islands');
insert into b_countries values ('HN', 'Honduras');
insert into b_countries values ('HK', 'Hong Kong');
insert into b_countries values ('HU', 'Hungary');
insert into b_countries values ('IS', 'Iceland');
insert into b_countries values ('IN', 'India');
insert into b_countries values ('IM', 'Isle of Man');
insert into b_countries values ('ID', 'Indonesia');
insert into b_countries values ('IR', 'Iran (Islamic Republic of)');
insert into b_countries values ('IQ', 'Iraq');
insert into b_countries values ('IE', 'Ireland');
insert into b_countries values ('IL', 'Israel');
insert into b_countries values ('IT', 'Italy');
insert into b_countries values ('CI', 'Ivory Coast');
insert into b_countries values ('JE', 'Jersey');
insert into b_countries values ('JM', 'Jamaica');
insert into b_countries values ('JP', 'Japan');
insert into b_countries values ('JO', 'Jordan');
insert into b_countries values ('KZ', 'Kazakhstan');
insert into b_countries values ('KE', 'Kenya');
insert into b_countries values ('KI', 'Kiribati');
insert into b_countries values ('KP', 'Korea, Democratic People''s Republic of');
insert into b_countries values ('KR', 'Korea, Republic of');
insert into b_countries values ('XK', 'Kosovo');
insert into b_countries values ('KW', 'Kuwait');
insert into b_countries values ('KG', 'Kyrgyzstan');
insert into b_countries values ('LA', 'Lao People''s Democratic Republic');
insert into b_countries values ('LV', 'Latvia');
insert into b_countries values ('LB', 'Lebanon');
insert into b_countries values ('LS', 'Lesotho');
insert into b_countries values ('LR', 'Liberia');
insert into b_countries values ('LY', 'Libyan Arab Jamahiriya');
insert into b_countries values ('LI', 'Liechtenstein');
insert into b_countries values ('LT', 'Lithuania');
insert into b_countries values ('LU', 'Luxembourg');
insert into b_countries values ('MO', 'Macau');
insert into b_countries values ('MK', 'Macedonia');
insert into b_countries values ('MG', 'Madagascar');
insert into b_countries values ('MW', 'Malawi');
insert into b_countries values ('MY', 'Malaysia');
insert into b_countries values ('MV', 'Maldives');
insert into b_countries values ('ML', 'Mali');
insert into b_countries values ('MT', 'Malta');
insert into b_countries values ('MH', 'Marshall Islands');
insert into b_countries values ('MQ', 'Martinique');
insert into b_countries values ('MR', 'Mauritania');
insert into b_countries values ('MU', 'Mauritius');
insert into b_countries values ('TY', 'Mayotte');
insert into b_countries values ('MX', 'Mexico');
insert into b_countries values ('FM', 'Micronesia, Federated States of');
insert into b_countries values ('MD', 'Moldova, Republic of');
insert into b_countries values ('MC', 'Monaco');
insert into b_countries values ('MN', 'Mongolia');
insert into b_countries values ('ME', 'Montenegro');
insert into b_countries values ('MS', 'Montserrat');
insert into b_countries values ('MA', 'Morocco');
insert into b_countries values ('MZ', 'Mozambique');
insert into b_countries values ('MM', 'Myanmar');
insert into b_countries values ('NA', 'Namibia');
insert into b_countries values ('NR', 'Nauru');
insert into b_countries values ('NP', 'Nepal');
insert into b_countries values ('NL', 'Netherlands');
insert into b_countries values ('AN', 'Netherlands Antilles');
insert into b_countries values ('NC', 'New Caledonia');
insert into b_countries values ('NZ', 'New Zealand');
insert into b_countries values ('NI', 'Nicaragua');
insert into b_countries values ('NE', 'Niger');
insert into b_countries values ('NG', 'Nigeria');
insert into b_countries values ('NU', 'Niue');
insert into b_countries values ('NF', 'Norfolk Island');
insert into b_countries values ('MP', 'Northern Mariana Islands');
insert into b_countries values ('NO', 'Norway');
insert into b_countries values ('OM', 'Oman');
insert into b_countries values ('PK', 'Pakistan');
insert into b_countries values ('PW', 'Palau');
insert into b_countries values ('PS', 'Palestine');
insert into b_countries values ('PA', 'Panama');
insert into b_countries values ('PG', 'Papua New Guinea');
insert into b_countries values ('PY', 'Paraguay');
insert into b_countries values ('PE', 'Peru');
insert into b_countries values ('PH', 'Philippines');
insert into b_countries values ('PN', 'Pitcairn');
insert into b_countries values ('PL', 'Poland');
insert into b_countries values ('PT', 'Portugal');
insert into b_countries values ('PR', 'Puerto Rico');
insert into b_countries values ('QA', 'Qatar');
insert into b_countries values ('RE', 'Reunion');
insert into b_countries values ('RO', 'Romania');
insert into b_countries values ('RU', 'Russian Federation');
insert into b_countries values ('RW', 'Rwanda');
insert into b_countries values ('KN', 'Saint Kitts and Nevis');
insert into b_countries values ('LC', 'Saint Lucia');
insert into b_countries values ('VC', 'Saint Vincent and the Grenadines');
insert into b_countries values ('WS', 'Samoa');
insert into b_countries values ('SM', 'San Marino');
insert into b_countries values ('ST', 'Sao Tome and Principe');
insert into b_countries values ('SA', 'Saudi Arabia');
insert into b_countries values ('SN', 'Senegal');
insert into b_countries values ('RS', 'Serbia');
insert into b_countries values ('SC', 'Seychelles');
insert into b_countries values ('SL', 'Sierra Leone');
insert into b_countries values ('SG', 'Singapore');
insert into b_countries values ('SK', 'Slovakia');
insert into b_countries values ('SI', 'Slovenia');
insert into b_countries values ('SB', 'Solomon Islands');
insert into b_countries values ('SO', 'Somalia');
insert into b_countries values ('ZA', 'South Africa');
insert into b_countries values ('GS', 'South Georgia South Sandwich Islands');
insert into b_countries values ('ES', 'Spain');
insert into b_countries values ('LK', 'Sri Lanka');
insert into b_countries values ('SH', 'St. Helena');
insert into b_countries values ('PM', 'St. Pierre and Miquelon');
insert into b_countries values ('SD', 'Sudan');
insert into b_countries values ('SR', 'Suriname');
insert into b_countries values ('SJ', 'Svalbard and Jan Mayen Islands');
insert into b_countries values ('SZ', 'Swaziland');
insert into b_countries values ('SE', 'Sweden');
insert into b_countries values ('CH', 'Switzerland');
insert into b_countries values ('SY', 'Syrian Arab Republic');
insert into b_countries values ('TW', 'Taiwan');
insert into b_countries values ('TJ', 'Tajikistan');
insert into b_countries values ('TZ', 'Tanzania, United Republic of');
insert into b_countries values ('TH', 'Thailand');
insert into b_countries values ('TG', 'Togo');
insert into b_countries values ('TK', 'Tokelau');
insert into b_countries values ('TO', 'Tonga');
insert into b_countries values ('TT', 'Trinidad and Tobago');
insert into b_countries values ('TN', 'Tunisia');
insert into b_countries values ('TR', 'Turkey');
insert into b_countries values ('TM', 'Turkmenistan');
insert into b_countries values ('TC', 'Turks and Caicos Islands');
insert into b_countries values ('TV', 'Tuvalu');
insert into b_countries values ('UG', 'Uganda');
insert into b_countries values ('UA', 'Ukraine');
insert into b_countries values ('AE', 'United Arab Emirates');
insert into b_countries values ('GB', 'United Kingdom');
insert into b_countries values ('US', 'United States');
insert into b_countries values ('UM', 'United States minor outlying islands');
insert into b_countries values ('UY', 'Uruguay');
insert into b_countries values ('UZ', 'Uzbekistan');
insert into b_countries values ('VU', 'Vanuatu');
insert into b_countries values ('VA', 'Vatican City State');
insert into b_countries values ('VE', 'Venezuela');
insert into b_countries values ('VN', 'Vietnam');
insert into b_countries values ('VG', 'Virgin Islands (British)');
insert into b_countries values ('VI', 'Virgin Islands (U.S.)');
insert into b_countries values ('WF', 'Wallis and Futuna Islands');
insert into b_countries values ('EH', 'Western Sahara');
insert into b_countries values ('YE', 'Yemen');
insert into b_countries values ('ZR', 'Zaire');
insert into b_countries values ('ZM', 'Zambia');
insert into b_countries values ('ZW', 'Zimbabwe');

-- breweries table
insert into breweries values (null, 'Dogwood');
insert into breweries values (null, 'Milwakee');
insert into breweries values (null, 'Budweighser');
insert into breweries values (null, 'Flying Dog');
insert into breweries values (null, 'Fish Dog');
insert into breweries values (null, 'Center Of The Galaxy');
-- /breweries table

-- beers table
insert into beers values (null, 'PBR', 'Pilsner', 0.71, 7, 'Red', 4);
insert into beers values (null, 'Warm Beer', 'Pilsner', 0.54, 43, 'Brown', 5);
insert into beers values (null, 'Pizza Beer', 'Ale', 0.24, 44, 'Yellow', 3);
insert into beers values (null, 'Sunset', 'Porter', 0.08, 63, 'Golden', 1);
insert into beers values (null, 'Monkey Beer', 'Red Ale', 0.66, 4, 'Red', 4);
insert into beers values (null, '90 Minute IPA', 'IPA', 0.55, 41, 'Maroon', 3);
insert into beers values (null, '120 Minute IPA', 'IPA', 0.08, 21, 'Maroon', 3);
insert into beers values (null, 'Numero Uno', 'Lager', 0.62, 45, 'Pale', 3);
insert into beers values (null, 'Apple Cider', 'Cider', 0.54, 34, 'Red', 6);
insert into beers values (null, 'Green Apple Cider', 'Cider', 0.51, 96, 'Green', 6);
-- /beers table

-- b_locations table
insert into b_locations values (null, '777 Main Street', '', '', 'Richmond', 'VA', 23220, 'US');
insert into b_locations values (null, '123 Maple Road', '', '', 'Chapel Hill', 'NC', 43223, 'US');
insert into b_locations values (null, '543 Pine Tree Street', '', '', 'Richmond', 'VA', 23220, 'US');
-- /b_locations table

-- providers table
insert into providers values (null, 'Johnson Store', 1);
insert into providers values (null, 'Pickle Farm', 2);
insert into providers values (null, 'Kroger', 3);
-- /providers table

-- Provider_Phone table
insert into Provider_Phone values (1, '8041231234', 'Office');
insert into Provider_Phone values (1, '8888888880', 'Sales');
insert into Provider_Phone values (2, '2982742333', 'Front Office');
insert into Provider_Phone values (3, '3249293832', 'Green Room');
insert into Provider_Phone values (3, '8889993339', 'Sales');
-- /Provider_Phone table

-- Brewery_Phone table
insert into Brewery_Phone values (1, '3838339393', 'Sales');
insert into Brewery_Phone values (2, '4445556666', 'Sales');
insert into Brewery_Phone values (3, '2543984398', 'Sales');
insert into Brewery_Phone values (3, '2598798989', 'Tours');
insert into Brewery_Phone values (4, '3294859822', 'Sales');
insert into Brewery_Phone values (5, '2987922298', 'Sales');
insert into Brewery_Phone values (6, '2982982982', 'Sales');
insert into Brewery_Phone values (6, '2982982982', 'that one guy');
-- /Brewery_Phone table

-- Sales table
insert into Sales values (1, 1, to_date('2003/05/03 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), to_date('2003/06/03 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), 0.27);
insert into Sales values (1, 2, to_date('2003/05/07 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), to_date('2003/05/14 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), 0.46);
insert into Sales values (3, 3, to_date('2006/05/03 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), to_date('2007/05/03 21:00:10', 'yyyy/mm/dd hh24:mi:ss'), 0.34);
-- /Sales table

-- Sells table
insert into Sells values (1, 1, 25, 23, 9.1, 1);
insert into Sells values (1, 2, 34, 4, 11.6, 1);
insert into Sells values (3, 3, 15, 5, 14.5, 1);
insert into Sells values (1, 5, 35, 18, 12.0, 1);
insert into Sells values (1, 4, 18, 10, 8.8, 0);
insert into Sells values (2, 1, 22, 19, 16.7, 1);
insert into Sells values (2, 2, 10, 21, 9.3, 0);
insert into Sells values (2, 3, 14, 10, 12.3, 1);
insert into Sells values (2, 6, 32, 10, 10.7, 1);
insert into Sells values (3, 1, 15, 6, 16.6, 1);
insert into Sells values (3, 5, 27, 6, 17.0, 1);
insert into Sells values (3, 4, 16, 23, 12.4, 0);
insert into Sells values (3, 6, 21, 9, 9.5, 1);
-- /Sells table

-- events table
insert into events values (null, 1, to_date('2003/05/03 10:00:10', 'yyyy/mm/dd hh24:mi:ss'), to_date('2003/05/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'));
insert into events values (null, 2, to_date('2004/05/03 10:00:10', 'yyyy/mm/dd hh24:mi:ss'), to_date('2004/05/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'));
-- /events table

-- Event_Beer table
insert into Event_Beer values (1, 1, 1);
insert into Event_Beer values (1, 1, 5);
insert into Event_Beer values (2, 2, 3);
insert into Event_Beer values (2, 3, 6);
-- /Event_Beer table

-- Users table
insert into Users values ('joe@joe.com', 'joejoejoe', 'f0e4c2f76c58916ec258f246851bea091d14d4247a2fc3e18694461b1816e13b');
insert into Users values ('user1@kmail.com', 'user2', 'f6f2ea8f45d8a057c9566a33f99474da2e5c6a6604d736121650e2730c6fb0a3');
-- /Users table

-- Favorite table
insert into Favorite values ('joe@joe.com', 1);
insert into Favorite values ('joe@joe.com', 2);
insert into Favorite values ('joe@joe.com', 6);
insert into Favorite values ('user1@kmail.com', 10);
insert into Favorite values ('user1@kmail.com', 8);
insert into Favorite values ('user1@kmail.com', 3);
-- /Favorite table

-- Transaction table
insert into Transaction values ('joe@joe.com', to_date('2003/08/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'), 1, 7, 8, 1, 4);
insert into Transaction values ('joe@joe.com', to_date('2003/07/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'), 2, 7, 8, 2, 7);
insert into Transaction values ('user1@kmail.com', to_date('2003/09/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'), 2, 7, 8, 2, 7);
insert into Transaction values ('user1@kmail.com', to_date('2003/01/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'), 2, 7, 8, 2, 7);
-- /Transaction table

-- Trial_Users table
insert into Trial_Users values ('joe@joe.com', to_date('2012/08/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'));
-- /Trial_Users table

-- Pro_Users table
insert into Pro_Users values ('user1@kmail.com', 'wa8444nyco9m', to_date('2016/01/03 16:00:10', 'yyyy/mm/dd hh24:mi:ss'));
-- /Pro_Users table

-- Hours_Of_Operation table
insert into hours_of_operation values (1, 3, to_timestamp('01:00:00', 'HH24:MI:SS'), to_timestamp('13:00:00', 'HH24:MI:SS'));
insert into hours_of_operation values (1, 4, to_timestamp('01:00:00', 'HH24:MI:SS'), to_timestamp('13:00:00', 'HH24:MI:SS'));
insert into hours_of_operation values (1, 5, to_timestamp('01:00:00', 'HH24:MI:SS'), to_timestamp('13:00:00', 'HH24:MI:SS'));
-- /Hours_Of_Operation table


-- commit
commit;
