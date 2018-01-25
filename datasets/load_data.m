function [ data ] = load_data( name, subset, path )
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
    case 'PROTEINS'
        disp('Loading PTC...') ;
        load(fullfile(path, 'PROTEINS.mat')) ;
        lproteins(lproteins == -1) = 2 ;
        data.dataset.name = 'PROTEINS' ;
        data.dataset.clss = lproteins' ;
        data.dataset.graphs = PROTEINS ;
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
        
        % Removing the edge labels 
        NCI1 = rmfield(NCI1, 'el') ;
        
        data.dataset.graphs = NCI1 ;
        data.type = 'kfold' ;
    case 'NCI109'
        disp('Loading NCI109...') ;
        load(fullfile(path, 'NCI109.mat')) ;
        data.dataset.name = 'NCI109' ;
        data.dataset.clss = lnci109 ;
        
        % Removing the edge labels
        NCI109 = rmfield(NCI109, 'el') ;
        
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
        fp = fopen(fullfile(path, 'MAO', 'dataset.ds')) ;
        C = textscan(fp, '%s %d') ;
        fclose(fp) ;
        
        graph_names = C{1} ;
        ngraphs = size(graph_names, 1) ;
        classes = double(C{2}) ;
        clear C ;
        classes(~classes) = 2 ;
                
        MAO = repmat(struct('am', [], 'nl', [], 'el', [], 'al', []), 1, ngraphs) ;
        
        cntrs_atrvertices = {'C', 'N', 'O'} ;
        
        for i = 1:ngraphs
            [~, ~, atrvertices, edges, ~, atredges] =...
                    read_mao_ct(fullfile(path, 'MAO', graph_names{i}));
            MAO(i).am = full(sparse(edges(:, 1), edges(:, 2), 1, size(atrvertices, 1), size(atrvertices, 1))) ;
            [~, MAO(i).nl.values] = ismember(atrvertices, cntrs_atrvertices) ;
            MAO(i).el.values = atredges ;
            MAO(i).al = [] ;            
        end
        
        data.dataset.name = 'MAO' ;
        data.dataset.clss = classes ;
        data.dataset.graphs = MAO ;
        data.type = 'kfold' ;
        
    case 'COIL-DEL'
        
        [graphs_train, clss_train, graphs_valid, clss_valid, graphs_test, ...
            clss_test] = load_coildel(fullfile(path, 'COIL-DEL', 'data')) ;
        data.dataset.name = 'COIL-DEL' ;
        data.type = 'partition' ;
        data.dataset.graphs_train = [graphs_train, graphs_valid] ;
        data.dataset.clss_train = [clss_train; clss_valid] ;
        data.dataset.graphs_test = graphs_test ;
        data.dataset.clss_test = clss_test ;
        
    case 'GREC'
        
        [graphs_train, clss_train, graphs_valid, clss_valid, graphs_test, ...
            clss_test] = load_grec(fullfile(path, 'GREC', 'data')) ;        
        data.dataset.name = 'GREC' ;
        data.type = 'partition' ;
        data.dataset.graphs_train = [graphs_train, graphs_valid] ;
        data.dataset.clss_train = [clss_train; clss_valid] ;
        data.dataset.graphs_test = graphs_test ;
        data.dataset.clss_test = clss_test ;
        
    case 'AIDS'
        
        [graphs_train, clss_train, graphs_valid, clss_valid, graphs_test, ...
            clss_test] = load_aids(fullfile(path, 'AIDS', 'data')) ;        
        data.dataset.name = 'AIDS' ;
        data.type = 'partition' ;
        data.dataset.graphs_train = [graphs_train, graphs_valid] ;
        data.dataset.clss_train = [clss_train; clss_valid] ;
        data.dataset.graphs_test = graphs_test ;
        data.dataset.clss_test = clss_test ;
            
    case 'HISTOGRAPH'
        
        [graphs_train, clss_train, graphs_valid, clss_valid, graphs_test, ...
            clss_test] = load_histograph(fullfile(path, 'HistoGraph'), subset) ;        
        data.dataset.name = 'HISTOGRAPH' ;
        data.type = 'partition' ;
        data.dataset.graphs_train = [graphs_train, graphs_valid] ;
        data.dataset.clss_train = [clss_train; clss_valid] ;
        data.dataset.graphs_test = graphs_test ;
        data.dataset.clss_test = clss_test ;        
                
    otherwise
        error('load_data:incorrectDataset', ...
            'Error.\nNot implemented dataset %s.', name)
    end % switch
    
    disp('Dataset loaded.')

end % function