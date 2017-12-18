function [ global_var ] = graphlet_embedding( graph , graph_id , M , global_var, MAX2 , node_label ) 
%GRAPHLET_EMBEDDING Summary of this function goes here
%   Detailed explanation goes here

    switch lower(node_label)
        case 'unlabel'
            [ global_var ] = unlabelled_graphlet_embedding(graph , graph_id , M , global_var, MAX2 ) ;
        case 'label'
            [ global_var ] = labelled_graphlet_embedding(graph , graph_id , M , global_var, MAX2-2 ) ;
        otherwise
            error('graphlet_embedding:incorrectOption', 'Error. \nNode label must be "unlabel" or "label", not %s', node_label)
    end ;

end

