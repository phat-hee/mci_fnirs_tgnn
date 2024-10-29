
function cleaned_data = remove_spikes(data, variance_threshold)
    % Function to remove spikes from the data based on a variance threshold.
    % Args:
    %   data (matrix): Input data with possible spikes.
    %   variance_threshold (float): Variance threshold for spike detection.
    
    % Set default variance threshold if not provided
    if nargin < 2
        variance_threshold = 1.8;
    end

    % Calculate variance for each data segment
    window_size = 10;  % Window size to compute variance
    cleaned_data = data; % Initialize output with original data
    
    % Loop through the data and calculate the rolling variance
    for i = 1:size(data, 2)  % For each channel/column
        for j = 1:size(data, 1) - window_size + 1
            segment = data(j:j+window_size-1, i);  % Window segment
            segment_variance = var(segment);  % Calculate variance of the segment

            % If variance exceeds threshold, mark as NaN
            if segment_variance > variance_threshold
                cleaned_data(j:j+window_size-1, i) = NaN;
            end
        end
    end

    % Optional: Interpolate NaNs if needed
    cleaned_data = fillmissing(cleaned_data, 'linear');
end
