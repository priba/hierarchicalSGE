function [ data ] = load_data( name, path )
%LOAD_DATA 
    switch upper(name)
    case 'MUTAG'
        disp('Loading MUTAG...') ;
        load(fullfile(path, 'MUTAG.mat')) ;
        lmutag(lmutag == -1) = 2 ;
        data.dataset.name = 'MUTAG' ;
        data.dataset.clss = lmutag ;
        data.dataset.graphs = MUTAG ;
        data.type = 'kfold' ;
    case 'PTC'
        disp('Loading PTC...') ;
        load(fullfile(path, 'PTC.mat')) ;
        lptc(lptc == -1) = 2 ;
        data.dataset.name = 'PTC' ;
        data.dataset.clss = lptc ;
        data.dataset.graphs = PTC ;
        data.type = 'kfold' ;
    case 'ENZYMES'
        disp('Loading ENZYMES...') ;
        load(fullfile(path, 'ENZYMES.mat')) ;
        data.dataset.name = 'ENZYMES' ;
        data.dataset.clss = lenzymes ;
        data.dataset.graphs = ENZYMES ;
        data.type = 'kfold' ;
    case 'NCI1'
        disp('Loading NCI1...') ;
        load(fullfile(path, 'NCI1.mat')) ;
        data.dataset.name = 'NCI1' ;
        data.dataset.clss = lnci1 ;
        data.dataset.graphs = NCI1 ;
        data.type = 'kfold' ;
    case 'NCI109'
        disp('Loading NCI109...') ;
        load(fullfile(path, 'NCI109.mat')) ;
        data.dataset.name = 'NCI109' ;
        data.dataset.clss = lnci109 ;
        data.dataset.graphs = NCI109 ;
        data.type = 'kfold' ;
    case 'DD'
        disp('Loading D&D...')
        load(fullfile(path,'DD.mat')) ; 
        data.dataset.name = 'DD' ;
        data.dataset.clss = ldd ;
        data.dataset.graphs = DD ;
        data.type = 'kfold' ;
    case 'MAO'
        disp('Loading MAO...')
    otherwise
        error('load_data:incorrectDataset', ...
            'Error.\nNot implemented dataset %s.', name)
    end; % switch
    
    disp('Dataset loaded.')

end % function
