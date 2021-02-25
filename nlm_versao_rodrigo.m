function [output]=nlm_versao_rodrigo(input, t, f, h, alpha, betha)
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
     alpha = padarray(alpha,[f f],'symmetric');
     betha = padarray(betha,[f f],'symmetric');

     cont=0;
     % Size of the image
     [m n]=size(input);

     % Memory for the output
     output=zeros(m,n);

     % Replicate the boundaries of the input image
     input2 = padarray(input,[f f],'symmetric');
 
     % Used kernel Janela de similaridade
     %kernel = make_kernel(f);
     %kernel = kernel / sum(sum(kernel));
     %kernel = make_kernel(floor(f/2));
     %kernel = kernel / sum(sum(kernel));


     h=h*h;

     psimap  = zeros(size(alpha,1),size(alpha,2)); % mapa de psi(alpha)
     lgammap = zeros(size(alpha,1),size(alpha,2)); % mapa de log(gamma(alpha)
 
     [a b]=size(input2);
     for i=1:a
       for j=1:b
            psimap(i,j)  = psi(alpha(i,j));
            lgammap(i,j) = log(gamma(alpha(i,j)));      
        end
     end

     for i=1:m
         for j=1:n

                 i1 = i+ f;
                 j1 = j+ f;

                 %W1= input2(i1-f:i1+f , j1-f:j1+f);
                 a1= alpha(i1-f:i1+f, j1-f:j1+f);
                 b1= betha(i1-f:i1+f, j1-f:j1+f);
                 psi1= psimap(i1-f:i1+f, j1-f:j1+f);
                 lga1= lgammap(i1-f:i1+f, j1-f:j1+f);

                 wmax=0; 
                 average=0;
                 sweight=0;

                 %Janela de busca
                 %rmin = max(i1-t,f+1);
                 %rmax = min(i1+t,m+f);
                 %smin = max(j1-t,f+1);
                 %smax = min(j1+t,n+f);
                 rmin = max(i1-t,f+1);
                 rmax = min(i1+t,m+f);
                 smin = max(j1-t,f+1);
                 smax = min(j1+t,n+f);

                 for r=rmin:1:rmax
                 for s=smin:1:smax
                        if(r==i1 && s==j1) continue; end;

                        %W2= input2(r-f:r+f , s-f:s+f); 
                        a2= alpha(r-f:r+f, s-f:s+f);
                        b2= betha(r-f:r+f, s-f:s+f);
                        
                        psi2= psimap(r-f:r+f, s-f:s+f);
                        lga2= lgammap(r-f:r+f, s-f:s+f);

                        %d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                        %d = sum(sum(kernel.*(kldist(a1,b1,a2,b2))));
                        d = sum(sum(kldist_3(a1, b1, a2, b2, psi1, psi2, lga1, lga2)));

                        w = 0;

                        if (~isnan(d) && ~isinf(d))
                            w=exp(-d/h);            
                        end

                        if w>wmax                
                            wmax=w;                   
                        end

                        sweight = sweight + w;
                        average = average + w*input2(r,s);                                  
                 end 
                 end  

                average = average + wmax*input2(i1,j1);
                sweight = sweight + wmax;  

                if sweight > 0 && sweight <256 %%%%% 
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
 