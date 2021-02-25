function sinogram = open_file_proj(path)
    % Abrir arquivo das projeções para leitura.
    file_sinogram = fopen(path,'r');
    
    % Forma o sinograma (matriz de projeções).
    line = fgets(file_sinogram);
    proj = 0;
    while line ~= -1, 
       if line(1) ~= '#',
          line_num = str2num(line);
          if proj == 0
             proj = line_num;
          else
             proj = [proj;line_num];
          end
       end
       line=fgets(file_sinogram);
    end 
    
    fclose(file_sinogram);
    
    sinogram = double(proj);
end
