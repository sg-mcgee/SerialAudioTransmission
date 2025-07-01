import serial
import sounddevice as sd
import numpy as np


#Test serial out
ser = serial.Serial('COM3', 460800, timeout=1)


import sounddevice as sd
import numpy as np

def print_sound(indata, outdata, frames, time, status):
    volume_norm = np.linalg.norm(indata)*10
    print ("|" * int(volume_norm))
    ser.write(volume_norm)

with sd.Stream(callback=print_sound):
    sd.sleep(10000)

print('Finished serial')

ser.close()