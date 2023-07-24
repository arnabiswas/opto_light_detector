function filtered_vec = filterConsecutiveOnes(vec)
    % Convert vector to a string to facilitate the search
    vec_str = num2str(reshape(vec,1,[]));
    vec_str(vec_str == ' ') = [];  % Remove the white spaces
    
    % Detect the sequence of 20 consecutive ones
    idx = strfind(vec_str, '1111111111');
    
    % If a sequence is found, replace it
    if ~isempty(idx)
        for i = 1:length(idx)
            % Replace 20 ones with 20 zeros
            vec_str(idx(i):idx(i)+19) = '0';
        end
    end
    
    % Convert the string back to a numeric array
    filtered_vec = vec_str - '0';
end 
