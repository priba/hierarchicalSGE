function [] = generate_summary(result_folder)
    output_files = dir([ result_folder, '*_run.csv']) ;

    fileId = fopen([ result_folder, 'summary.csv'], 'w') ;   
    % Header
    fprintf(fileId,'Epsilon;Delta;T;Labelled;Levels;Reduction;Edge_Threshold;Clustering;Config;Iterations;;Mean;Std\n') ;

    for out_file = output_files'
        text = fileread([result_folder, out_file.name]) ;
        % Header
        fprintf(fileId, text) ;
    end ; % for

    fclose(fileId);
end % function
