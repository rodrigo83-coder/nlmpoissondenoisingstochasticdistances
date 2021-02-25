function [ d ] = kldist_2(a1,b1,a2,b2, psimap1, psimap2, lgamap1, lgamap2)
    [l,c]=size(a1);
    d = zeros(l,c);

    for i=1:l
        for j=1:c
            d1 = kl_gamma(a1(i,j), b1(i,j), a2(i,j), b2(i,j), psimap1(i,j), lgamap1(i,j), lgamap2(i,j));
            d2 = kl_gamma(a2(i,j), b2(i,j), a1(i,j), b1(i,j), psimap2(i,j), lgamap2(i,j), lgamap1(i,j));
            d(i,j) = (d1+d2)/2;
        end
    end

    function [d] = kl_gamma(a1, b1, a2, b2, psi_a1, loggamma_a1, loggamma_a2)
        d = (a1-1)*psi_a1 - log(b1) - a1 - loggamma_a1 + loggamma_a2  + a2*log(b2) - (a2-1)*(psi_a1 + log(b1)) + (a1*b1)/b2;
    end
end

