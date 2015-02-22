%option noyywrap
%{
#define LINE_LEN 20
#define MAX_LENGTH 10
#define ALPHA 52
#define MAX 500
#define INT 1
#define BOOL 2
#define DOUBLE 3
#define STRING 4
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
struct {
	char name[MAX_LENGTH];
	int type;
}table[MAX];
int swtch[ALPHA];
char alphabet[ALPHA] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
char symbol[MAX];
int next[MAX]; 
int t_index=0;
int t_flag=0;
int available = 0;
%}
letter 	[a-zA-Z]
digit	[0-9]
id	{letter}({letter}|{digit})*
ws	[ \t]+

%%
{ws}		{}
[\n]+		{printf("\n");}
int			{yylval=insert(yytext); printf("int "); return (_int);}
boolean 	{yytext[yyleng]='*'; yylval=insert(yytext); printf("boolean "); return (_boolean);}
double		{yytext[yyleng]='*'; yylval=insert(yytext); printf("double "); return (_double);}
string		{yytext[yyleng]='*'; yylval=insert(yytext); printf("string "); return (_string);}
break		{yytext[yyleng]='*'; yylval=insert(yytext); printf("break "); return (_break);}
class		{yytext[yyleng]='*'; yylval=insert(yytext); printf("class "); return (_class);}
else		{yytext[yyleng]='*'; yylval=insert(yytext); printf("else "); return (_else);}
extends		{yytext[yyleng]='*'; yylval=insert(yytext); printf("extends "); return (_extends);}
false|true	{yytext[yyleng]='*'; yylval=insert(yytext); printf("booleanconstant "); return (_booleanconstant);}
for			{yytext[yyleng]='*'; yylval=insert(yytext); printf("for "); return (_for);}
if			{yytext[yyleng]='*'; yylval=insert(yytext); printf("if "); return (_if);}
implements	{yytext[yyleng]='*'; yylval=insert(yytext); printf("imp "); return (_implements);}
interface	{yytext[yyleng]='*'; yylval=insert(yytext); printf("interface "); return (_interface);}
newarray	{yytext[yyleng]='*'; yylval=insert(yytext); printf("newarray "); return (_newarray);}
println		{yytext[yyleng]='*'; yylval=insert(yytext); printf("println "); return (_println);}
readln		{yytext[yyleng]='*'; yylval=insert(yytext); printf("readln "); return (_readln);}
return		{yytext[yyleng]='*'; yylval=insert(yytext); printf("return "); return (_return);}
void		{yytext[yyleng]='*'; yylval=insert(yytext); printf("void "); return (_void);}
while		{yytext[yyleng]='*'; yylval=insert(yytext); printf("while "); return (_while);}
{id}		{yytext[yyleng]='*'; yylval=insert(yytext); printf("id "); return(_id);}
[0-9]+\.([0-9]*)((e|E)(["+""-"]?)[0-9]+)?    {printf("doubleconstant "); return (_doubleconstant);}
(0x|0X)([0-9]|[A-Fa-f])+|([0-9])+	{printf("intconstant "); return (_intconstant);}
\"([^\"\n])*\"	{printf("stringconstant "); return (_stringconstant);}
"/*"([^"*/"])*"*/"	{}
"+"			{printf("plus "); return (_plus);}
"-"			{printf("minus "); return (_minus);}
"*"			{printf("multiplication "); return (_multiplication);}
"/"			{printf("divison "); return (_division);}
"%"			{printf("mod "); return (_mod);}
"<"			{printf("less "); return (_less);}
"<="		{printf("lessequal "); return (_lessequal);}
">"			{printf("greater "); return (_greater);}
">="		{printf("greaterequal "); return (_greaterequal);}
"=="		{printf("equal "); return (_equal);}
"!="		{printf("notequal "); return (_notequal);}
"&&"		{printf("and "); return (_and);}
"||"		{printf("or "); return (_or);}
"!"			{printf("not "); return (_not);}
"="			{printf("assignop "); return (_assignop);}
";"			{printf("semicolon "); return (_semicolon);}
","			{printf("comma "); return (_comma);}
"."			{printf("period "); return (_period);}
"("			{printf("leftparen "); return (_leftparen);}
")"			{printf("rightparen "); return (_rightparen);}
"["			{printf("leftbracket "); return (_leftbracket);}
"]"			{printf("rightbracket "); return (_rightbracket);}
"{"			{printf("leftbrace "); return (_leftbrace);}
"}"			{printf("rightbrace "); return (_rightbrace);}
"//".*\n	{}
. 			{}

