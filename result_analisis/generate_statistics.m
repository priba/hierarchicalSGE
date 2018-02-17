function [] = generate_statistics(result_folder , k)

    if nargin < 2
        k = 5 ;
    end ; % if
    
    function print_statistics(T)
        summary(T(:, {'Mean', 'Std'}))

        [~ , ind] = sort(T.Mean,'descend') ;

        fprintf('Top %d:', k);
        T(ind(1:k),:)
    end % function

    function T = embedding_size(T)
        possible_graphlets = [1, 1, 3, 5, 12, 30, 79, 227, 710, 2322] ;
        bc_collision = [0, 0, 0, 0, 0, 0, 1, 5, 27, 108] ;
        sz_emb = possible_graphlets - bc_collision ;
        total_size = zeros(size(T,1),1) ;
        for i = 1:size(T,1)
            t = table2array(T(i, {'T'})) ;
            t = str2num(t{1}) ;
            
            c = table2array(T(i, {'Config'})) ;
            
            pyr_levels = table2array(T(i, {'Levels'})) ;
            
            for j = 1:length(t)  
                level = t(j) ;
                switch lower(c{1})
                    case 'comb'
                        sz = (pyr_levels - j + 1) * sum(sz_emb(3:level)) ; 
                    case 'level_pyr'
                        sz = (pyr_levels - j + 1) * sum(sz_emb(3:level)) ;      
                    case 'hier'
                        sz = (pyr_levels - j) * sum(sz_emb(3:level)) ;
                    case 'level'
                        sz = sum(sz_emb(3:level)) ;
                    case 'base'
                        if j == 1
                            sz = sum(sz_emb(3:level)) ;
                        else
                            sz = 0 ;
                        end
                    otherwise
                        error('generate_statistics:get_parts:incorrectConfig', ...
                            'Error.\nNot implemented config %s.', config)
                end % switch
                
                total_size(i) = total_size(i) + sz
            end % for
        end
        T = [ T array2table(total_size)]; 
    end % function
    
    T = readtable( fullfile( result_folder , 'summary.csv' ) ) ;
    
    try
        T.Var11 = [];
    catch
        fprintf('No empty column');
    end ; % try-catch
    
    % Whole Data
    fprintf('Whole Data:');
    print_statistics(T)
    
    for label = {'label', 'unlabel'}
        split_ind = strcmpi(T.Labelled, label{1}) ;
        T_aux = T(split_ind,:) ;
        
        % Compute embedding length for unlabelled graph
        if strcmpi(label, 'unlabel')
            T_aux = embedding_size(T_aux) ;
        end % if
        
        fprintf('\n------------------------------------------------------\n');
        
        fprintf([label{1}, ':']);
        print_statistics(T_aux)
        
        fprintf('Base:');
        split_ind = strcmpi(T_aux.Config, 'base') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end        
        fprintf('Level:');
        split_ind = strcmpi(T_aux.Config, 'level') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end  
        fprintf('Level_Pyr:');
        split_ind = strcmpi(T_aux.Config, 'level_pyr') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end
        fprintf('2Level_Pyr:');
        split_ind = strcmpi(T_aux.Config, '2level_pyr') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end
        fprintf('Hier:');
        split_ind = strcmpi(T_aux.Config, 'hier') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end  
        fprintf('Comb:');
        split_ind = strcmpi(T_aux.Config, 'comb') ;
        if ~any(split_ind)
            fprintf(' None\n') ;
        else
            print_statistics(T_aux(split_ind,:))            
        end  
    end % for
    
end % function
