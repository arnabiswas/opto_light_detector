function filtered_signal = filterLightSignal(input_signal)
    % Convert the input signal to a string to facilitate the search
    signal_str = num2str(input_signal);
    signal_str(signal_str == ' ') = [];  % Remove the white spaces

    % Initialize the filtered signal as an array of ones (light on)
    filtered_signal = ones(length(input_signal),1);

    % Find the sequences of 10 or more consecutive zeros
    zero_seqs = strfind(signal_str, '0000000000');

    for i = 1:length(zero_seqs)
        % For each sequence, set the corresponding elements of the filtered signal to zero (light off)
        filtered_signal(zero_seqs(i):(zero_seqs(i)+9)) = 0;
    end
end
