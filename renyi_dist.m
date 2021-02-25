function [ d ] = renyi_dist(c1, t1, c2, t2, ga1, ga2)

vt = 0.5.*t2+(1-0.5).*t1;
vc = 0.5.*c1+(1-0.5).*c2;
a = log((ga2.*(t2.^c2))./(ga1.*(t1.^c1)))  +  (1./(0.5-1))  .*  log((gamma(vc)./((t1.^c1).*ga1) .* ((t1.*t2./vt).^vc)));
vt = 0.5.*t1+(1-0.5).*t2;
vc = 0.5.*c2+(1-0.5).*c1;
b = log((ga1.*(t1.^c1))./(ga2.*(t2.^c2)))  +  (1./(0.5-1))  .*  log((gamma(vc)./((t2.^c2).*ga2) .* ((t2.*t1./vt).^vc)));
d = (a+b)/2;
%if (isnan(d))
    %fprintf('\nErro');
    %d=0;    
%end
if(d<0.000000001)
    d=0;
end
%fprintf('Fazendo meu filtro Re\n');
end