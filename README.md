# Lasergrbl-serial-protocol
After i create this ... i find this [tests/fake-grbl-arduino/fake-grbl-arduino.ino](https://github.com/vlachoudis/bCNC/blob/master/tests/fake-grbl-arduino/fake-grbl-arduino.ino)

You can use https://www.costycnc.it/avr1 to compile Fake GRBL Minimal - asm from ino.asm  and upload to arduino to test LaserGRBL derial protocol!!!

Attention ... if (cmd[0] == '?')... is not same with ...if (cmd[0] == "?") ... i spend some times until understand mistakes.

<Idle|MPos:0.000,0.000,0.000|FS:0,0>  need to be send with println() , not function with print()

If understand these finally riceived Lasergrbl activated with arrow activated!

<img width="1447" height="918" alt="image" src="https://github.com/user-attachments/assets/4f862334-836b-4526-bd28-0c82c9dd53a2" />
