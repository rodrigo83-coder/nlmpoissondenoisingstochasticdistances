function [] = read_results(in_dir, string_dist, string_sinogram)
%Parameters: 
%Result address
%Filter algorithm
%synogram
%This algorithm must be configured according to the reading needs.

    %filename = strcat('results-',string_sinogram{1},'-peak20-', string_dist{1},'-6-2','*.mat');
    %filename = strcat('results-',string_sinogram{1},'-','*.mat');
    filename = strcat('results-',string_sinogram{1},'-peak40-',string_dist{1},'-','*.mat');
    %filename = strcat('results-',string_sinogram{1},'-',string_dist{1},'-','*.mat');
    %results-shepplogan-peak80-renyi-6-5-01-3
    %fprintf('\nNome: %s;',filename); 
    Files=dir(strcat(in_dir, filename));
    %Files=dir(strcat(in_dir, 'results-*.mat'));
    psnrfbp=0;psnrpocs=0;ssimpocs=0;ssimfbp=0;
    
    %fbp_psnr_r = [];
    %fbp_psnr_f = [];
    %fbp_ssim_r = [];
    %fbp_ssim_f = [];
    
    %pocs_psnr_r = [];
    %pocs_psnr_f = [];
    %pocs_ssim_r = [];
    %pocs_ssim_f = [];
    
    %f     = [];
    %t     = [];
    %sigma = [];
    
    for k=1:length(Files)
        fname = strcat(in_dir, Files(k).name);
        fprintf('\n******* PROCESSING <%s> \n', Files(k).name);
        DATA = load(fname); 
        
        if (    ~isfield(DATA, 'fbp') || ~isfield(DATA, 'pocs') || ~isfield(DATA, 'sinogram_denoised') ||...
                ~isfield(DATA, 'sinogram_noisy')|| ~isfield(DATA, 'sinogram_reference'))
            error('Arquivo n??o parece v??lido');
        end
        
        fbp  = DATA.fbp;
        pocs = DATA.pocs;
        sin = DATA;
        
        fprintf('** FBP **');        
        fprintf('\nRuidoso: psnr: %f; ssim: %f; time: %f; h: %f; by FBP;',fbp.ruidoso.psnr_result, fbp.ruidoso.ssim_result, fbp.time, DATA.sigma); 
        fprintf('\nFiltrado: psnr: %f; ssim: %f; time: %f; h: %f; by FBP\n;',fbp.filtrado.psnr_result, fbp.filtrado.ssim_result, fbp.time, DATA.sigma); 
        %fprintf('** POCS **'); 
        %fprintf('\nRuidoso: psnr: %f; ssim: %f; time: %f; h: %f; by POCS;',pocs.ruidoso.psnr_result, pocs.ruidoso.ssim_result, pocs.time, DATA.sigma); 
        %fprintf('\nFiltrado: psnr: %f; ssim: %f; time: %f; h: %f; by POCS;\n',pocs.filtrado.psnr_result, pocs.filtrado.ssim_result, pocs.time, DATA.sigma); 

        %fprintf('** FBP **');        
        %fprintf('\nRuidoso: psnr: %f; ssim: %f; epi2: %f; time: %f; h: %f; by FBP;',fbp.ruidoso.psnr_result, fbp.ruidoso.ssim_result, fbp.ruidoso.epi2_result, fbp.time, DATA.sigma); 
        %fprintf('\nFiltrado: psnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by FBP;\n\n',fbp.filtrado.psnr_result, fbp.filtrado.ssim_result, fbp.filtrado.epi2_result, fbp.time, DATA.sigma); 
        %fprintf('** POCS **'); 
        %fprintf('\nRuidoso: psnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;',pocs.ruidoso.psnr_result, pocs.ruidoso.ssim_result, pocs.ruidoso.epi2_result, fbp.time, DATA.sigma); 
        %fprintf('\nFiltrado: psnr: %f; ssim: %f; epi2: %f, time: %f; h: %f; by POCS;\n',pocs.filtrado.psnr_result, pocs.filtrado.ssim_result, pocs.filtrado.epi2_result, fbp.time, DATA.sigma); 
        
        %fprintf('%.2f\n',fbp.filtrado.psnr_result);
        %fprintf('%.2f\n',fbp.filtrado.ssim_result);        
        %fprintf('%.2f\n',pocs.filtrado.psnr_result);
        %fprintf('%.2f\n',pocs.filtrado.ssim_result);        

        %psnrpocs = max(psnrpocs,pocs.filtrado.psnr_result);
        psnrfbp = max(psnrfbp,fbp.filtrado.psnr_result);
        %ssimpocs = max(ssimpocs,pocs.filtrado.ssim_result);
        ssimfbp = max(ssimfbp,fbp.filtrado.ssim_result);
        
        subplot(3,3,1);imshow(sin.sinogram_reference,[]);title('Sin.Original');
        subplot(3,3,2);imshow(sin.sinogram_noisy,[]);title('Sin.Ruidoso');
        subplot(3,3,3);imshow(sin.sinogram_denoised,[]);title('Sin.Filtrado');
        subplot(3,3,4);imshow(fbp.phantom_original_retro,[]);title('Imagem Original FBP');
        subplot(3,3,5);imshow(fbp.phantom_original_ruidoso_retro,[]);title('Imagem Ruidosa FBP');
        subplot(3,3,6);imshow(fbp.phantom_ruidoso_filtrado_retro,[]);title('Imagem Filtrada FBP');
        %subplot(3,3,7);imshow(pocs.phantom_original_pocs,[]);title('Imgagem Original POCS');
        %subplot(3,3,8);imshow(pocs.phantom_original_ruidoso_pocs,[]);title('Imagem Ruidosa POCS');
        %subplot(3,3,9);imshow(pocs.phantom_ruidoso_filtrado_pocs,[]);title('Imagem Filtrada POCS');

        %subplot(1,4,1);imshow(fbp.phantom_original_retro,[]);title('Sin.Original FBP');xlabel('(a)');
        %subplot(1,4,2);imshow(fbp.phantom_original_ruidoso_retro,[]);title('Sin.Ruidoso FBP');xlabel('(b)');
        %subplot(1,4,3);imshow(pocs.phantom_original_pocs,[]);title('Sin.Original POCS');xlabel('(c)');
        %subplot(1,4,4);imshow(pocs.phantom_original_ruidoso_pocs,[]);title('Sin.Ruidoso POCS');xlabel('(d)');

        
        %fbp_psnr_r = [fbp_psnr_r, fbp.ruidoso.psnr_result];
        %fbp_psnr_f = [fbp_psnr_f, fbp.filtrado.psnr_result];
        %fbp_ssim_r = [fbp_ssim_r, fbp.ruidoso.ssim_result];
        %fbp_ssim_f = [fbp_ssim_f, fbp.filtrado.ssim_result];

        %pocs_psnr_r = [pocs_psnr_r, pocs.ruidoso.psnr_result];
        %pocs_psnr_f = [pocs_psnr_f, pocs.filtrado.psnr_result];
        %pocs_ssim_r = [pocs_ssim_r, pocs.ruidoso.ssim_result];
        %pocs_ssim_f = [pocs_ssim_f, pocs.filtrado.ssim_result];  
        
        %f     = [f, DATA.patch_size];
        %t     = [t, DATA.search_window_size];
        %sigma = [sigma, DATA.sigma];
    end
    fprintf('\nResultados \nPsnr FBP: %f  \nSsim FBP: %f; \n ------',psnrfbp, ssimfbp); 
    
    fprintf('\nMaior Psnr FBP: %f - Maior Ssim FBP: %f;',psnrfbp, ssimfbp); 
    %fprintf('\nMaior Psnr Pocs: %f - Maior Ssim Pocs: %f;\n',psnrpocs, ssimpocs); 
    
    
    %figure(1);
    %plot(fbp_psnr_r, sigma); hold on;
    %plot(fbp_psnr_f, sigma); hold off;
    %title('FBP-PSNR');legend('ruidoso','filtrado');
    
    %figure(2);
    %plot(fbp_ssim_r, sigma); hold on;
    %plot(fbp_ssim_f, sigma); hold off;
    %title('FBP-SSIM');legend('ruidoso','filtrado');
    
    %figure(3);
    %plot(pocs_psnr_r, sigma); hold on;
    %plot(pocs_psnr_f, sigma); hold off;
    %title('POCS-PSNR');legend('ruidoso','filtrado');
    
    %figure(4);
    %plot(pocs_ssim_r, sigma); hold on;
    %plot(pocs_ssim_f, sigma); hold off;
    %title('POCS-SSIM');legend('ruidoso','filtrado');
end