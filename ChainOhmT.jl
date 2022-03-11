module Chaincoeffs
using HDF5
using Tables
include("quadohmT.jl")
include("mcdis2.jl")

#Ohmic spectral density with hard cut-off

#irout = 1 => stieltjes
#irout = 2 => lanczos

global mc, mp, iq, idelta, irout, AB, a, s, beta

## Spectral density parameters
#a = 0.025
wc = 1
beta = parse(Float64, ARGS[2])
xc = wc
chain = parse(Float64, ARGS[1])

## discretisation parameters
mc=4 # the number of component intervals
mp=0 # the number of points in the discrete part of the measure (mp=0 if there is none)
iq=1 # a parameter to be set equal to 1, if the user provides his or her own quadrature routine, and different from 1 otherwise
idelta=2 # a parameter whose default value is 1, but is preferably set equal to 2, if iq=1 and the user provides Gauss-type quadrature routines
irout=2 # choice between the Stieltjes (irout = 1) and the Lanczos procedure (irout != 1)
AB =[[-Inf -xc];[-xc 0];[0 xc];[xc Inf]] # component intervals
N=4 #Number of bath modes
Mmax=5000 # max number of iterations
eps0=1e11*eps(Float64)

jacerg = zeros(N,2)

ab = 0.
ab, Mcap, kount, suc, uv = mcdis(N,eps0,quadfinT,Mmax)

for m = 1:N-1
    jacerg[m,1] = wc.*ab[m,1] #site energy
    jacerg[m,2] = wc.*sqrt(ab[m+1,2]) #hopping parameter
end
jacerg[N,1] = ab[N,1]

eta = 0.
for i = 1:mc
    xw = quadfinT(Mcap,i,uv)
    global eta += sum(xw[:,2])
end
jacerg[N,2] = wc.*sqrt(eta/pi) #coupling coeficient

#astr=string(a)
#sstr=string(s)
bstr=string(beta)

# the "path" to the data inside of the h5 file is beta -> alpha -> s -> data (e, t or c)
# beta is the inverse temperature, alpha (a) is the coupling strength

# Write onsite energies
h5write("/home/berkane/Documents/stage/Chaincoeffs/fermionic.h5", string("/",bstr,"/", string(chain),"/e"), jacerg[1:N,1])
# Write hopping energies
h5write("/home/berkane/Documents/stage/Chaincoeffs/fermionic.h5", string("/",bstr,"/", string(chain),"/t"), jacerg[1:N-1,2])
# Write coupling coefficient
h5write("/home/berkane/Documents/stage/Chaincoeffs/fermionic.h5", string("/",bstr,"/", string(chain),"/c"), jacerg[N,2])


end
