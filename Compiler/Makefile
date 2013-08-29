CC = gcc

CFLAGS = -o

comp:
	gcc -c a.s
	gcc -c interface.c
	gcc -o a a.o interface.o

clean:
	rm -f a
	rm -f *~
	rm -f *.o