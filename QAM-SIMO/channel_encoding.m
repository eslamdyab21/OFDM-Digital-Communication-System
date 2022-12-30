function x_encoded = channel_encoding(x,N_bits)
%Hamming Coding (Channel Encoding)
x_encoded = zeros(1,N_bits*(7/4)); % Output after encoding
d1 = [1;0;0;0]; % index of first element of 4 bits encoding
d2 = [0;1;0;0];
d3 = [0;0;1;0];
d4 = [0;0;0;1];
p1 = [0;1;1;1]; % First parity of encoding p1 = d2+d3+d4
p2 = [1;0;1;1];
p3 = [1;1;0;1];
G = [p1 p2 p3 d1 d2 d3 d4]; % Generator Matrix of Hamming(4,7) 
k = 1;
for i = 1:4:N_bits
    x_encoded(k:k+6) = mod(x(i:3+i)*G,2);
    k = k+7;
    
end

end