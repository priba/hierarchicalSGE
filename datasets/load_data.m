function [ gtrain, gvalidation, gtest, ltrain, lvalidation, ltest ] = load_data( name, path, labeled)
%LOAD_DATA 
    switch lower(name)
    case 'mutag'
        disp('Loading MUTAG...')
    case 'ptc'
        disp('Loading PTC...')
    case 'proteins'
        disp('Loading PROTEINS...')
    case 'nci1'
        disp('Loading NCI1...')
    case 'nci109'
        disp('Loading NCI109...')
    case 'd&d'
        disp('Loading D&D...')
    case 'mao'
        disp('Loading MAO...')
    otherwise
        error('load_data:incorrectDataset', ...
            'Error.\nNot implemented dataset %s.', name)
    end; % switch
    
    disp('Dataset loaded.')
end % function

