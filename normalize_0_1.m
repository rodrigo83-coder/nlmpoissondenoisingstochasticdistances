%Returns double, normalized from 0 to 1, if necessary
function [outImg] = normalize_0_1(inImg)
    
    if(ndims(inImg) > 2) %#ok<ISMAT>
        error('Not a bidimentional matrix!!!');
    end
    
    %if (~isa(inImg,'double'))% || ~(min(min(inImg)) >= 0) || ~(max(max(inImg)) <= 1))
        inImg = double(inImg);
        minval = double(min(min(inImg)));
        maxval = double(max(max(inImg)));
        
        if (minval ~= maxval)
            outImg = double(1.0*(inImg-minval)/(maxval-minval));
        else
            [m,n] = size(inImg);
            outImg = (minval/255)*ones(m,n);
            maxval = double(max(max(outImg)));
            if (maxval > 1)
                outImg = outImg./maxval;
            end
        end
    %else
    %    %nothing to do if already double between 0 and one
    %    outImg=inImg;
    %end

end
