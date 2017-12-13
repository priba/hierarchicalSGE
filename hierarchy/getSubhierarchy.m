function [ G ] = getSubhierarchy( H , leveli, levelj )
%GETSUBHIERARCHY Return a part of the hierarchy given two levels
%   

    if leveli>H.levels || levelj>H.levels
        error('getLevel:incorrectLevel', ...
            'Error.\nHierarchical graph only has %d Levels.', H.levels)
    end % if
    
    if levelj==leveli
        G = getLevel( H , leveli ) ;
        G.levels = 1 ;
        G.szLevels = size(G.am,1) ;
    else
        % leveli considered smaller than levelj
        if levelj<leveli
            aux = levelj ;
            levelj = leveli ;
            leveli = aux ;
        end % if
            
        if leveli==1
            start = 1 ;
        else
            start = H.szLevels(leveli-1)+1 ;
        end % if

        G.am = H.am( start:H.szLevels(levelj) , start:H.szLevels(levelj)) ;
        G.nl.values = H.nl.values( start:H.szLevels(levelj), :) ;
        
        G.levels = levelj - leveli +1 ;
        G.szLevels = H.szLevels( leveli:levelj ) ;
        
        if leveli>1
            G.szLevels = G.szLevels - H.szLevels( leveli - 1 ) ;
        end % if
    end % if
    
end % function

