function [ hist ] = combine_graphlet_hist( histogram, t, combine_graphlet )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if strcmpi(combine_graphlet, 'combine')
        temp = cellfun(@(x) x(1:t), histogram, 'UniformOutput', false) ;
        temp = cat(2, temp{:}) ;
        hist = cat(2, temp{:});
    else
        temp = cellfun(@(x) x(t), histogram) ;
        hist = cat(2, temp{:}) ;        
    end ;

end

