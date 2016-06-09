-- begin_generated_IBM_copyright_prolog                            
--                                                                 
-- This is an automatically generated copyright prolog.            
-- After initializing,  DO NOT MODIFY OR MOVE                      
-- ****************************************************************
-- Licensed Materials - Property of IBM                            
-- 5724-Y95                                                        
-- (C) Copyright IBM Corp.  2011, 2016    All Rights Reserved.     
-- US Government Users Restricted Rights - Use, duplication or     
-- disclosure restricted by GSA ADP Schedule Contract with         
-- IBM Corp.                                                       
--                                                                 
-- end_generated_IBM_copyright_prolog                              
Create Table VOICE_CDR(
RECORD_TYPE SMALLINT,
RECORD_NUMBER INTEGER,
CALL_REFERENCE VARCHAR(12),
CALL_REFERENCE_TIME TIMESTAMP,
CALL_TYPE VARCHAR(4),
CALLED_IMEI VARCHAR(15),
CALLED_IMSI VARCHAR(15),
CALLED_NUMBER VARCHAR(25),
CALLED_NUMBER_NPI VARCHAR(4),
CALLED_NUMBER_TON VARCHAR(4),
CALLING_IMEI VARCHAR(15),
CALLING_IMSI VARCHAR(15),
CALLING_NUMBER VARCHAR(25),
CALLING_NUMBER_NPI VARCHAR(4),
CALLING_NUMBER_TON VARCHAR(4),
CALLING_SUBS_FIRST_CI VARCHAR(8),
CALLING_SUBS_FIRST_LAC VARCHAR(8),
CALLING_SUBS_FIRST_MCC VARCHAR(8),
CAUSE_FOR_TERMINATION VARCHAR(10),
FILE_ID INTEGER,
CDR_ID_KEY VARCHAR (28) FOR BIT DATA,
CUSTOMER_TYPE INTEGER,
CALL_START_DATE DATE,
CALL_START_TIME TIME) 
DISTRIBUTE BY HASH ("CALLED_NUMBER")
ORGANIZE BY (("CALL_START_DATE"));


Create Table SMS_CDR(
RECORD_TYPE SMALLINT,
RECORD_NUMBER INTEGER,
CALL_REFERENCE VARCHAR(12),
CALL_REFERENCE_TIME TIMESTAMP,
CALL_TYPE VARCHAR(4),
CALLED_IMEI VARCHAR(15),
CALLED_IMSI VARCHAR(15),
CALLED_NUMBER VARCHAR(25),
CALLED_NUMBER_NPI VARCHAR(4),
CALLED_NUMBER_TON VARCHAR(4),
CALLING_IMEI VARCHAR(15),
CALLING_IMSI VARCHAR(15),
CALLING_NUMBER VARCHAR(25),
CALLING_NUMBER_NPI VARCHAR(4),
CALLING_NUMBER_TON VARCHAR(4),
CALLING_SUBS_FIRST_CI VARCHAR(8),
CALLING_SUBS_FIRST_LAC VARCHAR(8),
CALLING_SUBS_FIRST_MCC VARCHAR(8),
CAUSE_FOR_TERMINATION VARCHAR(10),
FILE_ID INTEGER,
CDR_ID_KEY VARCHAR (28) FOR BIT DATA,
CUSTOMER_TYPE INTEGER,
CALL_START_DATE DATE,
CALL_START_TIME TIME) 
DISTRIBUTE BY HASH ("CALLED_NUMBER")
ORGANIZE BY (("CALL_START_DATE"));
