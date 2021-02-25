function img = pocs_paralelo(Tomog)
% Algoritmo de reconstru????o: "POCS paralelo", desenvolvido por SALINA07
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Tomog = log( (max(max(Tomog)))./Tomog );
    Tomog = (max(max(Tomog)))./Tomog;
    img = pocsparalelo(Tomog);
    img = mat2gray(imrotate(img, -90));  
end

function z=pocsparalelo(Tomog)
    % calcula numero de linhas e colunas dos dados do tomografo
    [NrLinhas NrColunas]=size(Tomog); 
    RaioMedio=ceil(NrColunas/2)-2;
    % inicia os valores p/ imagem reconstru???da
    % a dimensao ?? dada pelo numero de colunas= nr de raios
    F(NrColunas*NrColunas)=0.0; 
    Faux=F;  %armazena o ultimo valor de F
    % vari??vel para verificar a converg??ncia
    ConvAux=0.0;
    %numero de iteracoes
    NrIteracoes=0;
    %size(F)
    %inicia os lambdas do suporte finito
    lamb = zeros(1,NrColunas*NrColunas);
    %lamb=suportefinito;
    for aux1=1:NrColunas,
        for aux2=1:NrLinhas,
            dist=norm([aux1;aux2]-[NrColunas/2;NrLinhas/2]);
            if(dist<RaioMedio)
                lamb((aux2-1)*NrColunas+aux1)=1.0;
            end
        end
    end
    % faz as projecoes nos conjuntos de restricoes
    Converge=0;
    while Converge==0
        %restri????es dos hiperplanos
        F=projetaSIRT(Tomog,F); 
        %restri????o de n??o negatividade
        F=F-F.*[F<0]; 
        %restri????o de suporte finito
        F=F.*lamb;
        NrIteracoes=NrIteracoes+1;
        fprintf('>> %d ',NrIteracoes);
        if NrIteracoes >=15
            Converge=1;
        end
    end
    %transforma F em imagem bidimensional
    linhas=NrColunas-1;
    z=F(1:NrColunas);
    for aux=1:linhas,
        z=[z;F((1+(aux*NrColunas)):(aux+1)*NrColunas)];
    end
end

function Fproj=projetaSIRT(Tomog,F)
% projeto hiperplano em paralelo
    [lin col]=size(Tomog);
    Fproj=zeros(1,col*lin);  
    angulo=0.0;
    PassoAngular=180.0/lin - 0.0001;
    for NrAngulo=1:lin,
        angulo=(NrAngulo-1)*PassoAngular;
        for raio=1:col,
            Mproj=  matrizprojecao(Tomog,F,angulo,raio);
            Fproj=Fproj+calcprojetor(Mproj,F,Tomog(NrAngulo,raio));
        end
    end
    Fproj=F+Fproj/lin;
end

function z=matrizprojecao(Tomog,F,angulo,raio)
    [NrLinhas NrColunas]=size(F);
    z(NrLinhas*NrColunas)=0.0; 
    [NrLinhas NrColunas]=size(Tomog);
    NormalizaC=sqrt(2)/2; %normaliza o maior valor para 1
    if angulo==90.0
        Vlr=ones(1,NrColunas);
        VlrLinha=[0:(NrColunas-1)]*NrColunas;
        aux=ones(1,NrColunas)*raio+VlrLinha;
        z(aux)=Vlr;
    else
        if angulo==0.0
            aux=ones(1,NrColunas);
            a=((raio-1)*NrColunas);
            z((a+1):(NrColunas+a))=aux(1:NrColunas);
        else
            angRad=(angulo*pi)/180;  %angulo em radianos
            % Matriz de rota????o do raio
            Rt=[cos(angRad) -sin(angRad) 0; sin(angRad) cos(angRad) 0; 0 0 1];
            T1=[1 0 -(NrColunas/2); 0 1 -(NrLinhas/2); 0 0 1];
            T2=[1 0 (NrColunas/2);  0 1 (NrLinhas/2);  0 0 1];
            T=T2*Rt*T1;
            coefAng=tan(angRad); %coeficiente angular
            P1=[0;(NrLinhas-raio);1]; %posi??????o do raio qdo. angulo ??? zero
            P1=T*P1;
            P1=P1(1:2);  %posi??????o do raio com uma rota??????o angular
            %calcula a interse??????o dos raios com a grade em X e Y
            Y=[0:NrColunas;coefAng*([0:NrColunas]-P1(1))+P1(2)];
            X=[([0:NrColunas]-P1(2))/coefAng+P1(1);0:NrColunas];
            %faz o clipping de X e Y
            X=X(:,find(X(1,:)>=0 & X(1,:)<=NrColunas));
            Y=Y(:,find(Y(2,:)>=0 & Y(2,:)<=NrColunas));
            %une as interse??????es em X e Y colocando em ordem crescente (eixo X)
            Pt=sortrows([X,Y]')';
            tam=size(Pt);
            %elimina os pontos que est???o em duplicidade
            Pt=[Pt,Pt(:,tam(2))];
            tam=size(Pt);
            aux=Pt(:,1:(tam(2)-1))-Pt(:,2:tam(2));
            Pt=Pt(:,find(aux(1,:)~=0.0));
            tam=size(Pt);
            %calcula a distancia entre os pontos
            aux=Pt(:,1:(tam(2)-1))-Pt(:,2:tam(2));
            Vlr= sqrt(aux(1,:).^2+aux(2,:).^2)/NormalizaC;
            Pt=floor((Pt(:,1:(tam(2)-1))+Pt(:,2:tam(2)))/2);
            tam=size(Pt);
            %faz o mapeamento de coordenadas xy p/ ij   tam=size(Pt);
            aux=ones(tam);
            aux(1,:)=aux(1,:)*NrColunas;
            aux(2,:)=aux(2,:)*NrColunas;
            Pt=aux-Pt;
            %transforma a matriz em vetor
            aux=ones(tam);
            VlrLinha = Pt(1,:) + (Pt(2,:) - ones(1,tam(2))) * NrColunas;
            z(VlrLinha)=Vlr;
        end
    end
end

function P=calcprojetor(Mproj,F,T)
% Esta Rotina Calcula o Projetor a ser aplicado na imagem
% MProj 'e a contribuicao do raios em F e T eh o grau de atenuacao
    P=(T-dot(Mproj,F))/norm(Mproj)^2;
    P=P*Mproj;
end