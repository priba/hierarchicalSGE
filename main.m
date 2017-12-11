function [  ] = main( params )
%MAIN Reproduce experiments
%   Reproduce the experiments presented in: (SOON)
%   Input:
%       params - Structure with the following information

    %% Load data
    [ gtrain, gvalidation, gtest, ltrain, lvalidation, ltest ] = load_data( params.dataset, params.data_path params.islabeled);
    
    %% Create Hierarchy
    for i = 1:lenght(gtrain)
        gtrain(i) = hierarchical_graph( gtrain(i), params.hierarchy );
    end; % for
    for i = 1:lenght(gvalidation)
        gvalidation(i) = hierarchical_graph( gvalidation(i), params.hierarchy );
    end; % for
    for i = 1:lenght(gtest)
        gtest(i) = hierarchical_graph( gtest(i), params.hierarchy );
    end; % for
    
    %% Create Embedding
    for i = 1:lenght(gtrain)
        gtrainsge(i) = hierarchicalSGE( gtrain(i), params.sge );
    end; % for
    for i = 1:lenght(gvalidation)
        gvalidationsge(i) = hierarchicalSGE( gvalidation(i), params.sge );
    end; % for
    for i = 1:lenght(gtest)
        gtestsge(i) = hierarchicalSGE( gtest(i), params.sge );
    end; % for
    
    %% Classify
    % svm
end % function

