bison -d parser.y
flex lexer.l
g++ deleting_trailing_spaces.cpp
./a.out
gcc main.c
./a.out < input.txt
dot -Tpdf output.dot -o ../outputs/Parse_Tree.pdf
nasm -f elf64 -o x86_Code.o ../outputs/x86_Code.asm
nasm -f elf64 -o x86_Code.o ../outputs/x86_Code.asm
ld x86_Code.o -o x86_Code
./x86_Code