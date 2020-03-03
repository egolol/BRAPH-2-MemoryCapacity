% test clean_varargin

%% Test 1: Empty
handles = {'h1', 'h2', 'h3'};
varargin = {};

assert(isequal(clean_varargin(handles, varargin{:}), varargin), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case empty.')

assert(isequal(clean_varargin(handles, varargin), varargin), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case empty.')

%% Test 2: Already clean
handles = {'h1', 'h2', 'h3'};
varargin = {'h1', 1, 'h2', 2, 'h3', 3};

assert(isequal(clean_varargin(handles, varargin{:}), varargin), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case already clean.')

assert(isequal(clean_varargin(handles, varargin), varargin), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case already clean.')

%% Test 3: Need some cleaning
handles = {'h1', 'h2', 'h3'};
varargin = {'e1', -1, 'h1', 1, 'e2', -2, 'h2', 2, 'e3', -3, 'h3', 3, 'e4', -4};

assert(isequal(clean_varargin(handles, varargin{:}), {'h1', 1, 'h2', 2, 'h3', 3}), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case needing cleaning.')

assert(isequal(clean_varargin(handles, varargin), {'h1', 1, 'h2', 2, 'h3', 3}), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case needing cleaning.')

%% Test 4: Need complete cleaning
handles = {'h1', 'h2', 'h3'};
varargin = {'e1', -1, 'e2', -2, 'e3', -3, 'e4', -4};

assert(isempty(clean_varargin(handles, varargin{:})), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case needing complete cleaning.')

assert(isempty(clean_varargin(handles, varargin)), ...
    'BRAPH:clean_varargin:Bug', ...
    'Not working case needing complete cleaning.')