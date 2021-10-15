#include <stdio.h>
#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int *twoSum(int *numbers, int numbersSize, int target, int *returnSize) {
    int p = 0, r = numbersSize - 1;
    while (1) {
        int sum = numbers[p] + numbers[r];
        if (sum < target)
            ++p;
        else if (sum > target)
            --r;
        else {
            int *sol = malloc(2 * sizeof(int));
            sol[0] = p + 1;
            sol[1] = r + 1;
            *returnSize = 2;
            return sol;
        }
    }
}

int main(void) {
    int numbers[8] = {2, 3, 5, 7, 11, 13, 17, 19}, target = 18, returnSize, i;
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
