function [file_names,classes] = read_histograph_txt(filename)

fp = fopen(filename) ;
S = textscan(fp,'%s %s') ;
fclose(fp) ;

file_names = S{2} ;
file_names = cellfun(@(x) [x, '.gxl'], file_names, 'UniformOutput', false);
classes = S{1} ;

end