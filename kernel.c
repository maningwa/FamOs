
void print(char string[256],int cursor){
	for(int i = 0; i < 256; i++){
		*(unsigned char *)cursor = string[i];
		cursor ++;
	}
}


extern void main(){
	int VIDMEM = 0xb8000;
	char hello_string [] = "That is my name Btw unless you think otherwise";
	print(hello_string,256);
	return;
}

