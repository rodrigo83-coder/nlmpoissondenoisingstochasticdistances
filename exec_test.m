function [] = exec_test(search_window_size, patch_size, sigma, janelamedia, string_dist, path_sinogram, path_reconstruction, string_sinogram)

%image processing algorithm. 
%Parameters: 
%search_window_size (search window)
%patch_size (similarity window)
%sigma
%janelamedia (media filter window size)
%string_dist (filter/algorithm)%
%path_sinogram (image address/folder for synograms and images)
%path_reconstruction (results folder)
%string_sinogram (synogram to be filtered)

    
    if(strcmp(string_sinogram(1),'shepplogan'))
        fprintf('\nGerando imagens simuladas de Shepp-Logan...');
        %[sinogram_reference, sinogram_noisy] = gera_shepplogan(1);
        DATA = load('base_sinogramas.mat');
        sinogram_reference = DATA.sinogram_reference80;
        sinogram_noisy     = DATA.sinogram_noisy80;        
        %subplot(1,2,1);imshow(sinogram_reference,[]);title('Sin.Original');
        %subplot(1,2,2);imshow(sinogram_noisy,[]);title('Sin.Ruidoso');
    else
        fprintf('\nGerando imagens simuladas Gerais...');
        % Reference Synogram (20s)
        sinogram_reference = open_file_proj(char(strcat(path_sinogram, string_sinogram, '_20s.dat')));
        % Noisy Synogram (3s)
        sinogram_noisy = open_file_proj(char(strcat(path_sinogram, string_sinogram, '_3s.dat')));
        %subplot(1,2,1);imshow(sinogram_reference,[]);title('Sin.Original');
        %subplot(1,2,2);imshow(sinogram_noisy,[]);title('Sin.Ruidoso');            
    end  
        
    T = tic; %start time
    
    if((strcmp(string_dist,'kleibler'))||(strcmp(string_dist,'renyi'))||(strcmp(string_dist,'hellinger'))||(strcmp(string_dist,'bhattacharyya')))
        %Media Filter
        filtradamedia = filtro_media(sinogram_noisy, janelamedia);
        %Variance Filter
        filtradavar = filtro_variancia(sinogram_noisy, filtradamedia, janelamedia);
        %Alpha Filter
        alpha = filtro_alpha(filtradamedia, filtradavar);
        %AlphaLine Filter
        alphaline = filtro_alphaline(alpha, sinogram_noisy, patch_size);
        %Betha Filter
        betha = filtro_betha(filtradamedia, filtradavar);
        %Bethaline Filter
        bethaline = filtro_bethaline(betha, patch_size);        
    end  
          
    if(strcmp(string_dist,'kleibler'))
        alphaline = alphaline/max(alphaline(:));
        bethaline = bethaline/max(bethaline(:));
        %sinogram_denoised = nlm_versao_rodrigo(sinogram_noisy, search_window_size, patch_size, sigma, alphaline, bethaline);
        g = disk_kernel(patch_size);
        sinogram_denoised = spnlm_versao_rodrigokl(alphaline, bethaline, sinogram_noisy, search_window_size, patch_size, sigma, g, @kldist_3);
        %sinogram_denoised = round(sinogram_denoised);   
    end
    if(strcmp(string_dist,'renyi'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        g = disk_kernel(patch_size);
        sinogram_denoised = spnlm_versao_rodrigo_re_he_bha(capaline, tetaline, sinogram_noisy, search_window_size, patch_size, sigma, g, @renyi_dist);                                                
        %sinogram_denoised = abs(sinogram_denoised);   
    end
    if(strcmp(string_dist,'hellinger'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        g = disk_kernel(patch_size);
        sinogram_denoised = spnlm_versao_rodrigo_re_he_bha(capaline, tetaline, sinogram_noisy, search_window_size, patch_size, sigma, g, @hellinger_dist);                                                
%sinogram_denoised = abs(sinogram_denoised);   
    end
    if(strcmp(string_dist,'bhattacharyya'))
        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
        capaline = capaline/max(capaline(:));
        tetaline = tetaline/max(tetaline(:));
        g = disk_kernel(patch_size);
        sinogram_denoised = spnlm_versao_rodrigo_re_he_bha(capaline, tetaline, sinogram_noisy, search_window_size, patch_size, sigma, g, @bhattacharyya_dist);                                                
        %sinogram_denoised = abs(sinogram_denoised);   
    end

    if(strcmp(string_dist,'at_bm3d'))
        sinogram_denoised = Poisson_denoising_Anscombe_exact_unbiased_inverse(sinogram_noisy, sinogram_reference);
    end
    if(strcmp(string_dist,'p_nlm'))
        sinogram_denoised = P_NLM(sinogram_noisy, search_window_size, patch_size,sigma);
    end
    if(strcmp(string_dist,'at_nlm'))
        transformada = Anscombe_forward(sinogram_noisy);
        sinogram_denoised = NLmeansfilter(transformada, search_window_size, patch_size, sigma);
        sinogram_denoised = Anscombe_inverse(sinogram_denoised);
    end
    if(strcmp(string_dist,'andre_kl'))
        sinogram_denoised = demoandre(sinogram_reference, sinogram_noisy, search_window_size, patch_size, sigma, string_dist );
    end
    if(strcmp(string_dist,'andre_re'))
        sinogram_denoised = demoandre(sinogram_reference, sinogram_noisy, search_window_size, patch_size, sigma, string_dist );
    end
    if(strcmp(string_dist,'andre_he'))
        sinogram_denoised = demoandre(sinogram_reference, sinogram_noisy, search_window_size, patch_size, sigma, string_dist );
    end
    if(strcmp(string_dist,'andre_ba'))
        sinogram_denoised = demoandre(sinogram_reference, sinogram_noisy, search_window_size, patch_size, sigma, string_dist );
    end
    if(strcmp(string_dist,'daniel_shannon'))
        sinogram_denoised = execute(sinogram_noisy, search_window_size, patch_size, sigma, janelamedia, 'shannon', string_dist);
    end
    if(strcmp(string_dist,'hirakawa_hmrso_syn'))
        sinogram_denoised = demo1_synthetic(sinogram_reference, sinogram_noisy, 'HMRSO');
    end
    if(strcmp(string_dist,'hirakawa_hmrso_real'))
        sinogram_denoised = demo2_real(sinogram_reference, sinogram_noisy, 'HMRSO');
    end
    if(strcmp(string_dist,'hirakawa_bmrso'))
        sinogram_denoised = demo1_synthetic(sinogram_reference, sinogram_noisy, 'BMRSO');
    end
    if(strcmp(string_dist,'hirakawa_umrso'))
        sinogram_denoised = demo1_synthetic(sinogram_reference, sinogram_noisy, 'UMRSO');
    end
    
    [fbp.phantom_original_retro, fbp.phantom_original_ruidoso_retro,fbp.phantom_ruidoso_filtrado_retro] = fbpreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised, string_sinogram{1},path_reconstruction);
    fbp.phantom_original_retro = double(fbp.phantom_original_retro);
    fbp.phantom_original_ruidoso_retro = double(fbp.phantom_original_ruidoso_retro);
    fbp.phantom_ruidoso_filtrado_retro = double(fbp.phantom_ruidoso_filtrado_retro);
    
    fbp.ruidoso.psnr_result = psnr(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    fbp.ruidoso.ssim_result = ssim(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    fbp.ruidoso.epi2_result = EdgePreservationIndex_Laplacian(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    
    %result = psnr(fbp.phantom_original_ruidoso_retro,fbp.phantom_original_retro);
    %fprintf('\nRuidoso:\npsnr: %f; ;',result); 
    %subplot(1,2,1);imshow(fbp.phantom_original_retro,[]);title('Sin.Original');
    %subplot(1,2,2);imshow(fbp.phantom_original_ruidoso_retro,[]);title('Sin.Ruidoso');

    
    time = toc(T);
    %name_sinogram = string_sinogram(1);
    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f; time: %f; h: %f; by FBP;',fbp.ruidoso.psnr_result, fbp.ruidoso.ssim_result, fbp.ruidoso.epi2_result, time, sigma); 
    fbp.filtrado.psnr_result = psnr(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    fbp.filtrado.ssim_result = ssim(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    fbp.filtrado.epi2_result = EdgePreservationIndex_Laplacian(fbp.phantom_ruidoso_filtrado_retro,fbp.phantom_original_retro);
    time = toc(T);
    fbp.time = time;
    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by FBP;',fbp.filtrado.psnr_result, fbp.filtrado.ssim_result, fbp.filtrado.epi2_result, time, sigma); 
    
%    [pocs.phantom_original_pocs, pocs.phantom_original_ruidoso_pocs, pocs.phantom_ruidoso_filtrado_pocs] = pocsreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised,string_sinogram{1},path_reconstruction);
%    pocs.phantom_original_pocs = double(pocs.phantom_original_pocs);
%    pocs.phantom_original_ruidoso_pocs = double(pocs.phantom_original_ruidoso_pocs);
%    pocs.phantom_ruidoso_filtrado_pocs = double(pocs.phantom_ruidoso_filtrado_pocs);    
    
%    pocs.ruidoso.psnr_result = psnr(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);
%    pocs.ruidoso.ssim_result = ssim(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);   
%    pocs.ruidoso.epi2_result = EdgePreservationIndex_Laplacian(pocs.phantom_original_ruidoso_pocs,pocs.phantom_original_pocs);    
    
%    time = toc(T);
%    fprintf('\nRuidoso:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',pocs.ruidoso.psnr_result, pocs.ruidoso.ssim_result, pocs.ruidoso.epi2_result, time, sigma); 
%    pocs.filtrado.psnr_result = psnr(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);
%    pocs.filtrado.ssim_result = ssim(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);
%    pocs.filtrado.epi2_result = EdgePreservationIndex_Laplacian(pocs.phantom_ruidoso_filtrado_pocs,pocs.phantom_original_pocs);    
    time = toc(T);
    pocs.time = time;
%    fprintf('\nFiltrado:\npsnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',pocs.filtrado.psnr_result, pocs.filtrado.ssim_result, pocs.filtrado.epi2_result, time, sigma); 
    
    sigma_str = strrep(num2str(sigma), '.', '');%Remove '.' Not to give problem in the file name
    %name = strcat('results-', string_sinogram{1},'-peak80-', string_dist{1},'-');
    name = strcat('results-', string_sinogram{1},'-', string_dist{1},'-');
    %out_file_name = strcat('results-', dist_str, '-', sin_str, '-', num2str(search_window_size), '-',num2str(patch_size), '-', sigma_str, '-', num2str(janelamedia), '.mat');
    out_file_name = strcat(name, num2str(search_window_size), '-',num2str(patch_size), '-', sigma_str, '-', num2str(janelamedia), '.mat');
    save(out_file_name, 'sinogram_reference', 'sinogram_noisy', 'sinogram_denoised', 'fbp', 'pocs','sigma');
end

    %sinograma_original = sinogram_reference;
    %sinograma_ruidoso = sinogram_noisy;
    %phantom_original_fbp = retroprojecao(sinogram_reference);
    %phantom_original_ruidoso_fbp = retroprojecao(sinogram_noisy);
    %phantom_original_pocs = pocs_paralelo(sinogram_reference);
    %phantom_original_ruidoso_pocs = pocs_paralelo(sinogram_noisy);
    
    %subplot(1,6,1);imshow(sinograma_original,[]);title('Sin.Original'); 
    %subplot(1,6,2);imshow(sinograma_ruidoso,[]);title('Sin.Original Ruidoso'); 
    %subplot(1,6,3);imshow(phantom_original_fbp,[]);title('Img.Original Fbp');
    %subplot(1,6,4);imshow(phantom_original_ruidoso_fbp,[]);title('Img.Ruidoso Fbp');
    %subplot(1,6,5);imshow(phantom_original_pocs,[]);title('Img.Original Pocs');
    %subplot(1,6,6);imshow(phantom_original_ruidoso_pocs,[]);title('Img.Ruidoso Pocs');
    
    
    %sinogram_shepplogan80 = DATA.sinogram_noisy80;
    %sinogram_shepplogan40 = DATA.sinogram_noisy40;
    %sinogram_shepplogan20 = DATA.sinogram_noisy20;
    %sinogram_assimetrico50 = open_file_proj('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/sinograma/assimetrico50_3s.dat');
    %sinogram_madeira2 = open_file_proj('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/sinograma/madeira2_3s.dat');
    %save('sinogramas_noisy', 'sinogram_shepplogan80','sinogram_shepplogan40','sinogram_shepplogan20', 'sinogram_assimetrico50', 'sinogram_madeira2');
    
    %DATA = load(sinogramas_noisy);
    %sinogram_shepplogan80 = DATA.sinogram_shepplogan80;
    %sinogram_shepplogan40 = DATA.sinogram_noisy40;
    %sinogram_shepplogan20 = DATA.sinogram_noisy20;
    %sinogram_assimetrico50 = DATA.sinogram_assimetrico50;
    %sinogram_madeira2 = DATA.sinogram_madeira2;
    
    %sinogram_reference = sinogram_reference/max(sinogram_reference(:));
    %sinogram_noisy = sinogram_noisy/max(sinogram_noisy(:));
    
    %savDir = 'aaa/';
    %if ~exist(savDir,'dir'); 
    %    mkdir(savDir); 
    %end;
    %imwrite(sinogram_noisy,[savDir,'assimetrico50.png'],'png');

    %sinogram_noisy = retroprojecao(sinogram_noisy);
    %sinogram_reference = retroprojecao(sinogram_reference);
    %resu = psnr(sinogram_noisy,sinogram_reference);
    %fprintf('\npsnr: %f;',resu); 
    
%    if(strcmp(string_dist,'kleibler'))
%        alphaline = alphaline/max(alphaline(:));
%        bethaline = bethaline/max(bethaline(:));
%        sinogram_denoised = nlm_versao_rodrigo(sinogram_noisy, search_window_size, patch_size, sigma, alphaline, bethaline);
%        %sinogram_denoised = round(sinogram_denoised);   
%    end
%    if(strcmp(string_dist,'renyi'))
%        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
%        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
%        capaline = capaline/max(capaline(:));
%        tetaline = tetaline/max(tetaline(:));
%        sinogram_denoised = nlm_versao_rodrigo_re(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
%        sinogram_denoised = abs(sinogram_denoised);   
%    end
%    if(strcmp(string_dist,'hellinger'))
%        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
%        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
%        capaline = capaline/max(capaline(:));
%        tetaline = tetaline/max(tetaline(:));
%        sinogram_denoised = nlm_versao_rodrigo_hellinger(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
%        sinogram_denoised = abs(sinogram_denoised);   
%    end
%    if(strcmp(string_dist,'bhattacharyya'))
%        capaline = alphaline;%Capaline Filter -> Capaline = alphaline
%        tetaline = filtro_tetaline(bethaline, patch_size);%Tetaline Filter
%        capaline = capaline/max(capaline(:));
%        tetaline = tetaline/max(tetaline(:));
%        sinogram_denoised = nlm_versao_rodrigo_battacharyya(sinogram_noisy, search_window_size, patch_size, sigma, capaline, tetaline);
%        sinogram_denoised = abs(sinogram_denoised);   
%    end



