function subclass_list = subclasses(class_name, directory, search_subdirectories)
% SUBCLASSES searches for all the subclasses of a class.
%
% LIST = SUBCLASSES(CLASS_NAME) searches for all the subclasses of class
% CLASS_NAME within BRAPH2.
%
% LIST = SUBCLASSES(CLASS_NAME,  PATH) searches for all the subclasses of
% class CLASS_NAME inside the directory PATH. 
%
% LIST = SUBCLASSES(CLASS_NAME,  PATH, SEARCH_SUBDIR) searches for all the
% subclasses of class CLASS_NAME inside the directory PATH and its
% subdirectories.
%
% See also SUPERCLASSES.

if nargin < 3  % by default it does not search subdirectories
    search_subdirectories = false;
end

if nargin < 2  % if no directory, searches all BRAPH2
    directory = fileparts(which('braph2'));  % retrieves the base directory of BRAPH
    search_subdirectories = true;
end

% extracts all subclasses of class_name in current directory
struc = what(directory);  % retrieves all files inside directory
subclass_list = cell(1, length(struc.m));  % creates a cell
for i = 1:1:length(struc.m)  % selects all files *.m
    file = struc.m{i};  % assigns the i name to file variable
    [~, name] = fileparts(file);

    is_class = exist(name, 'class') == 8;  % true is file is a class
    if is_class && any(strcmp(superclasses(name), class_name))  % compares any name relation
        subclass_list{i} = name;  % fills cell with names of subclasses
    end
end
subclass_list(cellfun('isempty', subclass_list)) = [];

% iterates on subdirectories
if search_subdirectories
    directory_contents = dir(directory);  % get the folder contents
    subdirectories = directory_contents([directory_contents(:).isdir] == 1);  % remove all files (isdir property is 0)
    subdirectories = subdirectories(~ismember({subdirectories(:).name}, {'.', '..'}));  % remove '.' and '..'
    
    for i = 1:1:length(subdirectories)
        list_subclasses_in_subdirectory = subclasses(class_name, [directory filesep subdirectories(i).name], true);
        if ~isempty(list_subclasses_in_subdirectory)
            subclass_list = [subclass_list; list_subclasses_in_subdirectory]; %#ok<AGROW>
        end
    end
end

end