function [ParentDir, filename]=getfilename(fname)
CurrentDir=fname;
fsep = filesep;
pos_v = strfind(CurrentDir,fsep);
ParentDir= CurrentDir(1:pos_v(length(pos_v))-1);
filename_ext=CurrentDir(pos_v(length(pos_v))+1:length(CurrentDir));
pos_ext=strfind(filename_ext,'.');
filename=filename_ext(1:pos_ext-1);
end