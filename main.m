close all;
%% SIMO (Single Input Multiple Output) 
% Constants
N_bits = 2336; %corsponds to 1022 symbols
L = 50;
M = 16;
fft_size = 1024;
frames_num = 5;
ofdm_synbols_per_frame = 5;
channel_type = "AWGN";

Eb_No = 0:3:40;
No_vect = 1./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));

for i = 1:14
  Pe_avg_frames_perSNR = 0;
  for k = 1:frames_num
    count_err = 0;
    count_err_1 = 0;
    count_err_2 = 0;

    h1 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
    h2 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));

    for j = 1:ofdm_synbols_per_frame
        %Generate seq
        x = randi([0 1],1,N_bits);
        [y_Tx1, y_Tx2, x_QAM_modulated] = Tx(x, M, N_bits, L, No_vect(i), h1, h2, fft_size, channel_type);

        [x_Rx1, x_Rx2, x_time_domain_1, x_time_domain_2] = Rx(M, L, y_Tx1, y_Tx2, x_QAM_modulated, h1, h2, fft_size, channel_type);
       
        count_err_1 = biterr(x,x_Rx1);
        count_err_2 = biterr(x,x_Rx2);

        % Chosse best h
        if count_err_1 < count_err_2
            count_err_small = count_err_1;
        elseif count_err_2 < count_err_1
            count_err_small = count_err_2;
        else
            count_err_small = count_err_1;
        end
        
        count_err = count_err + count_err_small;
        
    end
    
    Pe_avg_frames_perSNR = Pe_avg_frames_perSNR + count_err/(N_bits*ofdm_synbols_per_frame);
  end

  Pe_vect(i) = Pe_avg_frames_perSNR;

%   Plot the constellation diagram    
  scatterplot(x_time_domain_1);
  title('Constellation Diagram'); 


end
%% plot
figure
plot(Eb_No,10.*log10(Pe_vect));
title('BER vs Eb/No ' + channel_type + ' for ' + M + ' QAM');


xlabel('Eb/No (dB)');
ylabel('BER (dB)');
xlim([0 40]);

     

