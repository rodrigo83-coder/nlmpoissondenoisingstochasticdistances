function [proj, proj_ruidosa] = gera_shepplogan(noise)
    ph = phantom(108);
    %ph = phantom(108);
    %imwrite(ph, 'imagem_original.png');
    %ph = ph/255;
    %ph=im2double(ph);
    %ph=phantom('Modified Shepp-Logan', 108);
    ph = ph(5:104,17:92);
    %imshow(ph)
   
    
    theta = (180/128);
    
    ra = radon(ph,1:theta:180);
    [l c] = size(ra);
    ra = ra(2:l,1:c);
    
    proj = (ra' * -1) + max(max(ra)) +20;
    %proj = open_file_proj('./phantoms/shepplogan100.das');
    
    proj_temp = proj;
    
    % se for passado algum parametro para a funcao as projecoes sao geradas
    % com ruido Poisson
    if nargin >0,
         maxproj = max(max(proj));
         [l c] = size(proj);
         for i=1:l,
             for j=1:c,
                if proj(i,j) == maxproj,
                    proj(i,j) = 0;
                end
             end
         end
         proj = double( imnoise( uint16(proj) ,'poisson') );
         maxproj = max(max(proj)) + 1;
         for i=1:l,
             for j=1:c,
                if proj(i,j) == 0,
                    proj(i,j) = maxproj;
                end
             end
         end
    end     
    proj_ruidosa = proj/255;
    proj = proj_temp/255;
    
    subplot(1,1,1);
    imshow(proj,[]);
    title('Original');
    

end