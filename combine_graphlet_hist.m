function [ hist ] = combine_graphlet_hist( histogram, t, combine_graphlet )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if strcmpi(combine_graphlet, 'combine')
        temp = cellfun(@(x) x(1:t), histogram, 'UniformOutput', false) ;
        if ~isempty(temp)
            temp = cat(2, temp{:}) ;
            if ~isempty(temp)
                hist = cat(2, temp{:});
            else
                hist = [] ;
            end
        else
            hist = [] ;
        end
        
    else
        temp = cellfun(@(x) x(t), histogram) ;
        if ~isempty(temp)
            hist = cat(2, temp{:}) ;
        else
            hist = [] ;
        end ;
    end ;

end

