function remove_paths()

    libpaths = set_paths( ) ;
    
    path_matlabbgl = [ libpaths.matlabbgl 'matlab_bgl' ] ;
    path_libsvm = [ libpaths.libsvm 'libsvm/matlab/' ] ;
    
    rmpath(path_matlabbgl) ;
    rmpath(path_libsvm) ;
    
end
    
