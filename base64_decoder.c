#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void encode(char *encoded_buf, char *original_text, size_t original_len);
void decode(char *encoded_buf, char *original_text);

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <encoded string>\n", argv[0]);
        fprintf(stderr, "Usage: %s <-d> <decoded string>\n", argv[0]);
        return 1;
    }

    if (strcmp ("-d", argv[1]) == 0) {
        char *original_text = argv[2];
        size_t leng = strlen(original_text) + 1;

        size_t original_len = leng / 4 * 3;
        char *decoded_buf = malloc(original_len + 1);

        decode(decoded_buf, original_text);

        printf("\n");
        printf("%s\n", decoded_buf);
        free(decoded_buf);
    } else {
        char *original_text = argv[1];
        size_t leng = strlen(original_text);
        int remainder = leng % 3;
        size_t original_len = remainder ? leng / 3 * 4 + 4 : leng / 3 * 4;
        char *encoded_buf = malloc(original_len + 1);

        encode(encoded_buf, original_text, original_len);

        printf("\n");
        printf("%s\n", encoded_buf);
        free(encoded_buf);
    }


    return 0;
}
