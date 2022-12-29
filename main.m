%% SISO (Single Input Single Output)
% Channel calculation 
N_bits = 1168;
L = 50;
no_of_frames = 10;
Eb_No = 0:3:40;
No_vect = 1./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));
for i = 1:14
  Pe_frame_avg = 0;
  for k = 1:no_of_frames
  count_err = 0;
  h = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
  for j = 1:100
    %Generate seq
    x = randi([0 1],1,N_bits);
    % Hamming Coding (Channel Encoding)
    x_encoded = channel_encoding(x,N_bits);
    % Modulation
    x_quad = QPSK(x_encoded);
    % IFFT 
    x_ifft = ifft(x_quad,1024);
    %Cyclic prefix
    x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
    % channel effect
    y_cp = conv(x_cp,h)+sqrt((No_vect(i)/2)).*randn(1,(length(x_cp)+length(h)-1));
    % Remove cyclic prefix
    y = y_cp(L:length(x_ifft)+L-1);
    % FFT
    Xk_hat = fft(y)./fft([h zeros(1,length(y)-length(h))]);
    % Demodulation
    x_demod = demod(Xk_hat,length(x_quad));
    % Channel Decoding
    x_hat = channel_decoding(x_demod);
    count_err = count_err + biterr(x,x_hat);
  end
  Pe_frame_avg = Pe_frame_avg + count_err/(N_bits*100);
  
  end
  Pe_vect(i) = Pe_frame_avg/no_of_frames;
end

%% SIMO (Single Input Multiple Output) (Unfinished)
% Channel calculation 
N_bits = 1168;
L = 50;

Eb_No = 0:3:40;
No_vect = 1./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));
for i = 1:14
  Pe_frame_avg = 0;
  for k = 1:no_of_frames
  count_err = 0;
  h1 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
  h2 = (1/sqrt(2*L))*(randn(1,L)+1i*randn(1,L));
  for j = 1:100
    %Generate seq
    x = randi([0 1],1,N_bits);

    % Hamming Coding (Channel Encoding)
    x_encoded = channel_encoding(x,N_bits);
    % Modulation
    x_quad = QPSK(x_encoded);
    % IFFT 
    x_ifft = ifft(x_quad,1024);
    %Cyclic prefix
    x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
    % channel effect
    y_cp1 = conv(x_cp,h1)+sqrt((No_vect(i)/2)).*randn(1,(length(x_cp)+length(h1)-1));
    y_cp2 = conv(x_cp,h2)+sqrt((No_vect(i)/2)).*randn(1,(length(x_cp)+length(h2)-1));
    %y_cp = conv(x_cp,h);
    % Remove cyclic prefix
    y1 = y_cp1(L:length(x_ifft)+L-1);
    y2 = y_cp2(L:length(x_ifft)+L-1);
    
    % FFT
    y = fft(x_time_domain);
    % Demodulation
    x_demod = demod(y,length(x_quad));
    % Channel Decoding
    x_hat = channel_decoding(x_demod);
    count_err = count_err + biterr(x,x_hat);
  end
  Pe_frame_avg = Pe_frame_avg + count_err/(N_bits*100);
  
  end
  Pe_vect(i) = Pe_frame_avg/no_of_frames;
end
%% plot
figure(1)
plot(Eb_No,10.*log10(Pe_vect));
title('BER vs Eb/No (SISO)');
xlabel('Eb/No (dB)');
ylabel('BER (dB)');
xlim([0 40]);
