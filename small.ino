void setup() {
  Serial.begin(115200);
  delay(100);
  //Serial.println("Grbl 1.1h ['$' for help]");

}

void loop() {
  if (Serial.available()) {
          String cmd = Serial.readStringUntil('\n');
          cmd.trim();
          if (cmd[0] == '?') {Serial.println("<Idle|MPos:0.000,0.000,0.000|FS:0,0>");return;}
          else Serial.println("ok");
  }
}
