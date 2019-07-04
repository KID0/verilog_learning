import cmath

def main():

    w20=Twiddle_factor_generator(2,0,1,1)
    w21=Twiddle_factor_generator(2,1,1,1)

    print(w21)
    print(w21.real)
    print(w21.imag)
    print("{:+.32f}".format(w21.imag))
    
'''
N=2**M
nk= 0,1,2,3...(N/2)-1
L=1,2,3...M
'''

def Twiddle_factor_generator(N,nk,M,L):
    w = (cmath.exp(-2j*(cmath.pi)*nk*(2**(M-L))/N))
    return w

if __name__ == '__main__':
    main()

