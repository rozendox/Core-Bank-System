      *================================================================
      *    PURPOSE: account creation service
      *    factory method (delegacao via CALL)
      *================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCTCRT.
       AUTHOR. CORE-BANKING-TEAM.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-Z15.
       OBJECT-COMPUTER. IBM-Z15.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE ASSIGN TO ACCTMAST
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACCT-NUMBER
               ALTERNATE RECORD KEY IS ACCT-CUSTOMER-ID
                   WITH DUPLICATES
               FILE STATUS IS WS-ACCT-FILE-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE
           LABEL RECORDS ARE STANDARD.
       01  ACCOUNT-FILE-RECORD.
           COPY ACCTCPY.
       
       WORKING-STORAGE SECTION.
       01  WS-PROGRAM-INFO.
           05 WS-PROGRAM-NAME          PIC X(08) VALUE 'ACCTCRT'.
           05 WS-VERSION               PIC X(05) VALUE '01.00'.
           05 WS-TIMESTAMP             PIC X(26).
       
       01  WS-FILE-STATUS.
           05 WS-ACCT-FILE-STATUS      PIC XX.
              88 ACCT-FILE-OK          VALUE '00'.
              88 ACCT-DUPLICATE-KEY    VALUE '22'.
              88 ACCT-FILE-NOT-FOUND   VALUE '35'.
       
       01  WS-RETURN-CODES.
           05 WS-RETURN-CODE           PIC S9(4) COMP.
              88 SUCCESS               VALUE 0.
              88 ERR-DUPLICATE-ACCOUNT VALUE 1001.
              88 ERR-INVALID-TYPE      VALUE 1002.
              88 ERR-INVALID-CUSTOMER  VALUE 1003.
              88 ERR-FILE-ERROR        VALUE 9999.
       
       01  WS-GENERATED-ACCOUNT-NUMBER PIC X(20).
       
       01  WS-CUSTOMER-VALIDATION.
           05 WS-CUST-ID               PIC X(11).
           05 WS-CUST-VALID-FLAG       PIC X(01).
              88 CUSTOMER-VALID        VALUE 'Y'.
              88 CUSTOMER-INVALID      VALUE 'N'.
           05 WS-CUST-RETURN-CODE      PIC S9(4) COMP.
       
       LINKAGE SECTION.
       01  LS-ACCOUNT-REQUEST.
           05 LS-CUSTOMER-ID           PIC X(11).
           05 LS-ACCOUNT-TYPE          PIC X(02).
              88 LS-CHECKING           VALUE 'CC'.
              88 LS-SAVINGS            VALUE 'CP'.
              88 LS-SALARY             VALUE 'CS'.
           05 LS-INITIAL-BALANCE       PIC S9(13)V99 COMP-3.
           05 LS-BRANCH-CODE           PIC X(04).
           05 LS-OVERDRAFT-LIMIT       PIC S9(11)V99 COMP-3.
           05 LS-INTEREST-RATE         PIC S9(01)V9(06) COMP-3.
           05 LS-USER-ID               PIC X(08).
       
       01  LS-ACCOUNT-RESPONSE.
           05 LS-NEW-ACCOUNT-NUMBER    PIC X(20).
           05 LS-CREATION-TIMESTAMP    PIC X(26).
           05 LS-RETURN-CODE           PIC S9(4) COMP.
           05 LS-ERROR-MESSAGE         PIC X(100).
       
       PROCEDURE DIVISION USING LS-ACCOUNT-REQUEST
                                LS-ACCOUNT-RESPONSE.
       
       MAIN-PROCESS.
           PERFORM INITIALIZE-PROCESS
           PERFORM VALIDATE-REQUEST
           
           IF SUCCESS
               PERFORM VALIDATE-CUSTOMER
           END-IF
           
           IF SUCCESS
               PERFORM GENERATE-ACCOUNT-NUMBER
           END-IF
           
           IF SUCCESS
               PERFORM BUILD-ACCOUNT-RECORD
               PERFORM WRITE-ACCOUNT-RECORD
           END-IF
           
           PERFORM FINALIZE-PROCESS
           GOBACK.
       
       INITIALIZE-PROCESS.
           MOVE FUNCTION CURRENT-DATE TO WS-TIMESTAMP
           OPEN I-O ACCOUNT-FILE
           
           IF NOT ACCT-FILE-OK
               MOVE 'FAILED TO OPEN ACCOUNT FILE' 
                   TO LS-ERROR-MESSAGE
               MOVE 9999 TO LS-RETURN-CODE
               SET ERR-FILE-ERROR TO TRUE
           ELSE
               SET SUCCESS TO TRUE
           END-IF.
       
       VALIDATE-REQUEST.
      *    SRP: Validação separada da criação
           IF LS-ACCOUNT-TYPE NOT = 'CC' 
               AND LS-ACCOUNT-TYPE NOT = 'CP'
               AND LS-ACCOUNT-TYPE NOT = 'CS'
               
               MOVE 'INVALID ACCOUNT TYPE' TO LS-ERROR-MESSAGE
               SET ERR-INVALID-TYPE TO TRUE
           END-IF
           
           IF LS-INITIAL-BALANCE < ZERO
               MOVE 'INITIAL BALANCE CANNOT BE NEGATIVE'
                   TO LS-ERROR-MESSAGE
               SET ERR-INVALID-TYPE TO TRUE
           END-IF.
       
       VALIDATE-CUSTOMER.
      *    DIP: Delega validação para programa especializado
           MOVE LS-CUSTOMER-ID TO WS-CUST-ID
           
           CALL 'CUSTVAL' USING WS-CUST-ID
                                WS-CUST-VALID-FLAG
                                WS-CUST-RETURN-CODE
           
           IF NOT CUSTOMER-VALID
               MOVE 'CUSTOMER NOT FOUND OR INVALID'
                   TO LS-ERROR-MESSAGE
               SET ERR-INVALID-CUSTOMER TO TRUE
           END-IF.
       
       GENERATE-ACCOUNT-NUMBER.
      *    Factory Method: Delegação para gerador especializado
           CALL 'ACCTGEN' USING LS-ACCOUNT-TYPE
                                LS-BRANCH-CODE
                                WS-GENERATED-ACCOUNT-NUMBER
                                WS-RETURN-CODE
           
           IF NOT SUCCESS
               MOVE 'FAILED TO GENERATE ACCOUNT NUMBER'
                   TO LS-ERROR-MESSAGE
           END-IF.
       
       BUILD-ACCOUNT-RECORD.
      *    Template Method: Montagem padrão do registro
           INITIALIZE ACCOUNT-RECORD
           
           MOVE WS-GENERATED-ACCOUNT-NUMBER TO ACCT-NUMBER
           MOVE LS-CUSTOMER-ID      TO ACCT-CUSTOMER-ID
           MOVE LS-ACCOUNT-TYPE     TO ACCT-TYPE
           MOVE 'A'                 TO ACCT-STATUS
           MOVE LS-INITIAL-BALANCE  TO ACCT-BALANCE
           MOVE LS-INITIAL-BALANCE  TO ACCT-AVAILABLE-BALANCE
           MOVE LS-BRANCH-CODE      TO ACCT-BRANCH-CODE
           MOVE FUNCTION CURRENT-DATE(1:8) TO ACCT-OPEN-DATE
           MOVE FUNCTION CURRENT-DATE(1:8) TO ACCT-LAST-TRANSACTION
           MOVE 'BRL'               TO ACCT-CURRENCY
           
      *    Liskov Substitution: Campos específicos por tipo
           EVALUATE TRUE
               WHEN LS-CHECKING
                   MOVE LS-OVERDRAFT-LIMIT TO ACCT-OVERDRAFT-LIMIT
                   MOVE ZERO TO ACCT-INTEREST-RATE
                   
               WHEN LS-SAVINGS
                   MOVE ZERO TO ACCT-OVERDRAFT-LIMIT
                   MOVE LS-INTEREST-RATE TO ACCT-INTEREST-RATE
                   MOVE FUNCTION CURRENT-DATE(1:8) 
                       TO ACCT-LAST-INTEREST
                   
               WHEN LS-SALARY
                   MOVE ZERO TO ACCT-OVERDRAFT-LIMIT
                   MOVE ZERO TO ACCT-INTEREST-RATE
           END-EVALUATE
           
           MOVE ZERO                TO ACCT-WITHDRAWAL-COUNT
           MOVE LS-USER-ID          TO ACCT-CREATED-BY
           MOVE WS-TIMESTAMP        TO ACCT-CREATED-AT
           MOVE LS-USER-ID          TO ACCT-UPDATED-BY
           MOVE WS-TIMESTAMP        TO ACCT-UPDATED-AT.
       
       WRITE-ACCOUNT-RECORD.
           WRITE ACCOUNT-FILE-RECORD FROM ACCOUNT-RECORD
           
           EVALUATE TRUE
               WHEN ACCT-FILE-OK
                   MOVE WS-GENERATED-ACCOUNT-NUMBER 
                       TO LS-NEW-ACCOUNT-NUMBER
                   MOVE WS-TIMESTAMP TO LS-CREATION-TIMESTAMP
                   MOVE 0 TO LS-RETURN-CODE
                   SET SUCCESS TO TRUE
                   
               WHEN ACCT-DUPLICATE-KEY
                   MOVE 'DUPLICATE ACCOUNT NUMBER' 
                       TO LS-ERROR-MESSAGE
                   SET ERR-DUPLICATE-ACCOUNT TO TRUE
                   
               WHEN OTHER
                   MOVE 'FILE WRITE ERROR' TO LS-ERROR-MESSAGE
                   SET ERR-FILE-ERROR TO TRUE
           END-EVALUATE.
       
       FINALIZE-PROCESS.
           CLOSE ACCOUNT-FILE
           MOVE WS-RETURN-CODE TO LS-RETURN-CODE.
       
       END PROGRAM ACCTCRT.
    
