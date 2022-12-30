function [x_Rx1, x_Rx2, x_time_domain_1, x_time_domain_2] = Rx(M, L, y_Tx1, y_Tx2, x_QAM_modulated, h1, h2,fft_size, channel_type)
    if channel_type == "Multipath"
        % Remove cyclic prefix
        y1 = y_Tx1(L:fft_size+L-1);
        y2 = y_Tx2(L:fft_size+L-1);

        % Equalizing (remove channel effect)
        x_time_domain_1 = fft(y1)./fft([h1 zeros(1,length(y1)-length(h1))]);
        x_time_domain_2 = fft(y2)./fft([h2 zeros(1,length(y2)-length(h2))]);
        
        % Demodulation
        modulation_length = length(x_QAM_modulated);
        x_demod_1 = QAM_demodulation(x_time_domain_1(1:modulation_length),M);
        x_demod_2 = QAM_demodulation(x_time_domain_2(1:modulation_length),M);
                
        % Channel Decoding
        x_Rx1 = channel_decoding(x_demod_1);
        x_Rx2 = channel_decoding(x_demod_2);
        
    else 
        h1=1;
        h2=1;

        % Equalizing (remove channel effect)
        x_time_domain_1 = fft(y_Tx1)./fft([h1 zeros(1,length(y_Tx1)-length(h1))]);
        x_time_domain_2 = fft(y_Tx2)./fft([h2 zeros(1,length(y_Tx2)-length(h2))]);

        % Demodulation
        modulation_length = length(x_QAM_modulated);
        x_demod_1 = QAM_demodulation(x_time_domain_1(1:modulation_length),M);
        x_demod_2 = QAM_demodulation(x_time_domain_2(1:modulation_length),M);

        % Channel Decoding
        x_Rx1 = channel_decoding(x_demod_1);
        x_Rx2 = channel_decoding(x_demod_2);
    end
    