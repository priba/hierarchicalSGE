function [ params ] = set_parameters()
% Parameters
        
    % Check hostname to know the file structure for adding the packages
    [~, name] = system('hostname');
    
    if ismember(upper(cellstr(name)), {'CVC206'} ) 
        % Dataset path
        params.p_data = '/home/adutta/Workspace/Datasets/STDGraphs' ;

        % External libreries (considering them to be on the userpath folder
        params.libraries_sub = {'matlab_bgl', 'libsvm/matlab',...
            'random_graphlet1'} ;
        
        % External libreries (considering them to be on the userpath
        % folder) No subfolders will be added
        params.libraries = { 'vlfeat/toolbox/vl_setup.m' } ;
        
        % Project folders
        params.folders = { 'clustering', 'hierarchy', 'datasets' } ;
        
        params.user_path = '/home/adutta/Dropbox/Personal/Workspace/AdditionalTools' ;
        params.p_out = '/home/adutta/Workspace/HSGE' ;
        
    elseif ismember(upper(cellstr(name)), {'CVC175'} )
        
        % Dataset path
        params.p_data = [ pwd filesep 'dataset' filesep ] ;

        % External libreries (considering them to be on the userpath
        % folder) All the subfolders will be added
        params.libraries_sub = { 'matlab_bgl', 'libsvm/matlab'};
        
        % External libreries (considering them to be on the userpath
        % folder) No subfolders will be added
        params.libraries = { 'vlfeat/toolbox/vl_setup.m' } ;

        % Project folders
        params.folders = { 'clustering', 'random_graphlet1' } ;
        params.user_path = userpath;
%         paths1 = pwd;
        
    elseif ismember(upper(cellstr(name)), {'ANJANLAPTOP'})
        
        % Dataset path
        params.p_data = '/home/adutta/Workspace/Datasets/STDGraphs' ;

        % External libreries (considering them to be on the userpath folder
        params.libraries_sub = {'matlab_bgl', 'libsvm/matlab',...
            'random_graphlet1'} ;
        
        % External libreries (considering them to be on the userpath
        % folder) No subfolders will be added
        params.libraries = { 'vlfeat/toolbox/vl_setup.m' } ;
        
        % Project folders
        params.folders = { 'clustering', 'hierarchy', 'datasets' } ;
        
        params.user_path = '/home/adutta/Dropbox/Personal/Workspace/AdditionalTools' ;
        params.p_out = '/home/adutta/Workspace/HSGE' ;
        
    end 
    
    clear name;
    
    % Number of graphs depending on the number of edges
    params.T = [1 1 3 5 12 30 79 227 710 2322 8071]; 
    
end