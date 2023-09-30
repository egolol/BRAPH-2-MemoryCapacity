%% EXAMPLE_NNCV_CON_BUT_REG
% Script example pipeline for NN classification cross-validation with the input of GraphBUT derived from SubjectCON 

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('NNDataPoint_CON_REG')) filesep 'Example data NN REG CON XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('NNDataPoint_CON_REG')) filesep 'Example data NN REG CON XLS' filesep 'CON_Group_XLS'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr = im_gr.get('GR');

%% Analysis CON BUT
thresholds = .7;
graph_temp = MultigraphBUT('THRESHOLDS', thresholds);
a_BUT = AnalyzeEnsemble_CON_BUT( ...
    'GRAPH_TEMPLATE', graph_temp, ...
    'GR', gr ...
    );

a_BUT.memorize('G_DICT');

%% create item lists of NNDataPoint_Graph_REG
it_list = cellfun(@(g, sub) NNDataPoint_Graph_REG( ...
    'ID', sub.get('ID'), ...
    'G', g, ...
    'SUB', sub, ...
    'TARGET_IDS', sub.get('VOI_DICT').get('KEYS')), ...
    a_BUT.get('G_DICT').get('IT_LIST'), gr.get('SUB_DICT').get('IT_LIST'),...
    'UniformOutput', false);

% create NNDataPoint_Graph_REG DICT items
dp_list = IndexedDictionary(...
        'IT_CLASS', 'NNDataPoint_Graph_REG', ...
        'IT_LIST', it_list ...
        );

% create a NNDataset containing the NNDataPoint_Graph_REG DICT
d = NNDataset( ...
    'DP_CLASS', 'NNDataPoint_Graph_REG', ...
    'DP_DICT', dp_list ...
    );


%% Create a regressor cross-validation
nne_template = NNRegressorMLP_Evaluator('P', 2);
nncv = NNRegressorMLP_CrossValidation('D', {d}, 'KFOLDS', 2, 'NNEVALUATOR_TEMPLATE', nne_template);
nncv.get('TRAIN');

%% Evaluate the performance
av_corr_coeff = nncv.get('AV_CORR');
av_coeff_determination = nncv.get('AV_DET');
av_mae = nncv.get('AV_MAE');
av_mse = nncv.get('AV_MSE');
av_rmse = nncv.get('AV_RMSE');
av_fi = nncv.get('AV_FEATURE_IMPORTANCE');