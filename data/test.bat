ECHO OFF
ECHO converting csv to text file..
c:\python27\python.exe C:\Users\user\Documents\Processing\InkSpots\data\csvToText2.py %*
ECHO done..
ECHO converting the text file to a .pde file ..
c:\python27\python.exe C:\Users\user\Documents\Processing\InkSpots\data\stringConvertor.py %*
ECHO done..
ECHO copying the generated file to it's destination
COPY "string.pde" c:\Users\user\Documents\Processing\InkSpots\
ECHO done..
ECHO opening the Project
c:\Users\user\Documents\processing-2.2\processing.exe  C:\Users\user\Documents\Processing\InkSpots\InkSpots.pde
ECHO opened..
PAUSE