function err = syndrom_table(s)
s_dec = bin2dec(strjoin(string(s),''));
err_values = [0 0 0 0 0 0 0; 0 0 0 0 0 0 1;0 0 0 0 0 1 0;0 0 0 0 1 0 0;0 0 0 1 0 0 0;0 0 1 0 0 0 0;0 1 0 0 0 0 0;1 0 0 0 0 0 0];
syndroms = [0; 7; 6; 5; 3; 1; 2; 4];
i = find(syndroms==s_dec);
err = err_values(i,:);
end