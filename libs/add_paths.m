function add_paths()

    % External Libraries
    libpaths = set_paths( ) ;
    
    path_matlabbgl = [ libpaths.matlabbgl 'matlab_bgl' ] ;
    path_libsvm = [ libpaths.libsvm 'libsvm/matlab/' ] ;
    path_vlfeat = [ libpaths.vlfeat 'vlfeat/toolbox/vl_setup.m' ] ;
    
    addpath(path_matlabbgl) ;
    addpath(path_libsvm) ;
    run(path_vlfeat) ;
    
    % Local Folders
    addpath('./clustering/')
    addpath('./datasets/')
    addpath('./hierarchy/')
    addpath('./graphlet_sampler/')
    
end
