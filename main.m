close all;
%% SIMO (Single Input Multiple Output) 
% Paramters
%-------------------------------
% For M = 64 ---> N_bits = 3504 
% For M = 16 ---> N_bits = 2336 
%-------------------------------
N_bits = 3504; 
M = 64;
fft_size = 1024;
frames_num = 5;
ofdm_synbols_per_frame = 5;
channel_type = "Multipath";

Eb_No = -20:3:20;
Eb = 2*(M-1)/(3*log2(M));
No_vect = Eb./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));

for i = 1:length(Eb_No)
  Pe_avg_frames_per_frame = 0;
  
  for k = 1:frames_num
    
    if channel_type == "Multipath"
        L = 50;
        h1 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
        h2 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
    elseif channel_type == "AWGN"
        L = 1;
        h1 = 1;
        h2 = 1;
    end
    
    count_err_per_ofdm_symbol = 0;
    count_err_per_frame = 0;
    for j = 1:ofdm_synbols_per_frame
        % Generate seq
        x = randi([0 1],1,N_bits);
        
        % Tx (Channel encoding, QAM modulation, OFDM)
        [y_Tx1, y_Tx2, x_QAM_modulated] = Tx(x, M, N_bits, L, No_vect(i), h1, h2, fft_size);
        
        % Rx (OFDM, QAM demodulation, Channel decoding)
        [x_Rx, x_before_demodulation] = Rx(M, L, y_Tx1, y_Tx2, x_QAM_modulated, h1, h2, fft_size);
        
        % Calc BER
        count_err_per_ofdm_symbol = biterr(x,x_Rx);

        % Average BER per run
        count_err_per_frame = count_err_per_frame + count_err_per_ofdm_symbol;
        
    end
    
    Pe_avg_frames_per_frame = Pe_avg_frames_per_frame + count_err_per_frame/(N_bits*ofdm_synbols_per_frame);
  end

  Pe_vect(i) = Pe_avg_frames_per_frame;

  % Plot the constellation diagram for each SNR 
  scatterplot(x_before_demodulation);
  title('Constellation Diagram'); 


end
%% plot
figure
semilogy(Eb_No,Pe_vect);
title('BER vs Eb/No ' + channel_type + ' for ' + M + ' QAM');

xlabel('Eb/No (dB)');
ylabel('BER (dB)');

     

