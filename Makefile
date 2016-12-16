
CC=gcc
FLAGS=-std=c11 -Wall -g

# Om ingen regel i makefilen anges körs den första regeln. Den ges
# ofta namnet "all", och bör bygga allt (för någon bra definition
# av "allt").
all: 

test:

# Här är en *rule* (regel) vars *target* (mål) är greeter, och
# vars *dependencies* (beroenden) är greeter.c, util.o och
# peron.o. Kommandot "make greeter" försöker skapa filen "greeter"
# med hjälp av denna regel. Om någon fil inte finns kommer make
# försöka skapa den med hjälp av sina andra regler.
db: db.c item.o utils.o tree.o list.o iter.o
	$(CC) $(FLAGS) db.c item.o utils.o list.o tree.o iter.o -o db

utils.o: modules/utils.c modules/utils.h
	$(CC) $(FLAGS) modules/utils.c -c

tree.o: swapped_modules/tree.c swapped_modules/tree.h
	$(CC) $(FLAGS) swapped_modules/tree.c -c

list.o: swapped_modules/list.c swapped_modules/list.h
	$(CC) $(FLAGS) swapped_modules/list.c -c

iter.o: swapped_modules/iter.c swapped_modules/iter.h
	$(CC) $(FLAGS) swapped_modules/iter.c -c

item.o: item.c item.h utils.o list.o tree.o
	$(CC) $(FLAGS) item.c utils.o list.o tree.o -c

# Ett @ framför en rad gör att make inte skriver ut vilket
# kommando den kör. I den här regeln gör det att "make test"
# skriver ut
#
#    Running tests...
#    Test successful!
#
# istället för
#
#    echo "Running tests..."
#    Running tests...
#    ./tester < test_in.txt
#    Test successful!
run: db
	./db

memtest: db
	valgrind --leak-check=full --show-leak-kinds=all ./db

##list_test: modules/list_tests.c
##	$(CC) modules/list_test.c


# make clean är en annan vanlig regel som städar bort alla filer
# som makefilen kan bygga. Notera -f som gör att rm inte klagar om
# filen inte finns.
 clean:
	rm -f db
	rm -f *.o
