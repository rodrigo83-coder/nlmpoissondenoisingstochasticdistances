%path_sinogram = '/home/cid/OneDrive/Documentos/Matlab/Projeto_NLM_Rodrigo/sinograma/';
%path_reconstruction = '/home/cid/OneDrive/Documentos/Matlab/Projeto_NLM_Rodrigo/resultados/';
 
path_sinogram = 'sinograma/';
path_reconstruction = 'resultados/';

%string_sinogram = ['assimetrico50';'homogeneo80';'madeira1';'madeira2';'simetrico80 ';'shepplogan'];
string_sinogram = ['shepplogan'];
string_sinogram = cellstr(string_sinogram)'; % Como o Matlab n?o aceita vetor com strings de tamanhos diferentes, fa?o esse ajuste.

search_window_size = 5; %Janela de Busca
patch_size = 2; %Janela de Similaridade
sigma = 0.1; %h
janelamedia = 3; %Janela de suavizaï¿½ï¿½o
 
for i = 1:length(string_sinogram)
    if(strcmp(string_sinogram(i),'shepplogan'))
        fprintf('\nGerando imagens simuladas de Shepp-Logan...');
        %[sinogram_reference, sinogram_noisy] = gera_shepplogan(1);
        DATA = load('base_sinograma.mat');
        sinogram_reference = DATA.sinogram_reference;
        sinogram_noisy     = DATA.sinogram_noisy;

    else    
        fprintf('\nGerando imagens simuladas Gerais...');
        % Sinograma Referï¿½ncia (20s)
        sinogram_reference = open_file_proj(char(strcat(path_sinogram, string_sinogram(i), '_20s.dat')));

        % Sinograma Ruidoso (3s)
        sinogram_noisy = open_file_proj(char(strcat(path_sinogram, string_sinogram(i), '_3s.dat')));
    end
  
    T = tic; %Inicio da tempo
    
    %Filtro de Mï¿½dia
    filtradamedia = filtro_media(sinogram_noisy, janelamedia);
    
    %filtro de Variï¿½ncia
    filtradavar = filtro_variancia(sinogram_noisy, filtradamedia, janelamedia);
    
    %Cï¿½lculo Alpha
    alpha = filtro_alpha(filtradamedia, filtradavar);
    
    %Cï¿½lculo do AlphaLine
    alphaline = filtro_alphaline(alpha, sinogram_noisy, patch_size);
    
    %Cï¿½lculo do Betha
    betha = filtro_betha(filtradamedia, filtradavar);
    
    %Cï¿½lculo do Bethaline
    bethaline = filtro_bethaline(betha, patch_size); 
    
    %Normalizei parâmetros
    alphaline = alphaline/max(alphaline(:));
    bethaline = bethaline/max(bethaline(:));
    
    % Filtrar com Non-Local Means (sinogram, search_window, patch, sigma)
    sinogram_denoised = nlm_versao_rodrigo(sinogram_noisy, search_window_size, patch_size, sigma, alphaline, bethaline);
    %sinogram_denoised = nlmeans_rodrigo_Cv2(sinogram_noisy, alphaline, bethaline, search_window_size, patch_size, sigma);
    
    %sinogram_denoised = sinogram_noisy;
    
    [phantom_original_retro, phantom_original_ruidoso_retro,phantom_ruidoso_filtrado_retro] = fbpreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised, string_sinogram{1},path_reconstruction);
    phantom_original_retro = double(phantom_original_retro);
    phantom_original_ruidoso_retro = double(phantom_original_ruidoso_retro);
    phantom_ruidoso_filtrado_retro = double(phantom_ruidoso_filtrado_retro);
    
    psnr_result = psnr(phantom_original_ruidoso_retro,phantom_original_retro);
    ssim_result = ssim(phantom_original_ruidoso_retro,phantom_original_retro);
    epi2_result = EdgePreservationIndex_Laplacian(phantom_original_ruidoso_retro,phantom_original_retro);
    
    time = toc(T);
    name_sinogram = string_sinogram(i);
    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f; time: %f; h: %f; by FBP;',psnr_result, ssim_result, epi2_result, time, sigma); 
    psnr_result = psnr(phantom_ruidoso_filtrado_retro,phantom_original_retro);
    ssim_result = ssim(phantom_ruidoso_filtrado_retro,phantom_original_retro);
    epi2_result = EdgePreservationIndex_Laplacian(phantom_ruidoso_filtrado_retro,phantom_original_retro);
    time = toc(T);
    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by FBP;',psnr_result, ssim_result, epi2_result, time, sigma); 
    
    [phantom_original_pocs, phantom_original_ruidoso_pocs,phantom_ruidoso_filtrado_pocs] = pocsreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised,string_sinogram{1},path_reconstruction);
    phantom_original_pocs = double(phantom_original_pocs);
    phantom_original_ruidoso_pocs = double(phantom_original_ruidoso_pocs);
    phantom_ruidoso_filtrado_pocs = double(phantom_ruidoso_filtrado_pocs);    
    
    psnr_result = psnr(phantom_original_ruidoso_pocs,phantom_original_pocs);
    ssim_result = ssim(phantom_original_ruidoso_pocs,phantom_original_pocs);   
    epi2_result = EdgePreservationIndex_Laplacian(phantom_original_ruidoso_pocs,phantom_original_pocs);    
    
    time = toc(T);
    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',psnr_result, ssim_result, epi2_result, time, sigma); 
    psnr_result = psnr(phantom_ruidoso_filtrado_pocs,phantom_original_pocs);
    ssim_result = ssim(phantom_ruidoso_filtrado_pocs,phantom_original_pocs);
    epi2_result = EdgePreservationIndex_Laplacian(phantom_ruidoso_filtrado_pocs,phantom_original_pocs);    
    time = toc(T);
    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',psnr_result, ssim_result, epi2_result, time, sigma); 



    subplot(3,3,1);imshow(sinogram_reference,[]);title('Sin.Original');
    subplot(3,3,2);imshow(sinogram_noisy,[]);title('Sin.Ruidoso');
    subplot(3,3,3);imshow(sinogram_denoised,[]);title('Sin.Filtrado');
    subplot(3,3,4);imshow(phantom_original_retro,[]);title('Imagem Original FBP');
    subplot(3,3,5);imshow(phantom_original_ruidoso_retro,[]);title('Imagem Ruidosa FBP');
    subplot(3,3,6);imshow(phantom_ruidoso_filtrado_retro,[]);title('Imagem Filtrada FBP');
    subplot(3,3,7);imshow(phantom_original_pocs,[]);title('Imgagem Original POCS');
    subplot(3,3,8);imshow(phantom_original_ruidoso_pocs,[]);title('Imagem Ruidosa POCS');
    subplot(3,3,9);imshow(phantom_ruidoso_filtrado_pocs,[]);title('Imagem Filtrada POCS');
    
    
