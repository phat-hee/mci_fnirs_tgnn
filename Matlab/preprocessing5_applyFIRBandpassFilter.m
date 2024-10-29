
function applyFIRBandpassFilter(data_dir, save_dir, fir_order, low_cutoff, high_cutoff, Fs)
    % Applies a FIR bandpass filter to fNIRS data in .mat files.
    % INPUTS:
    % data_dir   - Directory containing the input .mat files
    % save_dir   - Directory to save the filtered .mat files
    % fir_order  - Order of the FIR filter
    % low_cutoff - Low cutoff frequency in Hz
    % high_cutoff - High cutoff frequency in Hz
    % Fs         - Sampling frequency in Hz

    % Design the FIR bandpass filter using fir1
    fir_coeffs = fir1(fir_order, [low_cutoff, high_cutoff] / (Fs / 2), 'bandpass');
    
    % Ensure the save directory exists
    if ~exist(save_dir, 'dir')
        mkdir(save_dir);
    end

    % Get a list of all .mat files in the directory
    mat_files = dir(fullfile(data_dir, '*.mat'));

    % Loop through each .mat file
    for k = 1:length(mat_files)
        % Load the current .mat file
        file_path = fullfile(data_dir, mat_files(k).name);
        data = load(file_path, 'standardized_data');
        
        if isfield(data, 'standardized_data')
            standardized_data = data.standardized_data;

            % Check for non-finite values and interpolate or remove them
            if any(~isfinite(standardized_data), 'all')
                % Replace NaNs and Infs with interpolated values
                standardized_data = fillmissing(standardized_data, 'linear', 2);
                standardized_data(~isfinite(standardized_data)) = 0;  % Set non-finite values to zero if needed
            end
            
            % Normalize the data if necessary
            standardized_data = standardized_data - mean(standardized_data, 'all');
            standardized_data = standardized_data / std(standardized_data, 0, 'all');

            % Apply the FIR filter to the data
            try
                % Apply the FIR filter
                hbr_fir_filtered = filtfilt(fir_coeffs, 1, standardized_data);

                % Create a new filename for the FIR filtered data
                [~, name, ~] = fileparts(mat_files(k).name);
                save_path_fir = fullfile(save_dir, [name, '_filtered.mat']);

                % Save the FIR filtered data
                save(save_path_fir, 'hbr_fir_filtered');
                
                % Display progress for FIR
                fprintf('FIR Filtered and saved: %s\n', save_path_fir);
            catch ME
                % Display error message if filtering fails
                fprintf('Error filtering %s with FIR: %s\n', file_path, ME.message);
            end
        else
            % Display warning if 'standardized_data' variable not found
            fprintf('No standardized_data variable found in: %s\n', file_path);
        end
    end

    % Optional: Plot an example to verify
    if ~isempty(mat_files)
        % Plot the first file before and after filtering
        example_file_path = fullfile(data_dir, mat_files(1).name);
        example_data = load(example_file_path, 'standardized_data');
        example_standardized_data = example_data.standardized_data;
        
        % Apply FIR filter to the example data
        example_hbr_fir_filtered = filtfilt(fir_coeffs, 1, example_standardized_data);
        
        % Plotting
        figure;
        subplot(2,1,1);
        plot(example_standardized_data);
        title('Original fNIRS Data');
        xlabel('Samples');
        ylabel('Amplitude');

        subplot(2,1,2);
        plot(example_hbr_fir_filtered);
        title('FIR Filtered fNIRS Data');
        xlabel('Samples');
        ylabel('Amplitude');
    end
end
