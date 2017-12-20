function add_paths(root_path)

    % External Libraries
    libpaths = set_paths( ) ;
    
    path_matlabbgl = [ libpaths.matlabbgl 'matlab_bgl' ] ;
    path_libsvm = [ libpaths.libsvm 'libsvm/matlab/' ] ;
    path_vlfeat = [ libpaths.vlfeat 'vlfeat/toolbox/vl_setup.m' ] ;
    
    addpath(path_matlabbgl) ;
    addpath(path_libsvm) ;
    run(path_vlfeat) ;
    
    % Local Folders
    addpath(fullfile(root_path, '/clustering/')) ;
    addpath(fullfile(root_path, '/datasets/')) ;
    addpath(fullfile(root_path, '/hierarchy/')) ;
    addpath(fullfile(root_path, '/graphlet_sampler/')) ;

end
