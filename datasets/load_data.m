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
        error('Not implemented dataset!')
    end;
end