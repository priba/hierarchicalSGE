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
    
    split_ind = strcmpi(T.Labelled, 'label') ;
    
    fprintf('Unlabel:');
    print_statistics(T(~split_ind,:))
    fprintf('Label:');
    print_statistics(T(split_ind,:))
    
end % function
