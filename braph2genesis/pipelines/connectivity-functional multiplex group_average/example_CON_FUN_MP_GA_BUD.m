%EXAMPLE_CON_FUN_MP_GA_BUD
% Script example pipeline CON FUN MP GA BUD

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr1 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_1_XLS.CON'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1_CON = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_2_XLS.CON'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2_CON = im_gr2.get('GR');

%% Load Groups of SubjectFUN
im_gr1 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_1_XLS.FUN'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1_FUN = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_2_XLS.FUN'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2_FUN = im_gr2.get('GR');

%% Combine Groups of SubjectCON with Groups of SubjectFUN
co_gr1 = CombineGroups_CON_FUN_MP( ...
    'GR_CON', gr1_CON, ...
    'GR_FUN', gr1_FUN, ...
    'WAITBAR', true ...
    );

gr1 = co_gr1.get('GR_CON_FUN_MP');

co_gr2 = CombineGroups_CON_FUN_MP( ...
    'GR_CON', gr2_CON, ...
    'GR_FUN', gr2_FUN, ...
    'WAITBAR', true ...
    );

gr2 = co_gr2.get('GR_CON_FUN_MP');

%% Analysis CON FUN MP GA BUD
densities = 5:5:15;

a_BUD1 = AnalyzeGroup_CON_FUN_MP_GA_BUD( ...
    'GR', gr1, ...
    'DENSITIES', densities ...
    );

a_BUD2 = AnalyzeGroup_CON_FUN_MP_GA_BUD( ...
    'TEMPLATE', a_BUD1, ...
    'GR', gr2, ...
    'DENSITIES', densities ...
    );

% measure calculation
g_BUD1 = a_BUD1.memorize('G'); % essential to memorize in case there are measures with non-default rules
mpc_BUD1 = g_BUD1.get('MEASURE', 'MultiplexP').get('M');
mpc_av_BUD1 = g_BUD1.get('MEASURE', 'MultiplexPAv').get('M');
edgeov_BUD1 = g_BUD1.get('MEASURE', 'EdgeOverlap').get('M');

g_BUD2 = a_BUD2.get('G');
mpc_BUD2 = g_BUD2.get('MEASURE', 'MultiplexP').get('M');
mpc_av_BUD2 = g_BUD2.get('MEASURE', 'MultiplexPAv').get('M');
edgeov_BUD2 = g_BUD2.get('MEASURE', 'EdgeOverlap').get('M');

% comparison
c_BUD = CompareGroup( ...
    'P', 10, ...
    'A1', a_BUD1, ...
    'A2', a_BUD2, ...
    'WAITBAR', true, ...
    'VERBOSE', false, ...
    'MEMORIZE', true ...
    );

mpc_BUD_diff = c_BUD.get('COMPARISON', 'MultiplexP').get('DIFF');
mpc_BUD_p1 = c_BUD.get('COMPARISON', 'MultiplexP').get('P1');
mpc_BUD_p2 = c_BUD.get('COMPARISON', 'MultiplexP').get('P2');
mpc_BUD_cil = c_BUD.get('COMPARISON', 'MultiplexP').get('CIL');
mpc_BUD_ciu = c_BUD.get('COMPARISON', 'MultiplexP').get('CIU');

mpc_av_BUD_diff = c_BUD.get('COMPARISON', 'MultiplexPAv').get('DIFF');
mpc_av_BUD_p1 = c_BUD.get('COMPARISON', 'MultiplexPAv').get('P1');
mpc_av_BUD_p2 = c_BUD.get('COMPARISON', 'MultiplexPAv').get('P2');
mpc_av_BUD_cil = c_BUD.get('COMPARISON', 'MultiplexPAv').get('CIL');
mpc_av_BUD_ciu = c_BUD.get('COMPARISON', 'MultiplexPAv').get('CIU');

edgeov_BUD_diff = c_BUD.get('COMPARISON', 'EdgeOverlap').get('DIFF');
edgeov_BUD_p1 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P1');
edgeov_BUD_p2 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P2');
edgeov_BUD_cil = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIL');
edgeov_BUD_ciu = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIU');