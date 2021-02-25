function     [phantom_original_pocs, phantom_original_ruidoso_pocs,phantom_ruidoso_filtrado_pocs] = pocsreconstruction(sinogram_reference,sinogram_noisy,sinogram_denoised,string_sinogram,path_reconstruction)    
    fprintf('\n\nLivre de Ru?do via POCS... ');
    phantom_original_pocs = pocs_paralelo(sinogram_reference);
    %imwrite(phantom_original_pocs, strcat(path_reconstruction,string_sinogram{1},'_by_POCS_original','.png'));
    imwrite(phantom_original_pocs, strcat(path_reconstruction,string_sinogram,'_by_POCS_original','.png'));

    fprintf('\nRuidosa Original via POCS... ');
    phantom_original_ruidoso_pocs = pocs_paralelo(sinogram_noisy);
    imwrite(phantom_original_ruidoso_pocs, strcat(path_reconstruction,string_sinogram,'_by_POCS_original_ruidosa','.png'));

    fprintf('\nRuidosa Filtrada via POCS... ');
    phantom_ruidoso_filtrado_pocs = pocs_paralelo(sinogram_denoised);
    imwrite(phantom_ruidoso_filtrado_pocs, strcat(path_reconstruction,string_sinogram,'_by_POCS_filtrada_ruidosa','.png'));
    fprintf('\n\nProcesso de Reconstrucao POCS Completo');

end