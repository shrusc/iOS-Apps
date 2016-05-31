//
//  main.c
//  Assignment 1
//
//  Created by Adarsh Kumar on 8/27/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#include <stdio.h>


void polyTable(int N){
    int k = 1;
    printf("The start value of N is %u\n",N);
    for(k=1;k<=N;k++)
    {
        int compute1,compute2,total;
        compute1=(k*k*k);
        compute2=(2*k);

        total=compute1+compute2-3;
        printf("The value of k is %d\n",k);
        printf("The value of the expression is %d\n",total);
        
    }
}

int runningSum(int num){
    static int sum=0;
    sum+=num;
    return sum;
}

int fibonacci(int n){
    if(n==0)
        return 0;
    if(n==1)
        return 1;
    else return (fibonacci(n-1)+fibonacci(n-2));
}

float compute(int n){
    float y=1.1;
    for (int k=0;k<n;k++)
        for (int j=0;j<n;j++){
            y=sin(k*j + y);
            printf("%f",y);
        
        }
    return y;
}

int main(int argc, const char * argv[])
{

    // insert code here...
    polyTable(6);
    int x1,x2,x3,x4;
    x1=runningSum(2);
    printf("the total value is %d\n",x1);
    x2=runningSum(2);
    printf("the total value is %d\n",x2);
    x3=runningSum(3);
    printf("the total value is %d\n",x3);
    x4=runningSum(5);
    printf("the total value is %d\n",x4);
    int n,i;
    printf("enter the number of fibonacci terms you want in the sequence\n");
    scanf("%d",&n);
    printf("The fibonacci series is\n");
    for(i=1;i<=n;i++)
    {
        printf("%d\n",fibonacci(i));
    }
    //compute(1100);
    return 0;
}

