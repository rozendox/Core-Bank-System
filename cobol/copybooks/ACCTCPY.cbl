      *================================================================
      *    PURPOSE: ACCOUNT MASTER RECORD LAYOUT
      *    STABLE CONTRACT - (DIP) INTERFACE SEGREGATION
      *================================================================
       01  ACCOUNT-RECORD.  
           05 ACCT-NUMER                PIC X(20).
           05 ACCT-COSTUMER-ID          PIC X(11).
           05 ACCT-TYPE                 PIC X(02).
               88 TYPE-CHECKING         VALUE 'CC'.
               88 TYPE-SAVINGS          VALUE 'CP'.
               88 TYPE-SALARY           VALUE 'CS'.
           05 ACCT-STATUS               PIC X(01).
               88 STATUS-ACTIVE         VALUE 'A'.
               88 STATUS-BLOCKED        VALUE 'B'.
               88 STATUS-CLOSE          VALUE 'C '.
           05 ACCT-BALANCE              PIC S9(13)V99 COMP-3.
           05 ACCT-AVAILABLE-BALANCE    PIC S9(13)V99 COMP-3.
           05 ACCT-BRANCH-CODE          PIC X(04).
           05 ACCT-OPEN-DATE            PIC X(08).
           05 ACCT-LAST-TRANSACTION     PIC X(08).
           05 ACCT-CURRENCY             PIC X(03) VALUE 'BRL'.
           05 ACCT-TYPE-SPECIFIC.
               10 ACCT-OVERDRAFT-LIMIT  PIC S9(11)V99 COMP-3.
               10 ACCT-INTEREST-RATE    PIC S9(01)V9(06) COMP-3.
               10 ACCT-WITRHDRAW-COUNT  PIC 9(03) COMP-3.
               10 ACCT-LAST-INTEREST    PIC X(08).
           05 ACCT-CREATED-BY           PIC X(08).
           05 ACCT-CREATED-AT           PIC X(26).
           05 ACCT-UPDATED-BY           PIC X(08).
           05 ACCT-UPDATED-AT           PIC X(26).
           05 FILLER                    PIC X(50).
