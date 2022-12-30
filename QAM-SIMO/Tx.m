function [y_Tx1 ,y_Tx2, x_QAM_modulated] = Tx(x, M, N_bits, L, No_vect, h1, h2, fft_size)
    % Hamming Coding (Channel Encoding)
    x_encoded = channel_encoding(x,N_bits);

    % Modulation
    x_QAM_modulated = QAM_modulation(x_encoded, M);
    % IFFT 
    x_QAM_modulated = sqrt(fft_size).*x_QAM_modulated;
    x_ifft = ifft(x_QAM_modulated,fft_size);

    %Cyclic prefix
    x_ifft = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];

    % channel effect
    noise = sqrt(No_vect/2).*randn(1,(length(x_ifft) + length(h1)-1));
    
    y_Tx1 = conv(x_ifft,h1) + noise;
    noise = sqrt(No_vect/2).*randn(1,(length(x_ifft) + length(h2)-1));
    y_Tx2 = conv(x_ifft,h2) + noise;
