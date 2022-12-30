function x_QAM_modeulated = QAM_modulation(x_encoded, M)
    x_encoded = string(x_encoded);
    M=log2(M);

    greycode = generate_grey_code(M/2);

    if mod(length(x_encoded),M) ~= 0
       x_encoded = [x_encoded zeros(1, M - mod(length(x_encoded),M))];  
    end
    
    x_QAM_modeulated = zeros(1,length(x_encoded)/M);

    AMi_vector = zeros(1, length(greycode));
    AMq_vector = zeros(1, length(greycode));

    for m = 1 : length(greycode)
        AMi_vector(m) = 2*m - 1 - length(greycode);
    end

    AMq_vector = AMi_vector;
    AMi_vector;

    
    k=1;
    for i = 1:length(x_QAM_modeulated)
        sequence=x_encoded(k:k-1+M);
        sequence_even=sequence(1:length(sequence)/2);
        sequence_odd=sequence((length(sequence)/2)+1:length(sequence));

        sequence_even = strjoin(sequence_even,"");
        sequence_odd = strjoin(sequence_odd,"");

        index_even = find (greycode == sequence_even);
        index_odd = find (greycode == sequence_odd);

        AMi = AMi_vector(index_even);
        AMq = AMq_vector(index_odd);

        x_QAM_modeulated(i) = AMi + AMq*j;

        k = k + M;
    end

