function [ d ] = kldist_3(a1, b1, a2, b2, psi_a1, psi_a2, loggamma_a1, loggamma_a2)
    %[l,c]=size(a1);
    %d = zeros(l,c);

    logb1 = log(b1);
    logb2 = log(b2);
    
    d = (((a1-1).*psi_a1 - logb1 - a1 - loggamma_a1 + loggamma_a2  + a2.*logb2 - (a2-1).*(psi_a1 + logb1) + (a1.*b1)./b2)+...
         ((a2-1).*psi_a2 - logb2 - a2 - loggamma_a2 + loggamma_a1  + a1.*logb1 - (a1-1).*(psi_a2 + logb2) + (a2.*b2)./b1))/2;
    %fprintf('Fazendo meu filtro KL\n');

end

