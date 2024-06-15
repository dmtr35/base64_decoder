CC = gcc
CFLAGS = -Wall -g


all:
	$(CC) $(CFLAGS) -c base64_decoder.c -o base64_decoder.o
	$(CC) $(CFLAGS) -c encode_att.s -o encode_att.o
	$(CC) $(CFLAGS) -c decode_att.s -o decode_att.o
	$(CC) $(CFLAGS) base64_decoder.o encode_att.o decode_att.o -o base64_decoder 
	rm base64_decoder.o encode_att.o decode_att.o
	
