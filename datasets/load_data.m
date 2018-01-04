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
        
        % Removing the edge labels 
        NCI1 = rmfield(NCI1, 'el') ;
        
        % Equalizing size of edge labels by padding with zeros
%         for i = 1:size(NCI1, 2)
%             s2 = max(cellfun(@(x) size(x,2), NCI1(i).el.values)) ;
%             sz_vals = size(NCI1(i).el.values, 1) ;
%             el_val = zeros(sz_vals, s2) ;
%             for j = 1:sz_vals
%                 el_val(j, :) = [NCI1(i).el.values{j}, zeros(1, s2 - size(NCI1(i).el.values{j}, 2))] ;
%             end
%             NCI1(i).el.values = el_val ;
%         end

        data.dataset.graphs = NCI1 ;
        data.type = 'kfold' ;
    case 'NCI109'
        disp('Loading NCI109...') ;
        load(fullfile(path, 'NCI109.mat')) ;
        data.dataset.name = 'NCI109' ;
        data.dataset.clss = lnci109 ;
        
        % Removing the edge labels
        NCI109 = rmfield(NCI109, 'el') ;
        
        % Equalizing size of edge labels by padding with zeros
%         for i = 1:size(NCI109, 2)
%             s2 = max(cellfun(@(x) size(x,2), NCI109(i).el.values)) ;
%             sz_vals = size(NCI109(i).el.values, 1) ;
%             el_val = zeros(sz_vals, s2) ;
%             for j = 1:sz_vals
%                 el_val(j, :) = [NCI109(i).el.values{j}, zeros(1, s2 - size(NCI109(i).el.values{j}, 2))] ;
%             end
%             NCI109(i).el.values = el_val ;
%         end
        
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
        
    otherwise
        error('load_data:incorrectDataset', ...
            'Error.\nNot implemented dataset %s.', name)
    end % switch
    
    disp('Dataset loaded.')

end % function
