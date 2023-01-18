CC=gcc
CFLAGS= -Wall -Werror -Wextra
CFLAGS=
#LDFLAGS=-lgcov
TESTSFLAGS= $(shell pkg-config --libs check)
TESTSFLAGS_MAC= $(shell pkg-config --libs check)
COVERAGE_FLAGS= --coverage
SOURCES=s21_math.c
OBJECTS=$(SOURCES:.c=.o)
SOURCES_STACK=
EXECUTABLE=

all: s21_math.a

test: quick_check

s21_math.a: library

basic_math_obgects:
		$(CC) $(CFLAGS) -c $(SOURCES) $(OBGECTS)

basic_math_obgects_cov:
		$(CC) $(CFLAGS) $(COVERAGE_FLAGS) -c $(SOURCES) $(OBGECTS)

s21_math_test:
		$(CC) -c s21_math_test.c -o s21_math_test.o

library: basic_math_obgects
		ar rc s21_math.a $(OBJECTS)

library_cov: basic_math_obgects_cov
		ar rc s21_math.a $(OBJECTS)

create_library: library
		ranlib s21_math.a

create_library_cov: library_cov
		ranlib s21_math.a

unit_test: create_library s21_math_test
		$(CC) s21_math_test.o s21_math.a $(TESTSFLAGS) --coverage -o s21_test

unit_test_coverage: create_library_cov s21_math_test
		$(CC) s21_math_test.o s21_math.a $(TESTSFLAGS) --coverage  -o s21_test

unit_test_mac: create_library s21_math_test
		$(CC) s21_math_test.o s21_math.a $(TESTSFLAGS_MAC)  -o s21_test

unit_test_mac_coverage: create_library_cov s21_math_test
		$(CC) s21_math_test.o s21_math.a $(TESTSFLAGS_MAC) --coverage -o s21_test -v

gcov_report: unit_test_mac_coverage
		./s21_test >> temp.txt
			rm temp.txt
				lcov -t "s21_math_coverage" -o s21_math.info -c -d .
					genhtml -o report s21_math.info

gcov_report_ubuntu: unit_test_coverage
		./s21_test >> temp.txt
			rm temp.txt
				lcov -t "s21_math_coverage" -o s21_math.info -c -d .
					genhtml -o report s21_math.info

clean:
		rm -f *.out *.a *.o asd.c s21_test *.html *.gcno *.gcda coverage_report.css *.info
			rm -rf report cov-report

rebuild: clean all

style_check:
		cp ../../materials/linters/.clang-format ../../src
			clang-format -n s21_mem_funcs.c

cppcheck:
		cppcheck --enable=all --suppress=missingIncludeSystem ./*.c

quick_check:
		make clean
			make unit_test
				./s21_test

quick_check_mac:
		make clean
			make unit_test_mac
				./s21_test

leaks_check_ubuntu:
	clear
	make clean
	make unit_test
	valgrind --trace-children=yes --track-fds=yes --track-origins=yes --leak-check=full --show-leak-kinds=all ./s21_test

leaks_check_mac:
	clear
	make clean
	make unit_test_mac
	leaks -quiet -atExit -- ./s21_test
