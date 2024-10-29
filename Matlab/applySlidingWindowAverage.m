
function applySlidingWindowAverage(input_dir, output_dir, window_size, overlap_size)
    % Applies a sliding window average to the 'rescaled_data' matrix in each .mat file in the input directory.
    % NaN values are replaced with the mean of each window. Results are saved in the output directory.

    % Ensure the output directory exists
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Get a list of all .mat files in the input directory
    files = dir(fullfile(input_dir, '*.mat'));

    % Loop through each file
    for file = files'
        % Load the .mat file
        data = load(fullfile(input_dir, file.name));

        % Check if 'rescaled_data' exists in the file
        if isfield(data, 'rescaled_data')
            rescaled_data = data.rescaled_data;

            % Replace NaN values with the mean of the data
            rescaled_data(isnan(rescaled_data)) = mean(rescaled_data(~isnan(rescaled_data)), 'all');

            % Apply the sliding window average to the 'rescaled_data' matrix
            averaged_data = movmean(rescaled_data, window_size, 'Endpoints', 'discard');

            % Save the averaged data to a new .mat file in the output directory
            save(fullfile(output_dir, file.name), 'averaged_data');
            
            % Display progress
            fprintf('Processed and saved: %s\n', fullfile(output_dir, file.name));
        else
            fprintf('No "rescaled_data" variable found in: %s\n', file.name);
        end
    end
end
