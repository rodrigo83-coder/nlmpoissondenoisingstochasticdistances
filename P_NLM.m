function img_NLM = P_NLM(ima_nse, jan_busca, patch, h)
%NLM filtro Non Local Means no dom�nio das proje��es.
%   Essa fun��o aplica o filtro Non Local Means na imagem 'img' com uma
%   janela de busca de tamanho padr�o 11x11 e com patches de tamanho padr�o
%   3x3. O par�metro h � um estimador de suaviza��o da imagem. Quanto maior
%   o h, mais 'borrada' (mais suavizada) � a imagem.
%
% Em suma:
%
%  --> img: imagem a ser filtrada
%
%  --> densidade: Verossimilhan�a da imagem/proje��o (Essa fun��o trabalha
%  com as estat�sticas Gaussiana e Poisson)
%
%  --> jan_busca: n�mreo que indica o tamanho de uma janela quadrada de
%  busca (Ex: se jan_busca = 7, a janela de busca ser� 7x7)
%
%  --> patch: n�mero que indica o tamanho da janela quadrada do patch ao
%  redor de um pixel central (Ex: se patch = 5, o patch ao redor de um
%  pixel central ser� de tamanho 5x5)
%
%  --> h: grau de suaviza��o, grau de filtragem.

% Verifica��es iniciais

peso = .1; %constante peso %menor valor poss�vel: 0.05
densidade = 'poisson';

if nargin < 1
    error('Numero insuficiente de argumentos de entrada');
    pause
elseif nargin == 1
    jan_busca = 11;
    patch = 3;
    h = peso;
elseif nargin == 2
    patch = 3;
    h = peso;
elseif nargin == 3
    h = peso;
elseif nargin > 4
    error('Excedeu o numero de argumentos de entrada!');
    pause
end

%ima_nse = im2double(ima_nse);
ima_nse(ima_nse <= 0) = .00001;

[M N] = size(ima_nse); % ima_nse = imagem ruidosa. M=linhas, N=colunas
[cM cN] = fourier_center(M, N); %centro do patch (antes de FT)
patch_shape = zeros(M, N); %FT da forma do patch
[Y X] = meshgrid(1:M, 1:N); %cria uma matriz (mapa) para localizar as posi��es (�ndices)
patch_shape = (Y - cM).^2 + (X - cN).^2 <= patch.^2; %opera��o l�gica que delimita o formato do patch
patch_shape = patch_shape / sum(patch_shape(:)); %normaliza (a soma dos valores tem que valer)
patch_shape = conj(fft2(fftshift(patch_shape))); %complexo conjugado

% Declara��o da vari�vel img_NLM de retorno
img_NLM = zeros(M,N);
A = zeros(M,N); %numerador
B = zeros(M,N); %denominador % A e B s�o acumuladores

d = floor(jan_busca/2); %d = deslocamento
for i = -d: d
    for j = -d: d
        if i^2 + j^2 > d^2 || (i == 0 && j == 0)
            % C1: se o pixel n�o pertence � area de busca (para considerar uma �rea de busca circular)
            % C2: quando n�o precisa de uma mudan�a (compara o patch com ele mesmo -> � desnecess�rio)
            continue
        end
        %circshift --> para trocar as linhas da ima_nse
        deslocada = circshift(ima_nse, [i j]); %imagem deslocada
        diferenca = (ima_nse.*log(ima_nse))+(deslocada.*log(deslocada))-((ima_nse+deslocada).*log((ima_nse+deslocada)/2));
        w = exp((-real(ifft2(patch_shape'.*fft2(diferenca))/h))); %eq (10) do algoritmo da tese do denis
        A = A + w .* deslocada;
        B = B + w;
    end
end
% B(B == 0) = .00001;
img_NLM = A./B;
% M = max(img_NLM(:));
% m = min(img_NLM(:));
% img_NLM = ((img_NLM-m)/(M-m))*255;
end



