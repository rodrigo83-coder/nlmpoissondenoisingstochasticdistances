function filtro_media = filtro_media(imagenoisy, janela)
fprintf('\nCalculando Media...');
[lin, col] = size(imagenoisy);
filtradamedia = zeros(size(imagenoisy));
hW = floor(janela/2);
janela = zeros(janela,janela);

for i = 1 : lin
    for j = 1 : col
       lii = i - hW; 
       lif = i + hW;
       coi = j - hW;
       cof = j + hW; 
       x=1;
       media=0;
       for dx = lii : lif
           y=1; 
           for dy = coi : cof
 
               if (dx<1 || dy<1) || (dx>lin || dy>col)
                   janela(x,y) = imagenoisy(i,j);
               else                  
                   janela(x,y) = imagenoisy(dx,dy);
               end
               y=y+1;              
           end
           x=x+1;
       end
       media=mean(mean(janela));
       filtradamedia(i,j) = media;
    end
end
fprintf('Calculo da media encerrado.');

filtro_media = filtradamedia;  % Apply Filtro de M?dia