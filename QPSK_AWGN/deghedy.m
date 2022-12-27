% Number of bits
N_bits = 1000;

% Generate a sequence of 1000 random bits
bits = randi([0 1], N_bits, 1);

% Channel Encoding (Hamming)
% x_encoded = channel_encoding(bits, N_bits);

% Symbol Mapper (QPSK)
symbols = qammod(bits, 4, 'InputType', 'bit', 'UnitAveragePower', true);

% Set up arrays to store the BER and SNR values
ber = zeros(1, 10);
snr_values = zeros(1, 10);

% Loop over a range of SNR values
for snr = 0 : 9
    
    num_antennas = 2; % Number of receive antennas

    % Add AWGN noise to the symbols
    x_modulated = awgn(symbols, snr, 'measured', num_antennas);

    % IFFT
    x_ifft = ifft(x_modulated, 500);


    % FFT
    y = fft(x_ifft);

    % Demodulate the received symbols
    demod_bits = qamdemod(y, 4, 'OutputType', 'bit', 'UnitAveragePower', true);
    
    % Channel Decoding (Hamming)
%     x_decoded = channel_decoding(demod_bits);

    % Calculate the BER
    ber(snr + 1) = biterr(bits, demod_bits) / length(bits);
    
    % Store the SNR value
    snr_values(snr + 1) = snr;
    
end

% Plot the BER values as a function of the SNR values
plot(snr_values, ber)
xlabel('SNR (dB)')
ylabel('BER')
title('QPSK Performance over AWGN Channel with 1x1 SISO Setup')


% The channel_encoding and channel_decoding are copied from Islam Ashraf code, and for me they cause errors, so I'm commenting them
% Also I didn't implement the cyclic prefix besara7a, and I'm waiting for Islam Ashraf bardo to implement it, so I can copy it from him
% Big thanks to Ashraf, all of us love you <3