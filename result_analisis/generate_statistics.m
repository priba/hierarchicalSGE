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
    
        fprintf('\n------------------------------------------------------\n');
        
        fprintf([label{1}, ':']);
        print_statistics(T_aux)
        
        fprintf('Base:');
        split_ind = strcmpi(T_aux.Config, 'base') ;
        print_statistics(T_aux(split_ind,:))
        fprintf('Level:');
        split_ind = strcmpi(T_aux.Config, 'level') ;
        print_statistics(T_aux(split_ind,:))
        fprintf('Hier:');
        split_ind = strcmpi(T_aux.Config, 'hier') ;
        print_statistics(T_aux(split_ind,:))
        fprintf('Comb:');
        split_ind = strcmpi(T_aux.Config, 'comb') ;
        print_statistics(T_aux(split_ind,:))
    end % for
    
end % function
