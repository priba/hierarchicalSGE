function [ ] = analyze_results( result_folder, k )
%ANALYZE_RESULTS Summary of the results

    % Generate summary file
    generate_summary(result_folder)
    
    % Generate statistics
    generate_statistics(result_folder, k)
end

