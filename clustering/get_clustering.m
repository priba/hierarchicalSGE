function [ clustering_func ] = get_clustering( clustering )
%GET_CLUSTERING Summary of this function goes here
%   Detailed explanation goes here

    switch lower(clustering)
        case 'girvan_newman'
            clustering_func = @girvan_newman ;
        case 'grpartition'
            mfilepath=fileparts(which(mfilename));
            addpath(fullfile(mfilepath,'/graphpartition'));
            clustering_func = @grPartition ;
            rmpath(fullfile(mfilepath,'/graphpartition'));
        otherwise
            error('get_clustering:incorrectClustering', ...
                'Error.\nNot implemented clustering function %s.', clustering)
    end ; % switch

end

