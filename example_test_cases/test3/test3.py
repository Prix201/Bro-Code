def maximum_list(array : list[int],n : int)->int:
    i:int = 0
    j:int = 0
    while i < n:
        if j < array[i]:
            j = array[i]
        i += 1
    return j

def minimum_list(array : list[int], n : int)->int:
    i:int = 0
    j:int = 0
    while i < n:
        if j > array[i]:
            j = array[i]
        i += 1
    return j
def mean_list(array:list[int],n:int)->int:
    sum:int = 0
    i:int = 0

    while i < n:
        sum += array[i]
        i+=1

    return sum/n 

def main():
    array:list[int] = [1,2,3,4,5,6,7,8,9,10]
    n:int = len(array)

    print(maximum_list(array,n))
    print(minimum_list(array,n))
    print(mean_list(array,n))



if __name__ == "__main__":
    main()
