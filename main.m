%% Test Modulation
x_encoded = [ 0 1 0 0 0 1 0 1]
x_qam_mod = QAM_modulation(x_encoded,16);
x_qam_demod = QAM_demodulation(x_qam_mod, 16);

%% SIMO (Single Input Multiple Output) 
% Constants
N_bits = 2336; %corsponds to 1022 symbols
L = 50;
M = 16;
fft_size = 1024;
frames_num = 10;
ofdm_synbols_per_frame = 10;

Eb_No = 0:3:40;
No_vect = 1./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));

for i = 1:14
  Pe_frame_avg_frame = 0;
  for k = 1:frames_num
    count_err = 0;
    count_err_1 = 0;
    count_err_2 = 0;

    h1 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
    h2 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
    for j = 1:ofdm_synbols_per_frame
        %Generate seq
        x = randi([0 1],1,N_bits);
        [y_cp1, y_cp2, x_QAM_modeulated] = Tx(x, M, N_bits, L, No_vect(i), h1, h2, fft_size);


        %----To do--------------
        % Move following to Rx function
        % AWGN Chanell

        % Remove cyclic prefix
        y1 = y_cp1(L:fft_size+L-1);
        y2 = y_cp2(L:fft_size+L-1);

        % Equalizing (remove channel effect)
        x_time_domain_1 = fft(y1)./fft([h1 zeros(1,length(y1)-length(h1))]);
        x_time_domain_2 = fft(y2)./fft([h2 zeros(1,length(y2)-length(h2))]);

        % Demodulation
        modlation_length = length(x_QAM_modeulated);
        x_demod_1 = QAM_demodulation(x_time_domain_1(1:modlation_length),M);
        x_demod_2 = QAM_demodulation(x_time_domain_2(1:modlation_length),M);

        % Channel Decoding
        x_hat_1 = channel_decoding(x_demod_1);
        x_hat_2 = channel_decoding(x_demod_2);

        count_err_1 = biterr(x,x_hat_1);
        count_err_2 = biterr(x,x_hat_2);

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
    
    Pe_frame_avg_frame = Pe_frame_avg_frame + count_err/(N_bits*ofdm_synbols_per_frame);
  end

  Pe_vect(i) = Pe_frame_avg_frame;
end
%% plot
figure(1)
plot(Eb_No,10.*log10(Pe_vect));
title('BER vs Eb/No (SISO)');
xlabel('Eb/No (dB)');
ylabel('BER (dB)');
xlim([0 40]);

