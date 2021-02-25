function filtro_alphaline = filtro_alphaline(alpha, filtradamedia, W);

%Calcula alpha line
fprintf('\nCalculando Alphaline...');
alphaline = zeros(size(alpha));
somajanelas = zeros(size(alpha));
hW = floor(W/2);
janela = zeros(W,W);
[lin, col] = size(alpha);

for i = 1 : lin
    for j = 1 : col
       lii = i - hW; 
       lif = i + hW;
       coi = j - hW;
       cof = j + hW; 
       x=1;
       for dx = lii : lif
           z=1; 
           for dy = coi : cof
               if (dx<1 || dy<1) || (dx>lin || dy>col)%Caso a janela fique fora da imagem(Bordas)
                   janela(x,z) = filtradamedia(i,j) ;
               else %Caso a janela se encontre dentro da imagem              
                   janela(x,z) = filtradamedia(dx,dy) ;
               end               
               z=z+1;
           end
           x=x+1;
       end      
       somajanelas(i,j) = abs(sum(sum(janela)));
       %alphaline(i,j) = round (alpha(i,j)+somajanelas(i,j)); %Round arredonda para o inteiro mais pr?ximo. Calcula alpha linha soma alpha mais a somatoria da janela da imagem original
       alphaline(i,j) = alpha(i,j)+somajanelas(i,j); %Calcula alpha linha soma alpha mais a somatoria da janela da imagem original
    end
end
fprintf('Calculo do Alphaline Encerrado...');


filtro_alphaline = alphaline; % Calculo do Alphaline