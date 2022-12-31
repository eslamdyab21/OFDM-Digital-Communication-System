function x_decoded = Channeldecoding(x_demod)
p1 = [0;1;1;1]; % First parity of encoding p1 = d2+d3+d4
p2 = [1;0;1;1];
p3 = [1;1;0;1];
H = [eye(3) [p1' ;p2' ;p3']];
k = 1;

err_values = [0 0 0 0 0 0 0; 0 0 0 0 0 0 1;0 0 0 0 0 1 0;0 0 0 0 1 0 0;0 0 0 1 0 0 0;0 0 1 0 0 0 0;0 1 0 0 0 0 0;1 0 0 0 0 0 0];
syndroms = [0; 7; 6; 5; 3; 1; 2; 4];


for i = 1:7:length(x_demod)
    s = mod(x_demod(i:i+6)*H',2);
    s_dec = bin2dec(strjoin(string(s),''));

   index = find(syndroms==s_dec);

    
   
    err = err_values(index,:);
    %x_hat = bitxor(x_demod(i:i+6),err);
    x_hat = mod(err + x_demod(i:i+6),2);
    x_decoded(k:k+3) = x_hat(4:7);
    
    k = k+4;
end

end
