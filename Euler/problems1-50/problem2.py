def calcFibEvenSum():
    i1, i2, iSum, totalSum= 0,1,0,0
    target=4000000

    while iSum <= target :
        iSum = i1 + i2
        if iSum % 2 == 0 :
            totalSum += iSum
        i1, i2 = i2, i1+i2
        print(totalSum)

calcFibEvenSum()
