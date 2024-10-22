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
  my_pi = calculate_pi(2000000)
  print(my_pi)
  print(my_pi - math.pi)
