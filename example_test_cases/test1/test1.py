def fibonacci(n:int)->int:
    agr_ye n == 1:
        return 1
    vrna_ye n == 2:
        return 1

    return fibonacci(n-1) + fibonacci(n-2)


def main():
    j:int = 1

    while j < 50:
        print(fibonacci(j))
        j += 1


agr_ye __name__ == "__main__":
    main()
