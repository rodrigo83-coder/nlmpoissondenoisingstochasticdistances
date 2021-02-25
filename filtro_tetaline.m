function filtro_tetaline = filtro_tetaline(bethaline, patch_size)

%calcula betha line
fprintf('\nCálculando Tetaline...');
tetaline = zeros(size(bethaline));
patch = (patch_size+patch_size+1)^2;
[lin, col] = size(bethaline);

for i = 1 : lin
    for j = 1 : col
        tetaline(i,j)=1/(bethaline(i,j));
        tetaline(i,j)=tetaline(i,j)/((patch*tetaline(i,j))+1);
    end
end
fprintf('Cálculo do Tetaline encerrado.');

filtro_tetaline = tetaline;