%TEST_BRAPH2 
% This script runs all the unit tests for BRAPH2.

close all
delete(findall(0, 'type', 'figure'))
clear all %#ok<CLALL>

if ispc
    fprintf([ ...
        '\n' ...
        '<strong>@@@@   @@@@    @@@   @@@@   @   @     ####   ####     Ø   Ø Ø   Ø Ø ØØØØØ  ØØØØØ ØØØØ  ØØØØ ØØØØØ \n</strong>' ...
        '<strong>@   @  @   @  @   @  @   @  @   @        #   #  #     Ø   Ø ØØ  Ø Ø   Ø      Ø   Ø    Ø       Ø   \n</strong>' ...
        '<strong>@@@@   @@@@   @@@@@  @@@@   @@@@@     ####   #  #     Ø   Ø Ø Ø Ø Ø   Ø      Ø   ØØØ   ØØØ    Ø   \n</strong>' ...
        '<strong>@   @  @  @   @   @  @      @   @     #      #  #     Ø   Ø Ø  ØØ Ø   Ø      Ø   Ø        Ø   Ø   \n</strong>' ...
        '<strong>@@@@   @   @  @   @  @      @   @     #### # ####      ØØØ  Ø   Ø Ø   Ø      Ø   ØØØØ ØØØØ    Ø   \n</strong>' ...
        '\n' ...
        ]);
else
    fprintf([ ...
        '\n' ...
        ' ████   ████    ███   ████   █   █     ▓▓▓▓   ▓▓▓▓     ▒   ▒ ▒   ▒  ▒  ▒▒▒▒▒   ▒▒▒▒▒ ▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒\n' ...
        ' █   █  █   █  █   █  █   █  █   █        ▓   ▓  ▓     ▒   ▒ ▒▒  ▒  ▒    ▒       ▒   ▒    ▒       ▒  \n' ...
        ' ████   ████   █████  ████   █████     ▓▓▓▓   ▓  ▓     ▒   ▒ ▒ ▒ ▒  ▒    ▒       ▒   ▒▒▒   ▒▒▒    ▒  \n' ...
        ' █   █  █  █   █   █  █      █   █     ▓      ▓  ▓     ▒   ▒ ▒  ▒▒  ▒    ▒       ▒   ▒        ▒   ▒  \n' ...
        ' ████   █   █  █   █  █      █   █     ▓▓▓▓ ▓ ▓▓▓▓      ▒▒▒  ▒   ▒  ▒    ▒       ▒   ▒▒▒▒ ▒▒▒▒    ▒  \n' ...
        '\n' ...
        ]);
end
fprintf([ ...
    ' <a href="matlab:BRAPH2GUI()">' BRAPH2.NAME '</a>' ...
    ' <a href="matlab:BRAPH2.credits()">CREDITS</a>' ...
    ' <a href="matlab:BRAPH2.license()">LICENSE</a>' ...
    ' <a href="matlab:BRAPH2.web()">' upper(BRAPH2.WEB) '</a>\n' ...
    ' version ' BRAPH2.VERSION ' build ' int2str(BRAPH2.BUILD) '\n' ...
    ' ' BRAPH2.COPYRIGHT '\n' ...
    '\n' ...
    ]);

%% Timer start
time_start = tic;

%% Random Seed
seed = randi(intmax('uint32'));
rng(seed, 'twister')

%% Identifies test directories
braph2_dir = fileparts(which('braph2mc'));

directories_to_test = {};

pipelines_dir = [braph2_dir filesep 'pipelines'];
addpath(pipelines_dir)
pipelines_dir_list = dir(pipelines_dir); % get the folder contents
pipelines_dir_list = pipelines_dir_list([pipelines_dir_list(:).isdir] == 1); % remove all files (isdir property is 0)
pipelines_dir_list = pipelines_dir_list(~ismember({pipelines_dir_list(:).name}, {'.', '..'})); % remove '.' and '..'
for i = 1:1:length(pipelines_dir_list)
    directories_to_test{end + 1} = [pipelines_dir filesep pipelines_dir_list(i).name]; %#ok<SAGROW>
end

clear braph2_dir 

%% Runs tests
warning_backup = warning();
results = runtests(directories_to_test, 'UseParallel', false, 'Strict', true);
warning(warning_backup)

%% Shows test results
results_table = table(results) %#ok<NOPTS>

if all([results(:).Passed])
    disp('*** All good! ***')
else
    disp('*** Something went wrong! ***')
    failed_results_table = table(results([results(:).Failed])) %#ok<NOPTS>
end

%% Timer end
time_end = toc(time_start);

disp(['Test performed with random seed ' int2str(seed)])
disp(['The test has taken ' int2str(time_end) '.' int2str(mod(time_end, 1) * 10) 's'])