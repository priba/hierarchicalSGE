function [ G ] = getLevel( H , level )
%GETLEVEL Return a specific level of the hierarchy
%   

    if level>H.levels
        error('getLevel:incorrectLevel', ...
            'Error.\nHierarchical graph only has %d Levels.', H.levels)
    end % if
    
    if level==1
        start = 1 ;
    else
        start = H.szLevels(level-1)+1 ;
    end % if
    
    G.am = H.am( start:H.szLevels(level) , start:H.szLevels(level)) ;
    G.nl.values = H.nl.values( start:H.szLevels(level), :) ;
    
end % function

