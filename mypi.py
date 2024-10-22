#!/bin/env python

import math

def myf(x) :
  return 4.0/(1.0 + x*x)

def calculate_pi(n) :
  a = 0.0
  b = 1.0
  dx = (b-a)/(n-1)

  s = 0.0
  for i in range(n) :
    x = a + i*dx 
    s = s + myf(x)
  s = (s - 0.5*(myf(a) + myf(b)))*dx
  return s

if __name__ == "__main__" :
  from datetime import datetime
  my_pi = calculate_pi(20000)
  with open('output.log', 'w') as fout :
    fout.write("Time now: " + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + '\n')
    fout.write(f'{my_pi:.12f}\n')
    fout.write(f'{my_pi - math.pi:.12f}\n')

