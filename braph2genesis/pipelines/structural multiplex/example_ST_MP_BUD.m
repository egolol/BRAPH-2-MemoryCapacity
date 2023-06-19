%EXAMPLE_ST_MP_BUD
% Script example pipeline ST MP BUD

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('SubjectST_MP')) filesep 'Example data ST_MP XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectST_MP
im_gr1 = ImporterGroupSubjectST_MP_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectST_MP')) filesep 'Example data ST_MP XLS' filesep 'ST_MP_Group_1_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectST_MP_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectST_MP')) filesep 'Example data ST_MP XLS' filesep 'ST_MP_Group_2_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2 = im_gr2.get('GR');

%% Analysis ST MP BUD
densities = 5:5:15;
a_BUD1 = AnalyzeGroup_ST_MP_BUD( ...
    'GR', gr1, ...
    'DENSITIES', densities ...
    );

a_BUD2 = AnalyzeGroup_ST_MP_BUD( ...
    'GR', gr2, ...
    'DENSITIES', densities ...
    );

% measure calculation
g_BUD1 = a_BUD1.get('G');
degree_BUD1 = g_BUD1.get('MEASURE', 'Degree').get('M');
% % % ovdegree_BUD1 = g_BUD1.get('MEASURE', 'OverlappingDegree').get('M');
% % % ovdegree_av_BUD1 = g_BUD1.get('MEASURE', 'OverlappingDegreeAv').get('M');
% % % edgeov_BUD1 = g_BUD1.get('MEASURE', 'EdgeOverlap').get('M');

g_BUD2 = a_BUD2.get('G');
degree_BUD2 = g_BUD2.get('MEASURE', 'Degree').get('M');
% % % ovdegree_BUD2 = g_BUD2.get('MEASURE', 'OverlappingDegree').get('M');
% % % ovdegree_av_BUD2 = g_BUD2.get('MEASURE', 'OverlappingDegreeAv').get('M');
% % % edgeov_BUD2 = g_BUD2.get('MEASURE', 'EdgeOverlap').get('M');

% comparison
c_BUD = CompareGroup( ...
    'P', 10, ...
    'A1', a_BUD1, ...
    'A2', a_BUD2, ...
    'WAITBAR', true, ...
    'VERBOSE', false, ...
    'MEMORIZE', true ...
    );

degree_BUD_diff = c_BUD.get('COMPARISON', 'Degree').get('DIFF');
degree_BUD_p1 = c_BUD.get('COMPARISON', 'Degree').get('P1');
degree_BUD_p2 = c_BUD.get('COMPARISON', 'Degree').get('P2');
degree_BUD_cil = c_BUD.get('COMPARISON', 'Degree').get('CIL');
degree_BUD_ciu = c_BUD.get('COMPARISON', 'Degree').get('CIU');

% % % ovdegree_BUD_diff = c_BUD.get('COMPARISON', 'OverlappingDegree').get('DIFF');
% % % ovdegree_BUD_p1 = c_BUD.get('COMPARISON', 'OverlappingDegree').get('P1');
% % % ovdegree_BUD_p2 = c_BUD.get('COMPARISON', 'OverlappingDegree').get('P2');
% % % ovdegree_BUD_cil = c_BUD.get('COMPARISON', 'OverlappingDegree').get('CIL');
% % % ovdegree_BUD_ciu = c_BUD.get('COMPARISON', 'OverlappingDegree').get('CIU');

% % % ovdegree_av_BUD_diff = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('DIFF');
% % % ovdegree_av_BUD_p1 = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('P1');
% % % ovdegree_av_BUD_p2 = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('P2');
% % % ovdegree_av_BUD_cil = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('CIL');
% % % ovdegree_av_BUD_ciu = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('CIU');

% % % edgeov_BUD_diff = c_BUD.get('COMPARISON', 'EdgeOverlap').get('DIFF');
% % % edgeov_BUD_p1 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P1');
% % % edgeov_BUD_p2 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P2');
% % % edgeov_BUD_cil = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIL');
% % % edgeov_BUD_ciu = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIU');