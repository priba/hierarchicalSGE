function [] = add_paths(params)

    % Addpaths
    % paths from the current working directory
    folders_paths = cellfun(@(x) strcat(pwd, filesep, x), params.folders, 'UniformOutput', false ) ;
    folders_paths = cellfun(@genpath,folders_paths, 'UniformOutput', false ) ;
    addpath([folders_paths{:}])
    
    if ispc
        user_path = strrep(params.user_path,';',''); % Windows
    elseif isunix
        user_path = strrep(params.user_path,':',''); % Linux
    end
    
    % paths from the directory at user_path
    folders_paths = cellfun(@(x) strcat(user_path, filesep, x), params.libraries_sub, 'UniformOutput', false ) ;
    folders_paths = cellfun(@genpath, folders_paths, 'UniformOutput', false ) ;
    addpath( [folders_paths{:} ]) ;

    folders_paths = cellfun(@(x) strcat(user_path, filesep, x), params.libraries, 'UniformOutput', false ) ;
    run( [folders_paths{:} ]) ;

    clear user_path folders_paths ;