# https://renenyffenegger.ch/notes/development/languages/C-C-plus-plus/GCC/create-libraries/index
mkdir -p bin
mkdir -p bin/static
mkdir -p bin/shared


gcc -c       main.c        -o bin/main.o

# gcc -c       mylib/add.c    -o bin/static/add.o
# gcc -c       mylib/answer.c -o bin/static/answer.o

gcc -c  -fPIC     mylib/add.c    -o bin/static/add.o
gcc -c    -fPIC   mylib/answer.c -o bin/static/answer.o

ar rcs bin/static/libgarlandtest.a bin/static/add.o bin/static/answer.o

gcc   bin/main.o  -Lbin/static -lgarlandtest -o bin/statically-linked

# make shared lib
# copy to shared location

gcc -c  -fPIC     mylib/add.c    -o bin/shared/add.o
gcc -c    -fPIC   mylib/answer.c -o bin/shared/answer.o
gcc -shared bin/shared/add.o bin/shared/answer.o -o bin/shared/libgarlandtest.so
cp bin/shared/libgarlandtest.so /usr/lib/libgarlandtest.so
chmod 755 /usr/lib/libgarlandtest.so

gcc  bin/main.o -lgarlandtest -o bin/use-shared-library