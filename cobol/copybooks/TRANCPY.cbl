      *================================================================
      *    PURPOSE: TRANSACTION RECORD LAYOYT
      *    IMMUTABLE ENTITY REPRESENTATION
      *================================================================
       01  TRANSACTION-RECORD.
           05 TRAN-ID                          PIC X(36).
           05 TRAN-TYPE                        PIC X(03). 
               88 TRAN-DEPOSIT                 VALUE 'DEP'. 
               88 TRAN-WITHDRAW                VALUE 'WTH'.
               88 TRAN-TRANSFER-OUT            VALUE 'TXO'.
               88 TRAN-TRANSFER-IN             VALUE 'TXI'.
               88 TRAN-FEE                     VALUE 'FEE'.
               88 TRAN-INTERES                 VALUE 'INT'.
               88 TRAN-PAYMENT                 VALUE 'PAY'.
           05 TRAN-ACCOUNT-NUMER               PIC X(20).
           05 TRAN-RELATED-ACCOUNT             PIC X(20).
           05 TRAN-AMOUT                       PIC S9(13)V99 COMP-3.
           05 TRAN-FEE-AMOUT                   PIC S9(13)V99 COMP-3.  
           05 TRAN-BALANCE-AFTER               PIC S9(13)V99 COMP-3.
           05 TRAN-DESCRIPTION                 PIC X(100).
           05 TRAN-CHANNEL                     PIC X(03).
               88 CHANNEL-BRANC                VALUE 'BRA'.
               88 CHANNEL-ATM                  VALUE 'ATM'.
               88 CHANNEL-INTERNET             VALUE 'INT'.
               88 CHANNEL-MOBILE               VALUE 'MOB'.
               88 CHANNEL-API                  VALUE 'API'.
           05 TRAN-TIMESTAMP                   PIC X(26).
           05 TRAN-USER-ID                     PIC X(08).
           05 TRAN-TERMINAL-ID                 PIC X(10).
           05 TRAN-STATUS                      PIC X(01).
               88 TRAN-COMPLETED               VALUE 'C'.
               88 TRAN-PENDING                 VALUE 'P'.
               88 TRAN-REVERSED                VALUE 'R'.
           05 TRAN-REVERSAL-ID                 PIC X(36).
           05 FILLER                           PIC X(50).
