function [x_Rx, x_time_domain] = Rx(M, L, y_Tx1, y_Tx2, x_QAM_modulated, h1, h2,fft_size)
    % Check which channel has bigger energy (smaller effect on signal)
    % To equalize (remove channel effect) its recived signal 
    % And remove cyclic prefix
    if norm(h1) > norm(h2)
        y1 = y_Tx1(L:fft_size+L-1);
        y1 = y1./sqrt(fft_size);
        x_time_domain = fft(y1)./fft([h1 zeros(1,length(y1)-length(h1))]);
    else
        y2 = y_Tx2(L:fft_size+L-1);
        y2 = y2./sqrt(fft_size);
        x_time_domain = fft(y2)./fft([h2 zeros(1,length(y2)-length(h2))]);
    end


    % Demodulation
    modulation_length = length(x_QAM_modulated);
    x_demod = QAM_demodulation(x_time_domain(1:modulation_length),M);

    % Channel Decoding
    x_Rx = Channeldecoding(x_demod);
    