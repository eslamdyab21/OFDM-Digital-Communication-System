% Channel calculation 
N_bits = 1000;
L = 50;
h = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));

Eb_No = 0:3:40;
No_vect = 1./(10.^(Eb_No/10));
for i = 1:14
  for j = 1:100
    %Generate seq
    x = randi([0 1],1,N_bits);
    % Hamming Coding (Channel Encoding)
    x_encoded = channel_encoding(x,N_bits);
    % Modulation
    x_quad = QPSK(x_encoded);
    % Pilot insertion (For bonus)
    % IFFT 
    x_ifft = ifft(x_quad,1024);
    %Cyclic prefix
    x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
  end
  % Remove cyclic prefix
  % To be added
  % FFT
  y = fft(x_ifft);
  
  % Demodulation
  x_demod = demod(y,length(x_quad));
end


