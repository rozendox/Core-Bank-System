      *================================================================
      *    PURPOSE: COSTUMER MASTER RECORD LAYOUT
      *================================================================
       01  COSTUMER-RECORD.
           05 CUST-ID                  PIC X(11).
           05 CUST-TYPE                PIC X(01).
               88 CUST-INDIVIDUAL      VALUE 'I'.
               88 CUST-CORPORATE       VALUE 'C'.
           05 CUST-NAME                PIC X(100).
           05 CUST-DOCUMENT            PIC X(14).
           05 CUST-BIRHT-DATE          PIC X(08).
           05 CUST-EMAIL               PIC X(100).
           05 CUST-PHONE               PIC X(15).
           05 CUST-SEGMENT             PIC X(01).
               88 SEGMENT-RETAIL       VALUE 'R'.
               88 SEGMENT-PRIVATE      VALUE 'P'.
               88 SEGMENT-CORPORATE    VALUE 'C'.
           05 CUST-RELATIONSHIP-DATE   PIC X(08).
           05 CUST-STATUS              PIC X(01).
               88 CUST-ACTIVE          VALUE 'A'.
               88 CUST-INACTIVE        VALUE 'I'.
               88 CUST-BLOCKED         VALUE 'B'.
           05 CUST-RISK-RATING         PIC X(01).
               88 RISK-LOW             VALUE 'L'.
               88 RISK-MEDIUM          VALUE 'M',
               88 RISK-HIGH            VALUE 'H'.
           05 CUST-BRANCH-CODE         PIC X(04).
           05 FILLER                   PIC X(100).
