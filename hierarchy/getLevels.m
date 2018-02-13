function [ G ] = getLevels( H , leveli, levelj )
%GETLEVEL Return the specific levals as only one graph
%   
    function [G1] = joinLevels( G1, G2 )
        %JOINLEVELS Joins two levels w/o hierarchical edges
        
        if G1.levels == 0
            G1 = G2 ;
            G1.levels = 1 ;
            G1.szLevels = [size(G2.am,1)] ;
        else
            G1.am = [ G1.am , zeros(size(G1.am,1),size(G2.am,1)); ...
                zeros(size(G2.am,1), size(G1.am,1)), G2.am ] ;
            G1.nl.values = [ G1.nl.values ; G2.nl.values ] ;
            G1.levels = G1.levels + 1 ;
            G1.szLevels(end+1) = G1.szLevels(end) + size(G2.am,1) ;
        end % if
        
    end % function

    function [H] = initHierarchy( )
        %INITHIERARCHY Initialize an empty hierarchical graph
        H.am = [ ] ;
        H.nl.values = [ ] ;
        H.levels = 0 ;
        H.szLevels = [ ] ;
    end % function

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

    % Get level
    if nargin == 2
        levelj = leveli ;
    end
    
    if leveli>H.levels || levelj>H.levels
        error('getLevel:incorrectLevel', ...
            'Error.\nHierarchical graph only has %d Levels.', H.levels)
    end % if
    
    % leveli considered smaller than levelj
    if levelj<leveli
        aux = levelj ;
        levelj = leveli ;
        leveli = aux ;
    end % if

    [G] = initHierarchy( ) ;
    for l = leveli:levelj
        G_aux = getLevel( H , l ) ;
        [G] = joinLevels( G, G_aux ) ;
    end % for
    
end % function

