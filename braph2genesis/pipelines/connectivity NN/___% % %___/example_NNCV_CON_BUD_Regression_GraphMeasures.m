%% EXAMPLE_NNCV_CON_BUD_REGRESSION_GRAPHMEASURES
% Script example pipeline for NN regression with the input of graph measures 

clear variables %#ok<*NASGU>

%% Load brain atlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('example_NN_CON_WU_Regression_AdjacencyMatrix')) filesep 'example data CON NN' filesep 'regression' filesep 'desikan_atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load group of SubjectCON
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_NN_CON_WU_Regression_AdjacencyMatrix')) filesep 'example data CON NN' filesep 'regression' filesep 'xls' filesep 'GroupName'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr = im_gr.get('GR');

%% Construct the dataset
nnd = NNData_CON_BUD( ...
    'GR', gr, ...
    'INPUT_TYPE', 'graph_measures', ...
    'TARGET_NAME', 'age', ...
    'DENSITIES', [50 100], ...
    'WAITBAR', true ...
    );

nnd.getMeasureEnsemble('DegreeAv');
nnd.getMeasureEnsemble('Eccentricity');
gr_nn = nnd.get('GR_NN');

%% Initiate the cross validation analysis
nncv = NNRegressorCrossValidation( ...
    'GR', gr_nn, ...
    'EPOCHS', 100, ...
    'KFOLD', 5 ...
    );

%% Evaluate the Performance
gr_cv = nncv.get('GR_PREDICTION');
rmse_cv = nncv.get('RMSE');

close all