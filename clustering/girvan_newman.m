function [ cluster ] = girvan_newman( A , lambda )
%GIRVAN_NEWMAN Summary of this function goes here
%   Detailed explanation goes here

    if lambda > size(A,1) || lambda < 1
        error('Not a correct lambda size')
    end;
    
    % Make it undirected
    A = (A + A')/2;
    
    % Make it sparse
    if ~issparse( A )
        A = sparse(A) ;
    end ;
    
    while num_components(A) < lambda
        [~ , ec] = betweenness_centrality( A );
        [~ , idx] = max(ec(:));
        [x , y] = ind2sub(size(A),idx);
        A(x,y) = 0; A(y,x) = 0;
    end;
    
    cluster = components(A);
end

function n = num_components( A )
    [ ~ , sizes] = components(A) ;
    n = length(sizes);
end