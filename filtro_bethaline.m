function filtro_bethaline = filtro_bethaline(betha, janela)

%calcula betha line
fprintf('\nCalculando Bethaline...');
bethaline = zeros(size(betha));
[lin, col] = size(betha);

for i = 1 : lin
    for j = 1 : col
        bethaline(i,j)=betha(i,j)+(janela^2);
    end
end
fprintf('Calculo do Bethaline encerrado.');

filtro_bethaline = bethaline; %Calculo Bethaline