end

    % se n?o existe o respectivo phantom refer?ncia
    %if ~exist(char(strcat(path_reconstruction, string_sinogram(i), '_20s.img')))
        % reconstr?i o phantom atrav?s do seu sinograma (pocs paralelo)
        %%%phantom_reference = pocs_paralelo(sinogram_reference);
        % salva a imagem
        %%%save_img(phantom_reference, 'img', char(strcat(path_reconstruction, string_sinogram(i), '_20s.img')));
    %else
        % Carrega o phantom ja salvo para avaliaï¿½ï¿½o do psnr e ssim
        %%%phantom_reference = open_file_img(char(strcat(path_reconstruction, string_sinogram(i), '_20s.img')));
    %end
    
    
    %%% Outro cï¿½digo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        %Reconstru??o pocs paralelo
    %phantom_noisy = pocs_paralelo(sinogram_noisy);
    %phantom_estimated = pocs_paralelo(sinogram_estimated);
     
    % SSIM e PSNR
    %ssim_phantom1 = ssim(phantom_noisy,phantom_reference);
    %ssim_phantom2 = ssim(phantom_estimated,phantom_reference);
    %psnr_phantom1 = psnr(phantom_noisy,phantom_reference);
    %psnr_phantom2 = psnr(phantom_estimated,phantom_reference);
     
    % Salva as imagens
    %imwrite(phantom_reference, strcat('C:\Users\pinhe\Dropbox\Mestrado\Arthur_Melo_Pinheiro\Disserta??o\resultados\imagem reconstruida\nlm\',string_sinogram{i},'_referencia','.png'));
    %imwrite(phantom_noisy, strcat('C:\Users\pinhe\Dropbox\Mestrado\Arthur_Melo_Pinheiro\Disserta??o\resultados\imagem reconstruida\nlm\',string_sinogram{i},'_ruido','.png'));
    %imwrite(phantom_estimated, strcat('C:\Users\pinhe\Dropbox\Mestrado\Arthur_Melo_Pinheiro\Disserta??o\resultados\imagem reconstruida\nlm\',string_sinogram{i},'_estimado','.png'));
    %disp('---');

