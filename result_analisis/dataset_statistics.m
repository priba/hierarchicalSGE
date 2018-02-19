function [] = dataset_statistics(dataset_name, sub_dataset, dataset_path)
    
    function classStatistics(clss)
        classes = unique(clss) ;
        fprintf('\t* Classes: %d ( ', length(classes)) ;
        for c = classes'
            fprintf('%d: %d;\t', c, sum(c==clss))
        end % for
        fprintf(' )\n') ;
    end % function

    function graphStatistics(graphs)
        avg_nodes = 0 ;
        avg_edges = 0 ;
        node_labels = [] ;
        for g = graphs
            avg_nodes = avg_nodes + size(g.am,1) ;
            avg_edges = avg_edges + sum(g.am(:)) ;
            node_labels = unique([ node_labels; unique(g.nl.values) ]) ;
        end
        avg_nodes = avg_nodes/length(graphs) ;
        avg_edges = avg_edges/length(graphs) ;
        
        fprintf('\t* Avg.V: %f\n', avg_nodes) ;
        fprintf('\t* Avg.E: %f\n', avg_edges) ;
        fprintf('\t* Node labels: %d\n', length(node_labels)) ;
    end % function

    % Load dataset
    data = load_data(dataset_name, sub_dataset, dataset_path) ;
    dataset = data.dataset ;
    
    fprintf('Dataset %s\n\t* Type: %s\n', dataset.name, data.type) ;
    
    switch(lower(data.type))
        case 'partition'
            fields = fieldnames(dataset) ;
            ind = strfind(fields,'clss') ;
            ind = find(not(cellfun('isempty', ind)));
            clss = [] ;
            graphs = [];
            for i = ind'
                partition = fields{i} ;
                partition = strrep(partition,'clss_', '') ;
                fprintf('* Partition: %s\n', partition) ;
                
                clss_partition = getfield(dataset, ['clss_' partition]) ;
                fprintf('\t* Graphs: %d\n', length(clss_partition)) ;
                classStatistics(clss_partition) ;
                
                graphs_partition = getfield(dataset, ['graphs_' partition]) ;
                graphStatistics(graphs_partition) ;
                
                clss = [clss; clss_partition] ; 
                graphs = [graphs, graphs_partition] ; 
            end % for
            fprintf('* Global\n') ;
            fprintf('\t* Graphs: %d\n', length(clss)) ;
            classStatistics(clss) ;
            graphStatistics(graphs) ;
        case 'kfold'
            fprintf('\t* Graphs: %d\n', length(dataset.clss)) ;
            clear data

            classStatistics(dataset.clss) ;

            graphStatistics(dataset.graphs) ;
        otherwise
            error('dataset_statistic:incorrectType', ...
            'Error.\nNot implemented type %s.', data.type)
    end % switch
    
end % function
