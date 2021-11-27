DROP PACKAGE BANKING_PROCS;

CREATE PACKAGE BANKING_PROCS AS

  PROCEDURE createBankLink(
    p_bic        VARCHAR2,
    p_bankname   VARCHAR2,
    p_linkname   VARCHAR2,
    p_username   VARCHAR2,
    p_password   VARCHAR2,
    p_host       VARCHAR2,
    p_oracle_sid VARCHAR2 DEFAULT 'xe'
  );

  PROCEDURE withdraw(
    p_value NUMBER,
    p_iban  VARCHAR2,
    p_bic   VARCHAR2
  );

  PROCEDURE deposit(
    p_value NUMBER,
    p_iban  VARCHAR2,
    p_bic   VARCHAR2
  );

  PROCEDURE transfer(
    p_value   NUMBER,
    from_iban VARCHAR2,
    from_bic  VARCHAR2,
    to_iban   VARCHAR2,
    to_bic    VARCHAR2
  );

END BANKING_PROCS;
/

SHOW ERRORS;

CREATE PACKAGE BODY BANKING_PROCS AS

  PROCEDURE createBankLink(
    p_bic        VARCHAR2,
    p_bankname   VARCHAR2,
    p_linkname   VARCHAR2,
    p_username   VARCHAR2,
    p_password   VARCHAR2,
    p_host       VARCHAR2,
    p_oracle_sid VARCHAR2 DEFAULT 'xe') IS

    numberOfLinks NUMBER;
	numberOfInfos NUMBER;
    link_exists EXCEPTION;

    BEGIN

      -- check if linkname already exists
      SELECT Count(*) INTO numberOfLinks FROM user_db_links WHERE DB_LINK LIKE p_linkname;
      IF (numberOfLinks > 0) THEN
        RAISE link_exists;
      END IF;
      -- create database link here
      EXECUTE IMMEDIATE 'CREATE DATABASE LINK ' || p_linkname || ' CONNECT TO ' || p_username || ' IDENTIFIED BY ' || p_password || ' USING ''(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' || p_host || ' )(PORT = 1521))) (CONNECT_DATA = (SID = ' || p_oracle_sid || ')))''';

	  
	  SELECT Count(*) INTO numberOfInfos FROM bank_config WHERE LOWER(linkname) LIKE LOWER(p_linkname);
	  IF (numberOfInfos > 0) THEN
	    -- delete old config entry
		DELETE FROM bank_config WHERE LOWER(linkname) LIKE LOWER(p_linkname);
	  END IF;
      -- store info in config table
      INSERT INTO bank_config VALUES (p_bic, p_bankname, 'remote', p_linkname, p_username, p_password, p_host, p_oracle_sid);

	  
      EXCEPTION 
	    WHEN link_exists THEN raise_application_error(-20011, 'Error in banking_proc.createDBLink: database link with same name already exists !!');

    END createBankLink;


  PROCEDURE withdraw(
    p_value NUMBER,
    p_iban  VARCHAR2,
    p_bic   VARCHAR2) IS

      unknown_account EXCEPTION;
      not_local_bic EXCEPTION;

    BEGIN

      -- TODO put your PL/SQL Code here to withdraw money from the local bank
      SELECT CUSTOMERNO,IBAN,BALANCE INTO P_VALUE, P_IBAN FROM ACCOUNT WHERE IBAN=P_IBAN;
      SELECT BIC INTO P_BIC FROM BANK_CONFIG WHERE BIC=P_BIC;
      if(P_VALUE > BALANCE)
     
      dbms_output.put_line('Not sufficient amount of money in this account')
      
      UPDATE ACCOUNT 
      SET BALANCE=(BALANCE-P_VALUE) WHERE P_IBAN=IBAN
      else ((p_bic != BIC)  AND (p_iban != IBAN ))
       BEGIN
      
         RAISE(unknown_account AND not_local_bic;
         dbms_output.put_line('not ready yet :-(');
        
       END
      END if;
      
      
      
      
      
      
      


    END withdraw;

  PROCEDURE deposit(
    p_value NUMBER,
    p_iban  VARCHAR2,
    p_bic   VARCHAR2) IS

    BEGIN

      -- TODO put your PL/SQL Code here to deposit money on the local bank
      SELECT IBAN, BANLANCE INTO P_VALUE   FROM ACCOUNT WHERE IBAN= p_iban;
      SELECT BIC INTO P_BIC FROM BANK_CONFIG, WHERE BIC=p_bic;
      INSERT INTO p_value VALUES;
        ('p_iban','p_bic')
      if ((BIC != p_bic) AND (IBAN != P_IBAN))
      dbms_output.put_line('not ready yet :-(');
      else 
      UPDATE ACCOUNT
      SET BALANCE = (BALANCE + P_VALUE) WHERE P_IBAN=IBAN;
      END if;

    END deposit;


  PROCEDURE transfer(
    p_value   NUMBER,
    from_iban VARCHAR2,
    from_bic  VARCHAR2,
    to_iban   VARCHAR2,
    to_bic    VARCHAR2
  ) IS

    BEGIN

      -- TODO put your PL/SQL Code here to transfer money from the local bank to an remote bank.
      -- Attention: use the previously defined deposit and withdraw PL/SQL procedures again here.
      -- You can also use PL/SQL procedures via the database link at the remote bank.
      
      SELECT IBAN,BALANCE INTO TRANSFER FROM ACCOUNT
      SELECT BIC INTO TRANSFER FROM BANK_CONFIG 
      if((from_iban = IBAN) and (from_bic=bic)
      UPDATE account
      SET BALANCE = BALANCE-P_VALUE
      ELSE IF ((to_iban=IBAN) and  (to_bic=bic))
      UPDATE account 
      SET BALANCE = BALANCE+P_VALUE
      ELSE IF (to_bic=from_bic)
      dbms_output.put_line('Not possible to do a transaction to the same account :-(');
      ELSE
      dbms_output.put_line('not ready yet :-(');
     END if;
    END transfer;

END BANKING_PROCS;
/

SHOW ERRORS;


