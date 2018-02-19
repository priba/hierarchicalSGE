function [] = dataset_statistics(dataset_name, sub_dataset, dataset_path)
    
    function classStatistics(clss)
        classes = unique(clss) ;
        fprintf('\t* Classes: %d ( ', length(classes)) ;
        for i = classes'
            fprintf('%d: %d;\t', i, sum(i==clss))
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
    
    fprintf('Dataset %s\n\t* Type: %s\n\t* Graphs: %d\n', dataset.name, data.type, length(dataset.clss)) ;
    clear data
    
    classStatistics(dataset.clss) ;
    
    graphStatistics(dataset.graphs)
    
end % function
