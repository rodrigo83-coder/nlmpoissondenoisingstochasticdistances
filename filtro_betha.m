function filtro_betha = filtro_betha(filtradamedia, filtradavar)

fprintf('\nCalculando Betha...');
betha = zeros(size(filtradamedia));
[lin, col] = size(betha);
%minmedia = 0.01;
for i = 1 : lin
    for j = 1 : col
        if(filtradavar(i,j) == 0)
            betha(i,j)=0; %fiz isso por conta da divisao por 0           
        else
            betha(i,j)=(filtradamedia(i,j)/filtradavar(i,j));
            %cuidado com divis?o por 0...em todos locais
        end
    end
end
fprintf('Calculo Betha Encerrado...');

filtro_betha = betha;