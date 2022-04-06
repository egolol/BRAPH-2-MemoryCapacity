%% EXAMPLE_NN_CON_WU_CLASSIFICATION_ADJACENCYMATRIX
% Script example pipeline for NN classification with the input of adjacency matrix

clear variables %#ok<*NASGU>

%% Load brain atlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('example_NN_CON_WU_Classification_AdjacencyMatrix')) filesep 'example data CON (DTI)' filesep 'desikan_atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load groups of SubjectCON
im_gr1 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_NN_CON_WU_Classification_AdjacencyMatrix')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_NN_CON_WU_Classification_AdjacencyMatrix')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName2'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2 = im_gr2.get('GR');

%% Construct the dataset
nnd1 = NNData_CON_WU( ...
    'GR', gr1, ...
    'INPUT_TYPE', 'adjacency_matrices', ...
    'TARGET_NAME', gr1.get('ID'), ...
    'WAITBAR', true ...
    );

gr1_nn = nnd1.get('GR_NN');

nnd2 = NNData_CON_WU( ...
    'GR', gr2, ...
    'INPUT_TYPE', 'adjacency_matrices', ...
    'TARGET_NAME', gr2.get('ID'), ...
    'WAITBAR', true ...
    );

gr2_nn = nnd2.get('GR_NN');

%% Split the dataset
nnds = NNClassifierDataSplit( ...
    'GR1', gr1_nn, ...
    'GR2', gr2_nn, ...
    'SPLIT_GR1', 0.2, ...
    'SPLIT_GR2', 0.2, ...
    'FEATURE_MASK', 0.05, ...
    'WAITBAR', true ...
    );

gr_train = nnds.get('GR_TRAIN_FS');
gr_val = nnds.get('GR_VAL_FS');

%% Train the neural network classifier with the training set
classifier = NNClassifierDNN( ...
    'GR', gr_train, ...
    'VERBOSE', false, ...
    'PLOT_TRAINING', false, ...
    'SHUFFLE', 'every-epoch' ...
    );
classifier.memorize('MODEL');

%% Evaluate the classifier for the training set
nne_train = NNClassifierEvaluator( ...
    'GR', gr_train, ...
    'NN', classifier, ...
    'PLOT_CM', true, ...
    'PLOT_ROC', true, ...
    'PLOT_MAP', true ...
    );

auc_train = nne_train.get('AUC');
cm_train = nne_train.get('CONFUSION_MATRIX');
%map = nne_train.get('FEATURE_MAP'); %TODO: visualize for all cases

%% Evaluate the classifier for the validation set
nne_val = NNClassifierEvaluator( ...
    'GR', gr_val, ...
    'NN', classifier, ...
    'PLOT_CM', true, ...
    'PLOT_ROC', true, ...
    'PLOT_MAP', true ...
    );

auc_val = nne_val.get('AUC');
cm_val = nne_val.get('CONFUSION_MATRIX');

%% Load another groups of subjectCON
im_gr1 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_NN_CON_WU_Classification_AdjacencyMatrix')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1_unseen = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_NN_CON_WU_Classification_AdjacencyMatrix')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName2'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2_unseen = im_gr2.get('GR');

%% Construct the datatset
nnd1_unseen = NNData_CON_WU( ...
    'GR', gr1_unseen, ...
    'INPUT_TYPE', 'adjacency_matrices', ...
    'TARGET_NAME', gr1_unseen.get('ID'), ...
    'WAITBAR', true ...
    );

gr1_unseen_nn = nnd1_unseen.get('GR_NN');

nnd2_unseen = NNData_CON_WU( ...
    'GR', gr2_unseen, ...
    'INPUT_TYPE', 'adjacency_matrices', ...
    'TARGET_NAME', gr2_unseen.get('ID'), ...
    'WAITBAR', true ...
    );

gr2_unseen_nn = nnd2_unseen.get('GR_NN');

%% Evaluate the classifier for the testing set
nnds_test = NNClassifierDataSplit( ...
    'GR1', gr1_unseen_nn, ...
    'GR2', gr2_unseen_nn, ...
    'SPLIT_GR1', 1.0, ...
    'SPLIT_GR2', 1.0, ...
    'FEATURE_MASK', nnds.get('FEATURE_SELECTION_ANALYSIS'), ...
    'WAITBAR', true ...
    );

gr_test = nnds_test.get('GR_VAL_FS');

nne_test = NNClassifierEvaluator( ...
    'GR', gr_test, ...
    'NN', classifier ...
    );

auc_test = nne_test.get('AUC');
cm_test = nne_test.get('CONFUSION_MATRIX');

close all