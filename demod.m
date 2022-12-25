function x_demod = demod(y,L)
x_demod = zeros(1,L*2);
k = 1;
for i = 1:L
    if (real(y(i))>0)
       x_demod(k) = 1;
    else
       x_demod(k) = 0;
    end    
    if (imag(y(i))>0)
       x_demod(k+1) = 1;
    else
       x_demod(k+1) = 0; 
    end
    k = k+2;
end