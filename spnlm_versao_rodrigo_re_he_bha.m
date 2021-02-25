function [ u1 ] = spnlm_versao_rodrigo_re_he_bha(capa, teta, v, srch_r, sim_r, h, g, fdist, fweight)
                                          
%NLM
%   Implements the SP-NLM denoising algorithm
%
%PARAMETRES
%   u       : noise free image
%   v       : noisy image
%   srch_r  : search range
%   sim_r   : similarity range
%   h       : filtering parameters
%   g       : similarity kernel
%   fdist   : stochastic distance
%   fweight : weight function
%
%RETURNS
%   u1      : weighted means
%
%REFERENCES
%
%   [1] A. A. Bindilatti and N. D. A. Mascarenhas, ?A Nonlocal Poisson 
%       Denoising Algorithm Based on Stochastic Distances,? 
%       IEEE Signal Processing Letters, vol. 20, no. 11, pp. 1010?1013, 
%       Nov. 2013.
%
%   [2] Antoni Buades, Bartomeu Coll, Jean-Michel Morel. A review of image 
%       denoising algorithms, with a new one. SIAM Journal on Multiscale 
%       Modeling and Simulation: A SIAM Interdisciplinary Journal, 2005, 
%       4 (2), pp.490-530. <hal-00271141>
%
%   [3] L. Condat, ?A simple trick to speed up and improve the non-local 
%       means,? research report hal-00512801, Aug. 2010, Caen, France.
%       Unpublished.
%

% if fdist is not specified
%if ~exist('fdist','var')
%    fdist = @(a, b) (a - b).^2; % use euclidean distance
%end

% if fweight is not specified
if ~exist('fweight','var')
    fweight = @(d,h) exp(-d./h); % use nlm weight function
end

% if g is not specified
if ~exist('g','var')
    g = disk_kernel(sim_r);
end

gammap = gamma(capa);

% image size
[m, n] = size(v);
% output
u1 = zeros(m,n);
% pads noise free image 
c1_pad = padarray(capa, [srch_r srch_r], 'symmetric');
t1_pad = padarray(teta, [srch_r srch_r], 'symmetric');
ga1_pad = padarray(gammap, [srch_r srch_r], 'symmetric');

% pads noisy image 
v_pad = padarray(v, [srch_r srch_r], 'symmetric');
% max weight
w_max = zeros(m,n);
% weight sum
w_sum = zeros(m,n);
% squared h
h = h.*h;

% search window shifts
[X, Y] = meshgrid(-srch_r:srch_r, -srch_r:srch_r);
% search window size
N = (2*srch_r + 1)^2;

for i = 1:N
    
    if X(i) == 0 && Y(i) == 0
        continue; 
    end
    
    % shifted noise free image
    %ui = u_pad(srch_r + (1:m) + Y(i), srch_r + (1:n) + X(i));
    c2 = c1_pad(srch_r + (1:m) + Y(i), srch_r + (1:n) + X(i));
    t2 = t1_pad(srch_r + (1:m) + Y(i), srch_r + (1:n) + X(i));
    ga2= ga1_pad(srch_r + (1:m) + Y(i), srch_r + (1:n) + X(i));
    
    % shifted noisy image
    vi = v_pad(srch_r + (1:m) + Y(i), srch_r + (1:n) + X(i));
    % compute weighted euclidean distance
    d = imfilter(fdist(capa, teta, c2, t2, gammap, ga2), g, 'symmetric');
    
    %if(strcmp(string_dist,'renyi'))
    %   d = imfilter(renyi_dist(capa, teta, c2, t2, gammap, ga2), g, 'symmetric');
    %end
    %if(strcmp(string_dist,'hellinger'))
    %   d = imfilter(hellinger_dist(capa, teta, c2, t2, gammap, ga2), g, 'symmetric');
    %end
    %if(strcmp(string_dist,'bhattacharyya'))
    %   d = imfilter(bhattacharyya_dist(capa, teta, c2, t2, gammap, ga2), g, 'symmetric');
    %end
    
    % compute weights 
    w = fweight(d,h);
    % update weighted average
    u1 = u1 + w.*vi;
    % update max weight
    w_max = max(w_max, w);
    % update wieght sum
    w_sum = w_sum + w;
    
end

% avoid division by zero
w_max(w_max == 0) = 1;

% weight fix: max weight is assigned to the center samples
u1 = u1 + w_max.*v;

% add the weight contribution of the center pixels
w_sum = w_sum + w_max;

% normalize results
u1 = u1./w_sum;

end

