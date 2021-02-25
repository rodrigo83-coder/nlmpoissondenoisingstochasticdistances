function [output]=nlm_versao_rodrigo_re(input, t, f, h, capa, teta)
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %
     %  input: image to be filtered
     %  t: radio of search window
     %  f: radio of similarity window
     %  h: degree of filtering
     %
     %  Author: Jose Vicente Manjon Herrera & Antoni Buades
     %  Author: Rodrigo C???sar Evangelista
     %  Date: 09-03-2006
     %
     %  Implementation of the Non local filter proposed for A. Buades, B. Coll and J.M. Morel in
     %  "A non-local algorithm for image denoising"
     %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     %valor de f e t... cuidado
     %f = floor(f/2);
     %t = floor(t/2);

     fprintf('\nCalculando Nlm...');
     %Preparando alha e betha
     capa = padarray(capa,[f f],'symmetric');
     teta = padarray(teta,[f f],'symmetric');

     cont=0;
     % Size of the image
     [m n]=size(input);

     % Memory for the output
     output=zeros(m,n);
     estoc=zeros(m,n);

     % Replicate the boundaries of the input image
     input2 = padarray(input,[f f],'symmetric');
     
     
     % Used kernel Janela de similaridade
     %kernel = make_kernel(f);
     %kernel = kernel / sum(sum(kernel));
     %kernel = make_kernel(floor(f/2));
     %kernel = kernel / sum(sum(kernel));


     h=h*h;

     gammap = zeros(size(capa,1),size(capa,2)); % mapa de gamma(capa)
     [a b]=size(input2);
     for l=1:a
        for c=1:b
            gammap(l,c) = gamma(capa(l,c));
        end
     end

     for i=1:m
         for j=1:n

                 i1 = i+ f;
                 j1 = j+ f;

                 c1= capa(i1-f:i1+f, j1-f:j1+f);
                 t1= teta(i1-f:i1+f, j1-f:j1+f);
                 ga1= gammap(i1-f:i1+f, j1-f:j1+f);

                 wmax=0; 
                 average=0;
                 sweight=0;

                 %Janela de busca
                 rmin = max(i1-t,f+1);
                 rmax = min(i1+t,m+f);
                 smin = max(j1-t,f+1);
                 smax = min(j1+t,n+f);

                 for r=rmin:1:rmax
                 for s=smin:1:smax
                        if(r==i1 && s==j1) continue; end;

                        c2= capa(r-f:r+f, s-f:s+f);
                        t2= teta(r-f:r+f, s-f:s+f);
                        
                        ga2= gammap(r-f:r+f, s-f:s+f);

                        
                        dvet = renyi_dist(c1, t1, c2, t2, ga1, ga2);
                        dvet = dvet(~isnan(dvet)&~isinf(dvet));
                        if (numel(dvet) > 0)
                            d = sum(sum(dvet));
                            estoc(i,j) = estoc(i,j)+d;
                            w = exp(-d/h);
                        else
                            estoc(i,j) = -1;
                            w = 0;
                        end
                        
                        %d = sum(sum(renyi_dist(c1, t1, c2, t2, ga1, ga2)));
                        %estoc(i,j) = estoc(i,j)+d;
                        %w = 0;

                        %if (~isnan(d) && ~isinf(d))
                        %    w=exp(-d/h);            
                        %end

                        if w>wmax                
                            wmax=w;                   
                        end

                        sweight = sweight + w;
                        average = average + w*input2(r,s);                                  
                 end 
                 end  

                average = average + wmax*input2(i1,j1);
                sweight = sweight + wmax;  


                if sweight > 0
                    output(i,j) = average / sweight;
                else
                    output(i,j) = input(i,j);
                    %cont = cont+1; 
                    %fprintf('\nFiltro nao realizado aqui...%f - %f - cont %f',i,j,cont);
                end   

         end
     end
     fprintf('Calculo Nlm Encerrado.');
end
 