1-find-db-adress.asm --> test read .db location corectly

2-grezo-sbloca-lasergrbl -> sbloca le frecce lasrgrbl pero aspeta trasmite caracter si bloca

<code>

[Start / Reset]
        │
        ▼
Send Startup Message → "Grbl 1.1h ['$' for help]"
        │
        ▼
[Main Loop: Serial Receive]
        │
        ▼
+---------------------------+
| Read byte from serial     |
+---------------------------+
        │
        ▼
+---------------------------+
| Is byte '?' ?             |
+---------------------------+
      │ Yes
      ▼
Send Status → "<Idle|MPos:0.000,0.000,0.000|FS:0,0>"
      │
      ▼
Go back to read serial

      │ No
      ▼
+---------------------------+
| Is byte '\n' ?            |
+---------------------------+
      │ Yes
      ▼
Send "ok"
      │
      ▼
Go back to read serial

      │ No
      ▼
+---------------------------+
| Any other command ?       |
+---------------------------+
      │ Yes
      ▼
Send "ok"  ← LaserGRBL thinks command executed
      │
      ▼
Go back to read serial


</code>
