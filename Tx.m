function [y_cp1 ,y_cp2, x_QAM_modeulated] = Tx(x, M, N_bits, L, No_vect, h1, h2, fft_size)
    % Hamming Coding (Channel Encoding)
    x_encoded = channel_encoding(x,N_bits);
    
    % Modulation
    x_QAM_modeulated = QAM_modulation(x_encoded, M);
    
    % IFFT 
    x_ifft = ifft(x_QAM_modeulated,fft_size);
    
    %Cyclic prefix
    x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
    
    % channel effect
    noise = sqrt(No_vect/2).*randn(1,(length(x_cp) + length(h1)-1));
    y_cp1 = conv(x_cp,h1) + noise;
    noise = sqrt(No_vect/2).*randn(1,(length(x_cp) + length(h1)-1));
    y_cp2 = conv(x_cp,h2) + noise;