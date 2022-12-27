function x_quad = QPSK(x_encoded)
mod_symbols = (1/sqrt(2))*[-1-1i,-1+1i,1-1i,1+1i];
if mod(length(x_encoded),2) ~= 0
   x_encoded = [x_encoded 0]; 
end
x_quad = zeros(1,length(x_encoded)/2);
k = 1;

for i = 1:length(x_quad)
    index_symbol = (2^1)*x_encoded(k)+(2^0)*x_encoded(k+1);
    x_quad(i) = mod_symbols(index_symbol+1);
    k = k+2;
end
end