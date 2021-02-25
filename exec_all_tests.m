%Rodrigo C?sar Evangelista
%rodrigo.evangelista@muz.ifsuldeminas.edu.br
clear;
clc;

%choose image for processing
string_sinogram = {'madeira2'}; 
%or
%string_sinogram = {'shepplogan';'homogeneo80';'simetrico80';'assimetrico50';'madeira1';'madeira2'};

%choose algorithm filter for execution
string_dist = {'andre_kl'};
%{'kleibler';'renyi';'hellinger';'bhattacharyya','at_bm3d','p_nlm','at_nlm','andre_kl','andre_re','andre_he','andre_ba','daniel_shannon','hirakawa_hmrso_syn',hirakawa_hmrso_real','hirakawa_bmrso','hirakawa_umrso'};
%algorithms of this work {'kleibler';'renyi';'hellinger';'bhattacharyya'}
%other work algorithms {'at_bm3d','p_nlm','at_nlm','andre_kl','andre_re','andre_he','andre_ba','daniel_shannon','hirakawa_hmrso','hirakawa_bmrso','hirakawa_umrso'}

%search folder for synograms and images
path_sinogram = '/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/sinograma/';

%results folder
path_reconstruction = '/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/resultados/';


for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        exec_test(3, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end

read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/', string_dist(1), string_sinogram(1));


for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        exec_test(2, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 5, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end

%Processar C?digos Andre
for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        exec_test(3, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(3, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(4, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(5, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 2, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 4, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
        exec_test(6, 5, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end











exec_test(2, 1, 0.1, 3, string_dist(1), path_sinogram, path_reconstruction, string_sinogram(1));
read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/', string_dist(1), string_sinogram(1));

for s=1:length(string_sinogram)
  for d=1:length(string_dist)
        exec_test(2, 1, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end

%Below are separate codes for reading results and processing images / phantoms.












%result reading algorithm. Parameters: Result address, filter algorithm and synogram.
for d=1:length(string_dist)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/', string_dist(d), string_sinogram);
end 


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
for s=1:length(string_sinogram)
  for d=1:length(string_dist)
    exec_test(6, 3, 0.1, 3, string_dist(d), path_sinogram, path_reconstruction, string_sinogram(s));
  end
end


%Below are some detailed execution examples
for d=1:length(string_dist)
    read_results('/Users/rodrigo/Documents/MATLAB/Projeto_NLM_Rodrigo_Completo_Final/', string_dist(d), string_sinogram);
end 



Peak 20 Ruidoso 13.20
PSNR 22.80 results-shepplogan-peak20-andre_kl-5-3-01-3.mat  T5
PSNR 23.50 results-shepplogan-peak20-andre_re-5-3-01-3.mat  T11
PSNR 21.04 results-shepplogan-peak20-andre_he-5-3-01-3.mat  T6
PSNR 20.62 results-shepplogan-peak20-andre_ba-5-3-01-3.mat  T5
PSNR 13.24 results-shepplogan-peak20-daniel_shannon-5-3-01-3.mat  T69
PSNR 12.89 results-shepplogan-peak20-at_nlm-5-3-01-3.mat  T11
PSNR 15.30 results-shepplogan-peak20-p_nlm-5-3-01-3.mat  T1
PSNR 24.11 results-shepplogan-peak20-hirakawa_umrso-2-1-01-3.mat  T7
PSNR 14.03 results-shepplogan-peak20-hirakawa_bmrso-2-1-01-3.mat T7
PSNR 15.19 results-shepplogan-peak20-hirakawa_hmrso-2-1-01-3.mat  T7
PSNR 27.58 results-shepplogan-peak20-at_bm3d-2-1-01-3.mat  T1
PSNR 17.57 results-shepplogan-peak20-kleibler-6-5-01-3.mat  T3  
PSNR 19.50 results-shepplogan-peak20-renyi-6-5-01-3.mat  T4
PSNR 17.49 results-shepplogan-peak20-hellinger-5-2-01-3.mat  T3 
PSNR 17.46 results-shepplogan-peak20-bhattacharyya-5-2-01-3.mat  T3


Peak 40 Ruidoso 13.74
PSNR 24.29 results-shepplogan-peak40-andre_kl-5-3-01-3.mat  T6
PSNR 25.40 results-shepplogan-peak40-andre_re-5-3-01-3.mat  T17
PSNR 26.27 results-shepplogan-peak40-andre_he-5-3-01-3.mat  T6
PSNR 23.61 results-shepplogan-peak40-andre_ba-5-3-01-3.mat  T6
PSNR 14.88 results-shepplogan-peak40-daniel_shannon-5-3-01-3.mat  T72
PSNR 13.94 results-shepplogan-peak40-at_nlm-5-3-01-3.mat  T13
PSNR 17.13 results-shepplogan-peak40-p_nlm-5-3-01-3.mat  T1
PSNR 25.19 results-shepplogan-peak40-hirakawa_umrso-2-1-01-3.mat  T14
PSNR 16.31 results-shepplogan-peak40-hirakawa_bmrso-2-1-01-3.mat  T17
PSNR 25.19 results-shepplogan-peak40-hirakawa_hmrso-2-1-01-3.mat  T16
PSNR 26.08 results-shepplogan-peak40-at_bm3d-2-1-01-3.mat  T2
PSNR 22.77 results-shepplogan-peak40-kleibler-6-5-01-3.mat T3
PSNR 22.70 results-shepplogan-peak40-renyi-5-3-01-3.mat  T3
PSNR 21.21 results-shepplogan-peak40-hellinger-5-3-01-3.mat  T3
PSNR 21.15 results-shepplogan-peak40-bhattacharyya-5-3-01-3.mat  T3


Peak 80 Ruidoso 13.82
PSNR 22.85 results-shepplogan-peak80-andre_kl-5-3-01-3.mat  T6
PSNR 23.27 results-shepplogan-peak80-andre_re-5-3-01-3.mat  T13
PSNR 22.22 results-shepplogan-peak80-andre_he-5-3-01-3.mat  T6
PSNR 23.22 results-shepplogan-peak80-andre_ba-5-3-01-3.mat  T5
PSNR 15.91 results-shepplogan-peak80-daniel_shannon-5-3-01-3.mat  T66
PSNR 13.97 results-shepplogan-peak80-at_nlm-5-3-01-3.mat  T9
PSNR 23.44 results-shepplogan-peak80-at_bm3d-2-1-01-3.mat  T1
PSNR 20.01 results-shepplogan-peak80-p_nlm-5-3-01-3.mat  T1
PSNR 24.97 results-shepplogan-peak80-hirakawa_umrso-2-1-01-3.mat  T33
PSNR 18.11 results-shepplogan-peak80-hirakawa_bmrso-2-1-01-3.mat  T33
PSNR 24.97 results-shepplogan-peak80-hirakawa_hmrso-2-1-01-3.mat  T36
PSNR 23.44 results-shepplogan-peak80-at_bm3d-2-1-01-3.mat  T1
PSNR 24.77 results-shepplogan-peak80-kleibler-6-5-01-3.mat  T3
PSNR 22.80 results-shepplogan-peak80-renyi-4-3-01-3.mat  T3
PSNR 21.21 results-shepplogan-peak80-hellinger-4-2-01-3.mat  T3
PSNR 21.28 results-shepplogan-peak80-bhattacharyya-4-2-01-3.mat  T3


Peak20 Ruidoso 0.17
SSIM 0.75 results-shepplogan-peak20-andre_kl-5-3-01-3.mat  T5
SSIM 0.76 results-shepplogan-peak20-andre_re-5-3-01-3.mat  T11
SSIM 0.70 results-shepplogan-peak20-andre_he-5-3-01-3.mat  T6
SSIM 0.69 results-shepplogan-peak20-andre_ba-5-3-01-3.mat  T5
SSIM 0.27 results-shepplogan-peak20-daniel_shannon-5-3-01-3.mat  T69
SSIM 0.20 results-shepplogan-peak20-at_nlm-5-3-01-3.mat  T11
SSIM 0.35 results-shepplogan-peak20-p_nlm-5-3-01-3.mat  T1
SSIM 0.77 results-shepplogan-peak20-hirakawa_umrso-2-1-01-3.mat  T7
SSIM 0.28 results-shepplogan-peak20-hirakawa_bmrso-2-1-01-3.mat  T7
SSIM 0.34 results-shepplogan-peak20-hirakawa_hmrso-2-1-01-3.mat  T7
SSIM 0.84 results-shepplogan-peak20-at_bm3d-2-1-01-3.mat  T1
SSIM 0.52 results-shepplogan-peak20-kleibler-6-5-01-3.mat T3
SSIM 0.60 results-shepplogan-peak20-renyi-6-5-01-3.mat T4
SSIM 0.53 results-shepplogan-peak20-hellinger-6-4-01-3.mat T4
SSIM 0.53 results-shepplogan-peak20-bhattacharyya-6-4-01-3.mat  T4


Peak 40 Ruidoso 0.23
SSIM 0.79 results-shepplogan-peak40-andre_kl-5-3-01-3.mat  T6
SSIM 0.82 results-shepplogan-peak40-andre_re-5-3-01-3.mat  T17
SSIM 0.83 results-shepplogan-peak40-andre_he-5-3-01-3.mat  T6
SSIM 0.77 results-shepplogan-peak40-andre_ba-5-3-01-3.mat  T6
SSIM 0.36 results-shepplogan-peak40-daniel_shannon-5-3-01-3.mat  T72
SSIM 0.27 results-shepplogan-peak40-at_nlm-5-3-01-3.mat  T13
SSIM 0.44 results-shepplogan-peak40-p_nlm-5-3-01-3.mat  T1
SSIM 0.81 results-shepplogan-peak40-hirakawa_umrso-2-1-01-3.mat  T15
SSIM 0.30 results-shepplogan-peak40-hirakawa_bmrso-2-1-01-3.mat  T17
SSIM 0.81 results-shepplogan-peak40-hirakawa_hmrso-2-1-01-3.mat  T16
SSIM 0.86 results-shepplogan-peak40-at_bm3d-2-1-01-3.mat  T2
SSIM 0.68 results-shepplogan-peak40-kleibler-6-5-01-3.mat  T3
SSIM 0.72 results-shepplogan-peak40-renyi-6-5-01-3.mat  T4
SSIM 0.64 results-shepplogan-peak40-hellinger-5-3-01-3.mat  T3
SSIM 0.64 results-shepplogan-peak40-bhattacharyya-6-4-01-3.mat  T4


Peak 80 Ruidoso 0.30
SSIM 0.76 results-shepplogan-peak80-andre_kl-5-3-01-3.mat  T6
SSIM 0.77 results-shepplogan-peak80-andre_re-5-3-01-3.mat  T13
SSIM 0.75 results-shepplogan-peak80-andre_he-5-3-01-3.mat  T6
SSIM 0.78 results-shepplogan-peak80-andre_ba-5-3-01-3.mat  T5
SSIM 0.44 results-shepplogan-peak80-daniel_shannon-5-3-01-3.mat  T66
SSIM 0.34 results-shepplogan-peak80-at_nlm-5-3-01-3.mat  T9
SSIM 0.86 results-shepplogan-peak80-at_bm3d-2-1-01-3.mat  T1
SSIM 0.55 results-shepplogan-peak80-p_nlm-5-3-01-3.mat  T1
SSIM 0.82 results-shepplogan-peak80-hirakawa_umrso-2-1-01-3.mat  T33
SSIM 0.36 results-shepplogan-peak80-hirakawa_bmrso-2-1-01-3.mat  T33
SSIM 0.82 results-shepplogan-peak80-hirakawa_hmrso-2-1-01-3.mat  T36
SSIM 0.86 results-shepplogan-peak80-at_bm3d-2-1-01-3.mat  T1
SSIM 0.79 results-shepplogan-peak80-kleibler-6-5-01-3.mat  T3
SSIM 0.75 results-shepplogan-peak80-renyi-6-4-01-3.mat  T4
SSIM 0.70 results-shepplogan-peak80-hellinger-6-3-01-3.mat  T4
SSIM 0.70 results-shepplogan-peak80-bhattacharyya-6-3-01-3.mat T4


ASSIMETRICO
PSNR 18.84 results-assimetrico50-daniel_shannon-5-3-01-3.mat  T9
PSNR 19.63 results-assimetrico50-hirakawa_hmrso-5-3-01-3.mat  T100
PSNR 10.22 results-assimetrico50-hirakawa_bmrso-5-3-01-3.mat  T84
PSNR 19.63 results-assimetrico50-hirakawa_umrso-5-3-01-3.mat  T92
PSNR 20.40 results-assimetrico50-kleibler-3-2-01-3.mat  T1
PSNR 19.87 results-assimetrico50-renyi-3-2-01-3.mat   T1
PSNR 19.89 results-assimetrico50-hellinger-2-1-01-3.mat T1
PSNR 19.87 results-assimetrico50-bhattacharyya-2-1-01-3.mat  T1

SSIM 0.51 results-assimetrico50-daniel_shannon-5-3-01-3.mat  T9
SSIM 0.55 results-assimetrico50-hirakawa_hmrso-5-3-01-3.mat  T99
SSIM 0.16 results-assimetrico50-hirakawa_bmrso-5-3-01-3.mat  T99
SSIM 0.55 results-assimetrico50-hirakawa_umrso-5-3-01-3.mat  T92
SSIM 0.66 results-assimetrico50-kleibler-3-2-01-3.mat        T1
SSIM 0.65 results-assimetrico50-renyi-3-2-01-3.mat           T1
SSIM 0.64 results-assimetrico50-hellinger-2-1-01-3.mat       T1
SSIM 0.64 results-assimetrico50-bhattacharyya-2-1-01-3.mat  T1

Madeira
PSNR 29.70 results-madeira2-daniel_shannon-5-3-01-3.mat  T19
PSNR 21.27 results-madeira2-kleibler-2-1-01-3.mat     T1
PSNR 22.30 results-madeira2-renyi-2-1-01-3.mat        T1
PSNR 22.49 results-madeira2-hellinger-2-1-01-3.mat    T1
PSNR 22.55 results-madeira2-bhattacharyya-2-1-01-3.mat T1

SSIM 0.89 results-madeira2-daniel_shannon-5-3-01-3.mat T19
SSIM 0.58 results-madeira2-kleibler-2-1-01-3.mat       T1
SSIM 0.60 results-madeira2-renyi-2-1-01-3.mat          T1
SSIM 0.61 results-madeira2-hellinger-2-1-01-3.mat      T1
SSIM 0.61 results-madeira2-bhattacharyya-2-1-01-3.mat  T1

