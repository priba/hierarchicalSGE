function remove_paths()

    % External Libraries
    libpaths = set_paths( ) ;
    
    path_matlabbgl = [ libpaths.matlabbgl 'matlab_bgl' ] ;
    path_libsvm = [ libpaths.libsvm 'libsvm/matlab/' ] ;
    
    rmpath(path_matlabbgl) ;
    rmpath(path_libsvm) ;
    
    % Local Folders
    rmpath('./clustering/')
    rmpath('./datasets/')
    rmpath('./hierarchy/')
    rmpath('./graphlet_sampler/')
    
end
    