%%

int init(){
	
	int i;
	for (i = 0; i < ALPHA; i++){
	swtch[i] = -1;
	}
	for (i = 0; i < MAX; i++) {
		next[i] = -1;
	}
	for (i = 0; i < MAX; i++) {
		symbol[i] = ' ';
	}
	
}

int insert(char *s) {
	// s = id
	int ascii = *s; // value of first symbol
	int vos;
	if (ascii < 91) {
		vos = ascii - 65;
	} else {
		vos = ascii - 71;
	}
	
	// new token
	if (swtch[vos] < 0) {

		swtch[vos] = available; // available = index of symbol
		int i; 
		for (i =0; i < ((int)yyleng - 1); i++){
			symbol[available] = *(++s);
			available++;
		}
		symbol[available] = '*';
		available++;
	}
	else {

		int currentPtr = swtch[vos]; // grab value in swtch table
		int exit = 0; 
		*(++s);
		while (!exit) {
			if (symbol[currentPtr] == *s) {
				if (*s != '*') {
					currentPtr++;
					*(++s);
				} else {
					available = currentPtr + 1;
					exit = 1;
				} 
			}
			else {
				if (next[currentPtr] >= 0) { // if defined]
				currentPtr = next[currentPtr];
				}
				else {
					next[currentPtr] = available;
					int i; 
					while (*s != '*'){
						symbol[available] = *s;
						*(++s);
						available++;
						
		
					}
					symbol[available] = '*';
					available++;
					exit = 1;
				}
			}
		}
	}

	return 0;
}

int printer() {

	int i=0;
	int j=0;
	int interval = LINE_LEN;
	printf("\n\n        ");
	//===========PRINTS THE SWITCH TABLE================
	while (1){
		//-----PRINTS THE ALHPABET-----
		while(j<interval){
			
			if(j<ALPHA){
				printf(" %c ", alphabet[j]);
			}
			
			j++;
		}
		printf("\nswitch: ");
		//-----PRINTS THE SWITCH TABLE-----
		while(i < interval){
			if(i<ALPHA){
				if(swtch[i] != -1) 
					printf(" ");
				printf("%d ", swtch[i]);
			}else{
				break;
			}
			i++;
		}
		if (i>=ALPHA) break;
		interval +=LINE_LEN;
		printf("\n\n        ");
		if (i==ALPHA) break;
	}
	printf("\n\n");
	//=============PRINTS THE SYMBOL AND NEXT TABLES===========
	 i=0;
	 j=0;
	 int count=0;
	 interval = LINE_LEN;
	printf("\n\n        ");
	while (1){
		//-----PRINTS THE INDEX-----
		while(count < interval){
			if(count<MAX){
				if(count < 10)
					printf(" ");
				printf("%d ", count);
			}
			count++;
		}
		
		//-----PRINTS THE SYMBOL TABLE-----
		printf("\nsymbol: ");
		while(i < interval){
			if(i<MAX){
				printf(" %c ", symbol[i]);
			}
			i++;
		}
		
		//-----PRINTS THE NEXT TABLE-----
		printf("\nnext:  ");
		while(j<interval){
			
			if(j<MAX){

				if(next[j] < 10){
					if(next[j]==-1)
						printf("   ");
					else
						printf("  %d", next[j]);
					
					}
				else 
					printf(" %d", next[j]);
			}
			else{
				break;
			}
			j++;
		}
		if (j>=MAX) break;
		interval +=LINE_LEN;
		printf("\n\n        ");
		if (j==MAX) break;
	}
	return 0;	
}



int main () {

	init();
	while(yylex()) {}
	
	printer();
	/*
	
	printf("\n\nSWITCH\n");
	int i;
	for (i = 0; i < ALPHA; i++) {
		printf("%d ", swtch[i]);
	}
	printf("\n\nSYMBOL\n");
	for (i = 0; i < MAX; i++) {
		printf("%c ", symbol[i]);
	}
	printf("\n\nNEXT\n");
	for (i = 0; i < MAX; i++) {
		printf("%d ", next[i]);
	}
	printf("\n");

	*/
	return 0;
	
}