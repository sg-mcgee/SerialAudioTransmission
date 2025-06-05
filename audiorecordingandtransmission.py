import serial


#Test serial out
ser = serial.Serial('COM3', 460800, timeout=1)

ser.write(b'ABC')

print('Finished serial')

ser.close()