#include <stdio.h>
#include <string.h>
#include <math.h>
int main()
{
    long long int n, m, i, j;
    printf("enter the size");
    scanf("%lld", &n);
    long long int a[n];
    for (i = 0; i < n; i++)
    {
        scanf("%lld", &a[i]);
    }
    printf("enter the size");
    scanf("%lld", &m);
    long long int b[m];
    for (j = 0; j < m; j++)
    {
        scanf("%lld", &b[j]);
    }
    for (j = 0; j < m; j++)
    {
        long long int count = 0;
        for (i = 0; i < n - 1; i++)
        {
            if (a[i] != a[i + 1])
            {
                if (b[j] < a[i])
                {
                    count = count + 1;
                }
                else
                {
                    count = count;
                }
            }
            else
            {
                continue;
            }
        }
        if (a[n - 1] > b[j])
        {
            count = count + 1;
        }
        printf("%lld\n", count + 1);
    }
    return 0;
}