.PHONY = all clean cleanall

all: calc.y.c calc.l.c
	g++ -o calc calc.y.cpp calc.l.cpp

calc.y.c: calc.y
	bison -o calc.y.cpp -d calc.y
    
calc.l.c: calc.l
	flex -o calc.l.cpp calc.l

clean:
	rm -f *.cpp *.h

cleanall: clean
	rm -f calc