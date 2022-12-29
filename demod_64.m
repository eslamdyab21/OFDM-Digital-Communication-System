function x_demod_64 = demod_64(y)
    mod_symbols = [];
    i = 1;
    for k=-7:2:7
        for j=-7:2:7
            mod_symbols(i) = k + 1i*j;
            i = i + 1;
        end
    end
    x_demod_64 = zeros(1,length(y)*6);
    k = 1;
    
    for i = 1:length(y)
        index_symbol = find(y(i) == mod_symbols);
        x_process = flip(de2bi(index_symbol-1));
        if length(x_process) ~= 6
            addZeros = 6 - length(x_process);
            x_process = [zeros(1,addZeros) x_process];
        end
        x_demod_64(k:k+5) = x_process;
        k = k+6;
    end 
end 
