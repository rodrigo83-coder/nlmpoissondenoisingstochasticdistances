function  z = noise_transform(g,transform)
    switch transform
        case 'ansc', z = anscombe(g);
        case 'ansc_inverse', z = anscombe_inverse(g);
        case 'fisz', 
                     z = fisz(g);
        case 'fisz_inverse', 
            z = fiszinv(g);
    end
end

function  z = anscombe(y)
    z = 2.*sqrt(y + (3/8));
end

function  g = anscombe_inverse(z)
    g = (z/2).^2-(1/8);
end

function f = fisz(signal)

% fisz:      The Fisz transformation applied on a vector of Poisson observations.
% Usage
%            f = fisz(signal)
% Inputs
%   signal	 1-d signal, length(signal)= 2^J.
% Outputs
%   f		    The preprocessed vector of observations after applying 
%            the Fisz transformation on the original signal.
% References
%            Fisz, M. (1955). The limiting distribution of a function of two
%            independent random variables and its statistical applications.
%            "Colloquium Mathematicum", 3, 138-146.
%
%            Fryzlewick, P. & Nason, G.P. (2001). Poisson intensity estimation
%            using wavelets and the Fisz transformation. "Technical Report", 01-10,
%            Department of Mathematics, University of Bristol, UK.

a = 2;
n = length(signal);
nhalf = n/2;
J=log2(n);
res = signal;
sm = zeros(1, nhalf);
dett = sm;
for i=1:J
   sm(1:nhalf) = (res(2*(1:nhalf)-1) + res(2*(1:nhalf)))/a;
   dett(1:nhalf) = (res(2*(1:nhalf)-1) - res(2*(1:nhalf)))/a;
   dett(sm > 0) = dett(sm > 0)./sqrt(sm(sm > 0));
   res(1:nhalf) = sm(1:nhalf);
   res((nhalf+1):n) = dett(1:nhalf);
   n = n/2;
   nhalf = nhalf/2;
   sm = 0;
   dett = 0;
end
nhalf = 1;
n = 2;
for i = 1:J
   sm(1:nhalf) = res(1:nhalf);
   dett(1:nhalf) = res((nhalf + 1):n);
   res(2*(1:nhalf)-1) = a/2 * (sm(1:nhalf) + dett(1:nhalf));
   res(2*(1:nhalf)) = a/2 * (sm(1:nhalf) - dett(1:nhalf));
   n = 2*n;
   nhalf = 2*nhalf;
end
f = res;
end

function f = fiszinv(signal)
% fiszinv:   The inverse Fisz transformation applied on the reconstructed
%            signal after using Gaussian-based thresholds.
% Usage
%            f = fiszinv(signal)
% Inputs
%   signal	 1-d reconstructed signal, length(signal)= 2^J.
% Outputs
%   f        The estimate of the Poisson intensity function.
% References
%            Fisz, M. (1955). The limiting distribution of a function of two
%            independent random variables and its statistical applications.
%            "Colloquium Mathematicum", 3, 138-146.
%
%            Fryzlewick, P. & Nason, G.P. (2001). Poisson intensity estimation
%            using wavelets and the Fisz transformation. "Technical Report", 01-10,
%            Department of Mathematics, University of Bristol, UK.

a = 2;
n = length(signal);
nhalf = n/2;
J=log2(n);
res = signal;
sm = zeros(1, nhalf);
dett = sm;
for i=1:J
   sm(1:nhalf) = (res(2*(1:nhalf)-1) + res(2*(1:nhalf)))/a;
   dett(1:nhalf) = (res(2*(1:nhalf)-1) - res(2*(1:nhalf)))/a;
   res(1:nhalf) = sm(1:nhalf);
   res((nhalf+1):n) = dett(1:nhalf);
   n = n/2;
   nhalf = nhalf/2;
end
nhalf = 1;
n = 2;
for i = 1:J
   sm(1:nhalf) = res(1:nhalf);
   dett(1:nhalf) = res((nhalf + 1):n);
   res(2*(1:nhalf)-1) = a/2 * (sm(1:nhalf) + dett(1:nhalf).*sqrt(sm(1:nhalf)));
   res(2*(1:nhalf)) = a/2 * (sm(1:nhalf) - dett(1:nhalf).*sqrt(sm(1:nhalf)));
   res(res(1:n) < 0) = 0;
   n = 2*n;
   nhalf = 2*nhalf;
end
f = res;
end

function s2 = resize_signal(signal,tamanho)
len = length(signal);
tam = round(abs((tamanho - len)/2));
if tamanho > len,
    for i=1:tamanho,
        s2(i)=0;
    end;
    for i=1:len,
        s2(i+tam)=signal(i);
    end
else
    for i=1:tamanho,
        s2(i)=signal(i+tam);
    end;
    
end;
end

