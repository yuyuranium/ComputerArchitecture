#include <stdio.h>
#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int *twoSum(int *numbers, int numbersSize, int target, int *returnSize) {
    int *p = numbers, *q = &numbers[numbersSize - 1];
    while (1) {
        int sum = *p + *q;
        if (sum < target) {
            ++p;
        } else if (sum > target) {
            --q;
        } else {
            int *sol = malloc(2 * sizeof(int));
            sol[0] = p - numbers + 1;
            sol[1] = q - numbers + 1;
            *returnSize = 2;
            return sol;
        }
    }
}

int main(void) {
    int numbers[8] = {2, 3, 5, 7, 11, 13, 17, 19}, target = 12, returnSize, i;
    printf("numbers = ");
    for (i = 0; i < 8; ++i) {
        printf("%d ", numbers[i]);
    }
    printf("\ntarget = %d\n", target);
    int *sol = twoSum(numbers, 8, target, &returnSize);
    printf("sol = ");
    for (i = 0; i < returnSize; ++i) {
        printf("%d ", sol[i]);
    }
    printf("\n");
}
