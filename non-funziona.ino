* Risponde al comando "?" con stato Idle
 * Compatibile con protocollo LaserGRBL
 */

void setup() {
  Serial.begin(115200);
  delay(100);
  // Invia identificazione GRBL all'avvio
  Serial.print("Grbl 1.1h ['$' for help]");
  Serial.write('\n');  // Solo \n, non \r\n
}

void loop() {
  if (Serial.available()) {
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();
    
    if (cmd[0] == '?') {
      // Risposta di stato per LaserGRBL
      Serial.print("<Idle|MPos:0.000,0.000,0.000|FS:0,0>");
      Serial.write('\n');
    }
    else if (cmd == "$") {
      // Comandi settings
      Serial.print("$0=10");
      Serial.write('\n');
      Serial.print("$1=25");
      Serial.write('\n');
      Serial.print("$2=0");
      Serial.write('\n');
      Serial.print("$3=0");
      Serial.write('\n');
      Serial.print("$4=0");
      Serial.write('\n');
      Serial.print("$5=0");
      Serial.write('\n');
      Serial.print("$6=0");
      Serial.write('\n');
      Serial.print("$10=1");
      Serial.write('\n');
      Serial.print("$11=0.010");
      Serial.write('\n');
      Serial.print("$12=0.002");
      Serial.write('\n');
      Serial.print("$13=0");
      Serial.write('\n');
      Serial.print("$20=0");
      Serial.write('\n');
      Serial.print("$21=0");
      Serial.write('\n');
      Serial.print("$22=0");
      Serial.write('\n');
      Serial.print("$23=0");
      Serial.write('\n');
      Serial.print("$24=25.000");
      Serial.write('\n');
      Serial.print("$25=500.000");
      Serial.write('\n');
      Serial.print("$26=250");
      Serial.write('\n');
      Serial.print("$27=1.000");
      Serial.write('\n');
      Serial.print("$30=1000");
      Serial.write('\n');
      Serial.print("$31=0");
      Serial.write('\n');
      Serial.print("$32=0");
      Serial.write('\n');
      Serial.print("$100=250.000");
      Serial.write('\n');
      Serial.print("$101=250.000");
      Serial.write('\n');
      Serial.print("$102=250.000");
      Serial.write('\n');
      Serial.print("$110=500.000");
      Serial.write('\n');
      Serial.print("$111=500.000");
      Serial.write('\n');
      Serial.print("$112=500.000");
      Serial.write('\n');
      Serial.print("$120=10.000");
      Serial.write('\n');
      Serial.print("$121=10.000");
      Serial.write('\n');
      Serial.print("$122=10.000");
      Serial.write('\n');
      Serial.print("$130=200.000");
      Serial.write('\n');
      Serial.print("$131=200.000");
      Serial.write('\n');
      Serial.print("$132=200.000");
      Serial.write('\n');
    }
    else if (cmd == "$I") {
      Serial.print("[VER:1.1h.20190825:]");
      Serial.write('\n');
    }
    else if (cmd == "$G") {
      Serial.print("[GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F0 S0]");
      Serial.write('\n');
    }
    else if (cmd == "$N") {
      Serial.print("[N:0]");
      Serial.write('\n');
    }
    else if (cmd == "$X") {
      Serial.print("[MSG:Unlocked]");
      Serial.write('\n');
      Serial.print("ok");
      Serial.write('\n');
    }
    else if (cmd.length() > 0) {
      // Risposta "ok" per tutti gli altri comandi
      Serial.print("ok");
      Serial.write('\n');
    }
  }
  delay(1);
}

