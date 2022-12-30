%% SISO (Single Input Single Output)

N_bits = 1168;
L = 50;
no_of_frames = 1;
fft_size = 1024;
Eb = 1/log2(4);
Eb_No = 0:3:40;
No_vect = Eb./(10.^(Eb_No/10));

Pe_vect_multi_siso = zeros(1,length(Eb_No));
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
        x_ifft = ifft(x_quad,fft_size);
        %Cyclic prefix
        x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
        % channel effect
        y_cp = conv(x_cp,h)+ sqrt((No_vect(i)/2)).*randn(1,(length(x_cp)+length(h)-1));
        % Remove cyclic prefix
        y = y_cp(L:length(x_ifft)+L-1);
        % FFT
        Xk_hat = (fft(y)./fft([h zeros(1,length(y)-length(h))]));
        % Demodulation
        x_demod = demod(Xk_hat,length(x_quad));
        % Channel Decoding
        x_hat = channel_decoding(x_demod);
        count_err = count_err + biterr(x,x_hat);
      end
  Pe_frame_avg = Pe_frame_avg + count_err/(N_bits*100);
  
  end
  Pe_vect_multi_siso(i) = Pe_frame_avg/no_of_frames;
end

%% SIMO (Single Input Multiple Output) (Unfinished)

N_bits = 1168;
L = 50;
no_of_frames = 10;
fft_size = 1024;

Eb_No = 0:3:40;
Eb = 1/log2(4);
No_vect =Eb./(10.^(Eb_No/10));
Pe_vect_multi_simo = zeros(1,length(Eb_No));
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
    x_ifft = ifft(x_quad,fft_size);
    %Cyclic prefix
    x_cp = [x_ifft(length(x_ifft)-L+1+1:length(x_ifft)) x_ifft];
    % channel effect
    noise = sqrt((No_vect(i)/2)).*randn(1,(length(x_cp)+length(h1)-1));
    y_cp1 = conv(x_cp,h1)+noise;
    y_cp2 = conv(x_cp,h2)+noise;
    % Rx
    % Remove cyclic prefix
    y1 = y_cp1(L:length(x_ifft)+L-1);
    y2 = y_cp2(L:length(x_ifft)+L-1);
    % check which channel has larger power(SC technique)
    if norm(h1) > norm(h2)
        % FFT
        Xk_hat = (fft(y1)./fft([h1 zeros(1,length(y1)-length(h1))]));
    else
        % FFT
        Xk_hat = (fft(y2)./fft([h2 zeros(1,length(y2)-length(h2))]));
    end
    % Demodulation
    x_demod = demod(Xk_hat,length(x_quad));
    % Channel Decoding
    x_hat = channel_decoding(x_demod);
    count_err = count_err + biterr(x,x_hat);
  end
  Pe_frame_avg = Pe_frame_avg + count_err/(N_bits*100);
  
  end
  Pe_vect_multi_simo(i) = Pe_frame_avg/no_of_frames;
end


%% plot
figure(1)
semilogy(Eb_No,(Pe_vect));
title('BER vs Eb/No (SISO) (MultiPath)');
xlabel('Eb/No (dB)');
ylabel('BER (dB)');
xlim([0 40]);
figure(2)
semilogy(Eb_No,Pe_vect_multi_simo);
title('BER vs Eb/No (SIMO) (MultiPath)');
xlabel('Eb/No (dB)');
ylabel('BER (dB)');
xlim([0 40]);
