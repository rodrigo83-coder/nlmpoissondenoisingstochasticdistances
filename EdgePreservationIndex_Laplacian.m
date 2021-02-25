%WAVELET SPECKLE REDUCTION FOR SAR IMAGERY BASED ON EDGE DETECTION
%Yingdan Wu A., Xiuxiao Yuan A.
function epi = EdgePreservationIndex_Laplacian(f, g) %f->despeckled, g-> reference

    narginchk(2,2);
    
    validateattributes(f,{'uint8', 'int8', 'uint16', 'int16', 'uint32', 'int32', ...
        'single','double'},{'nonsparse'},mfilename,'A',1);
    validateattributes(g,{'uint8', 'int8', 'uint16', 'int16', 'uint32', 'int32', ...
        'single','double'},{'nonsparse'},mfilename,'B',1);

    if ~isequal(size(f),size(g))
        error(message('images:validate:unequalSizeMatrices','A','B'));
    end

    if isempty(f) % If f is empty, g must also be empty
        error(message('empty images'));
    end

    if ~isa(f,'double')     
        f = double(f);
    end
    if ~isa(g,'double')  
        g = double(g);
    end
    
    f = normalize_0_1(f);
    g = normalize_0_1(g);    
    
    %Add pad to avoid border effects
    g = padarray(g,[3,3], 'symmetric');
    f = padarray(f,[3,3], 'symmetric');
    
    %Apply Laplacian
    H = fspecial('laplacian');
    delta_g = imfilter(g,H);%, 'replicate'); %used to be replicate
    delta_f = imfilter(f,H);%, 'replicate');
    
    %Remove borders
    [x,y] = size(delta_g);
    delta_g = delta_g(4:x-3,4:y-3);
    delta_f = delta_f(4:x-3,4:y-3);
    
    
    gdiff  = abs(delta_g-mean(delta_g(:))); %used to have an abs
    fdiff  = abs(delta_f-mean(delta_f(:))); %used to have an abs
    gdiff2 = gdiff.^2;
    fdiff2 = fdiff.^2;
    gxf    = gdiff.*fdiff;
    gxf2   = sum(gdiff2(:))*sum(fdiff2(:));
    sgxf   = sum(gxf(:));
    sgxf2  = sqrt(gxf2);
    
    if (sgxf ~= 0 && sgxf2 ~= 0)
       epi = sgxf/sgxf2;
    else
       epi = 0; 
    end
end