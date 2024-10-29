
function detrend_data(input_folder, output_folder, poly_order)
    % Check if the output folder exists; create it if it doesn't
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Get a list of .mat files in the input folder
    files = dir(fullfile(input_folder, '*.mat'));

    % Loop through each file
    for file = files'
        % Load the data
        data = load(fullfile(input_folder, file.name));
        
        % Check if 'dc_removed_data' exists in the loaded data
        if isfield(data, 'dc_removed_data')
            % Detrend the data
            if nargin < 3 || poly_order == 1
                detrended_data = detrend(data.dc_removed_data); % Linear detrending
            else
                detrended_data = detrend(data.dc_removed_data, poly_order); % Polynomial detrending
            end
            
            % Define the output file name
            output_file = fullfile(output_folder, file.name);
            
            % Save the detrended data
            save(output_file, 'detrended_data');
        end
    end
end
