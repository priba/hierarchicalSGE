function [ gtrain, gvalidation, gtest, ltrain, lvalidation, ltest ] = load_data( name, path, labeled=False)
    switch lower(name)
    case 'mutag'
    case 'ptc'
    case 'proteins'
    case 'nci1'
    case 'nci109'
    case 'd&d'
    case 'mao'
    otherwise
        error('load_data:incorrectDataset', ...
            'Error.\nNot implemented dataset %s.', name)
    end;
end