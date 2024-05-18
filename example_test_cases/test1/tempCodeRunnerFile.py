def fibonacci(n:int)->int:
    if n == 1:
        return 1
    elif n == 2:
        return 1

    return fibonacci(n-1) + fibonacci(n-2)


def main():
    j:int = 1

    while j < 40:
        print(fibonacci(j))
        j += 1


if __name__ == "__main__":
    main()
