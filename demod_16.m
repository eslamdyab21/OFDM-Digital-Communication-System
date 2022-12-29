function x_demod_16 = demod_16(y)
    mod_symbols = [-3-3i -3-1i -3+3i -3+1i -1-3i -1-1i -1+3i -1+1i 3-3i 3-1i 3+3i 3+1i 1-3i 1-1i 1+3i 1+1i];
    x_demod_16 = zeros(1,length(y)*4);
    k = 1;
    
    for i = 1:length(y)
        index_symbol = find(y(i) == mod_symbols);
        x_process = flip(de2bi(index_symbol-1));
        if length(x_process) ~= 4
            addZeros = 4 - length(x_process);
            x_process = [zeros(1,addZeros) x_process];
        end
        x_demod_16(k:k+3) = x_process;
        k = k+4;
    end 
end 
