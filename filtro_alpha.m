
function filtro_alpha = filtro_alpha(filtradamedia, filtradavar)


%calcula alpha
fprintf('\nCalculando Alpha...');
alpha = zeros(size(filtradamedia));
[lin, col] = size(filtradamedia);

for i = 1 : lin
    for j = 1 : col
        if(filtradavar(i,j) == 0)
            alpha(i,j)=0; %criei isto aqui, ignorar o 0
        else
            alpha(i,j)=((filtradamedia(i,j)^2)/filtradavar(i,j)); 
        end
    end
end
fprintf('Calculo do Alpha Encerrado...');
filtro_alpha = alpha;  % C?lculo Alpha