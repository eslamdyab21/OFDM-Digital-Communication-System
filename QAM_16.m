function x_qam = QAM_16(x_encoded)
    mod_symbols = [-3-3i -3-1i -3+3i -3+1i -1-3i -1-1i -1+3i -1+1i 3-3i 3-1i 3+3i 3+1i 1-3i 1-1i 1+3i 1+1i];
    if mod(length(x_encoded),4) ~= 0
        addZeros = 4*ceil(length(x_encoded)/4) - length(x_encoded);
        x_encoded = [x_encoded zeros(1,addZeros)];
    end
    x_qam = zeros(1,length(x_encoded)/4);
    k = 1;

    for i = 1:4:length(x_encoded)
        index_symbol = bi2de(flip(x_encoded(i:i+3)));
        x_qam(k) = mod_symbols(index_symbol+1);
        k = k+1;
    end
end
