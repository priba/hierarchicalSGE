function add_paths()

    libpaths = set_paths( ) ;
    
    path_matlabbgl = [ libpaths.matlabbgl 'matlab_bgl' ] ;
    path_libsvm = [ libpaths.libsvm 'libsvm/matlab/' ] ;
    path_vlfeat = [ libpaths.vlfeat 'vlfeat/toolbox/vl_setup.m' ] ;
    
    addpath(path_matlabbgl) ;
    addpath(path_libsvm) ;
    run(path_vlfeat) ;
    
end
