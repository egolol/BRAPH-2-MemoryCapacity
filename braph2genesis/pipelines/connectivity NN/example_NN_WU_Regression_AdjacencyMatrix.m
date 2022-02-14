%EXAMPLE_CON_NN_WU_REGRESSION
% Script example pipeline for connectivity data with NN using GraphWU for regression.  

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'desikan_atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON as a Training Set
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr_train = im_gr.get('GR');

%% Construct the Dataset
nnd_train = NNRegressorData_CON_WU( ...
    'GR', gr_train, ...
    'SPLIT', 0.2, ...
    'TARGET_NAME', 'age', ...
    'FEATURE_MASK', 0.05 ...
    );

%% Train the Model
regressor = NNRegressorDNN( ...
    'NNDATA', nnd_train, ...
    'VERBOSE', true, ...
    'SHUFFLE', 'every-epoch' ...
    );
regressor.memorize('MODEL');

%% Evaluate the Model with the Training Set
nne_train = NNRegressorEvaluator( ...
    'NNDATA', nnd_train, ...
    'NN', regressor, ...
    'PLOT_MAP', true ...
    );

prediction_train = nne_train.memorize('PREDICTION');
rmse_train = nne_train.get('RMSE')
map = nne_train.get('FEATURE_MAP');

prediction_val = nne_train.memorize('VAL_PREDICTION');
rmse_val = nne_train.get('VAL_RMSE')

%% Load Groups of SubjectCON as a Testing Set 
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr_test = im_gr.get('GR');

%% Evaluate the Trained Model with the Testing dataset
nnd_test = NNRegressorData_CON_WU( ...
    'GR', gr_test, ...
    'TARGET_NAME', 'age', ...
    'FEATURE_MASK', nnd_train.get('FEATURE_MASK') ...
    );

nne_test = NNRegressorEvaluator( ...
    'NNDATA', nnd_test, ...
    'NN', regressor ...
    );

prediction_test = nne_test.memorize('PREDICTION')
rmse_test = nne_test.get('RMSE')

close all