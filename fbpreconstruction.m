function [phantom_original_retro, phantom_original_ruidoso_retro,phantom_ruidoso_filtrado_retro] = fbpreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised,string_sinogram,path_reconstruction)
    fprintf('\n\nLivre de Ru?do via FBP... ');
    phantom_original_retro = retroprojecao(sinogram_reference);
    %imwrite(phantom_original_retro, strcat(path_reconstruction,string_sinogram{1},'_by_FBP_original','.png'));
    imwrite(phantom_original_retro, strcat(path_reconstruction,string_sinogram,'_by_FBP_original','.png'));

    fprintf('\nRuidosa Original via FBP... ');
    phantom_original_ruidoso_retro = retroprojecao(sinogram_noisy);
    imwrite(phantom_original_ruidoso_retro, strcat(path_reconstruction,string_sinogram,'_by_FBP_original_ruidosa','.png'));

    fprintf('\nRuidosa Filtrada via FBP... ');
    phantom_ruidoso_filtrado_retro = retroprojecao(sinogram_denoised);
    imwrite(phantom_ruidoso_filtrado_retro, strcat(path_reconstruction,string_sinogram,'_by_FBP_filtrada_ruidosa','.png'));
    fprintf('\n\nProcesso de Reconstrucao FBP Completo');
end