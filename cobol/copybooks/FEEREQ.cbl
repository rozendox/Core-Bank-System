      *================================================================
      *    PURPOSE: INTERFACE FOR TARIFF CALC
      *================================================================
       01  FEE-CALCULATION-REQUEST.
           05 FEE-ACCOUNT-TYPE         PIC X(02).
           05 FEE-TRANSACTION-TYPE     PIC X(03).
           05 FEE-TRANSACTION-AMOUT    PIC S9(13)V99 comp-3.
           05 FEE-COSTUMER-SEGMENT     PIC X(01).
           05 FEE-WITHDRAW-COUNT       PIC 9(03) COMP-3.
           05 FEE-CHANNEL              PIC X(03).

       01  FEE-CALCULATION-RESPONSE.
           05 FEE-AMOUNT               PIC S9(11)V99 COMP-3.
           05 FEE-DESCRIPTION          PIC X(50).
           05 FEE-WAIVED-FLAG          PIC X(01).
               88 FEE-APLIED           VALUE 'N'.
               88 FEE-WAIVED           VALUE 'Y'.
           05 FEE-RETURNED-CODE        PIC S9(4) COMP.
               88 FEE-SUCCESS          VALUE 0.
               88 FEE-ERROR            VALUE 9999.
